using System.Net;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using StackExchange.Redis;

namespace AppHost.resources;

/// <summary>
/// Configuração do Redis externo (container que já existe fora do Aspire).
/// </summary>
/// <param name="ConnectionString">Fallback usado quando ConnectionStrings:{name} não está configurada.</param>
/// <param name="RedisUrl">URL exibida no dashboard para o Redis (como o SEU navegador/host enxerga).</param>
/// <param name="InsightUrl">URL exibida no dashboard para o RedisInsight. null = não cria o recurso.</param>
/// <param name="InsightHealthUrl">URL usada pelo AppHost (dentro do devcontainer) para testar o RedisInsight.</param>
internal sealed record ExternalRedisSettings(
    string? ConnectionString = null,
    string RedisUrl = "redis://127.0.0.1:6379",
    string? InsightUrl = "http://127.0.0.1:5540",
    string InsightHealthUrl = "http://redis-insight:5540");

internal static class RedisResources
{
    private const string UseExternalKey = "Redis:UseExternal";
    private const string InsightName = "redis-insight";

    /// <summary>
    /// Registra o Redis (e o RedisInsight) como recursos do Aspire, aparecendo no dashboard nos dois modos.
    /// - Redis:UseExternal = true  -> recursos que apontam para containers já existentes.
    /// - Redis:UseExternal = false -> o Aspire cria Redis + RedisInsight novos.
    /// </summary>
    /// <example>
    /// var cache = builder.AddRedisCache("cache",
    ///     new ExternalRedisSettings(ConnectionString: "redis-cache:6379,abortConnect=false"),
    ///     useExternalByDefault: true);
    ///
    /// var server = builder.AddProject&lt;Projects.AppServer&gt;("server")
    ///     .WithRedisCache(cache)
    ///     .WithExternalHttpEndpoints();
    /// </example>
    public static IResourceBuilder<IResourceWithConnectionString> AddRedisCache(
        this IDistributedApplicationBuilder builder,
        string name = "cache",
        ExternalRedisSettings? external = null,
        bool useExternalByDefault = false)
    {
        var useExternal = builder.Configuration.GetValue(UseExternalKey, useExternalByDefault);

        return useExternal
            ? AddExternalRedis(builder, name, external ?? new ExternalRedisSettings())
            : AddManagedRedis(builder, name);
    }

    /// <summary>
    /// Injeta ConnectionStrings:{name} no destino e espera o Redis ficar saudável.
    /// </summary>
    public static IResourceBuilder<TDestination> WithRedisCache<TDestination>(
        this IResourceBuilder<TDestination> destination,
        IResourceBuilder<IResourceWithConnectionString> cache)
        where TDestination : IResourceWithEnvironment, IResourceWithWaitSupport
        => destination.WithReference(cache).WaitFor(cache);

    // ---------------------------------------------------------------- externo

    private static IResourceBuilder<IResourceWithConnectionString> AddExternalRedis(
        IDistributedApplicationBuilder builder,
        string name,
        ExternalRedisSettings settings)
    {
        // appsettings / user-secrets / variável de ambiente têm prioridade sobre o fallback
        var connectionString = builder.Configuration.GetConnectionString(name);
        if (string.IsNullOrWhiteSpace(connectionString))
        {
            connectionString = settings.ConnectionString;
        }

        if (string.IsNullOrWhiteSpace(connectionString))
        {
            throw new InvalidOperationException(
                $"Redis externo habilitado ('{UseExternalKey}'), mas ConnectionStrings:{name} não foi configurada.");
        }

        var options = ConfigurationOptions.Parse(connectionString);
        var source = string.Join(", ", options.EndPoints.Select(FormatEndpoint));

        // Health check registrado ANTES de ser referenciado
        var checkName = $"{name}-check";
        builder.Services.AddHealthChecks()
            .AddCheck(checkName, new ExternalRedisHealthCheck(options));

        var cache = builder
            .AddResource(new ExternalRedisResource(name, connectionString))
            .WithHealthCheck(checkName)
            .ExcludeFromManifest()
            .WithInitialState(new CustomResourceSnapshot
            {
                ResourceType = "Redis (externo)",
                State = KnownResourceStates.Running,
                StartTimeStamp = DateTime.UtcNow,
                Properties = [new(CustomResourceKnownProperties.Source, source)],
                Urls = [new UrlSnapshot("Redis", settings.RedisUrl, IsInternal: false)]
            });

        if (!string.IsNullOrWhiteSpace(settings.InsightUrl))
        {
            AddExternalInsight(builder, cache, settings);
        }

        return cache;
    }

    private static void AddExternalInsight(
        IDistributedApplicationBuilder builder,
        IResourceBuilder<ExternalRedisResource> cache,
        ExternalRedisSettings settings)
    {
        var checkName = $"{InsightName}-check";
        builder.Services.AddHealthChecks()
            .AddCheck(checkName, new UrlHealthCheck(settings.InsightHealthUrl));

        builder
            .AddResource(new ExternalRedisInsightResource(InsightName))
            .WithParentRelationship(cache)
            .WithHealthCheck(checkName)
            .ExcludeFromManifest()
            .WithInitialState(new CustomResourceSnapshot
            {
                ResourceType = "Redis Insight (externo)",
                State = KnownResourceStates.Running,
                StartTimeStamp = DateTime.UtcNow,
                Properties = [new(CustomResourceKnownProperties.Source, settings.InsightUrl!)],
                Urls = [new UrlSnapshot("Redis Insight", settings.InsightUrl!, IsInternal: false)]
            });
    }

    // DnsEndPoint.ToString() devolve "Unspecified/host:porta"; aqui sai só "host:porta"
    private static string FormatEndpoint(EndPoint endpoint) => endpoint switch
    {
        DnsEndPoint dns => $"{dns.Host}:{dns.Port}",
        _ => endpoint.ToString() ?? string.Empty
    };

    // --------------------------------------------------------------- gerenciado

    private static IResourceBuilder<IResourceWithConnectionString> AddManagedRedis(
        IDistributedApplicationBuilder builder,
        string name)
        => builder
            .AddRedis(name)
            .WithDataVolume($"{name}-data")
            .WithLifetime(ContainerLifetime.Persistent)
            .WithRedisInsight();
}

/// <summary>
/// Recurso que representa um Redis fora do controle do Aspire.
/// Implementa IResourceWithConnectionString, então funciona com WithReference.
/// </summary>
internal sealed class ExternalRedisResource(string name, string connectionString)
    : Resource(name), IResourceWithConnectionString
{
    public ReferenceExpression ConnectionStringExpression =>
        ReferenceExpression.Create($"{connectionString}");
}

/// <summary>Recurso que representa um RedisInsight já em execução fora do Aspire.</summary>
internal sealed class ExternalRedisInsightResource(string name) : Resource(name);

/// <summary>PING no Redis externo, reutilizando uma única conexão.</summary>
internal sealed class ExternalRedisHealthCheck(ConfigurationOptions options) : IHealthCheck
{
    private readonly Lazy<Task<ConnectionMultiplexer>> _connection = new(() =>
    {
        options.AbortOnConnectFail = false;
        options.ConnectTimeout = 3000;
        return ConnectionMultiplexer.ConnectAsync(options);
    });

    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        try
        {
            var multiplexer = await _connection.Value.WaitAsync(cancellationToken);
            var latency = await multiplexer.GetDatabase().PingAsync();

            return HealthCheckResult.Healthy($"PONG em {latency.TotalMilliseconds:F0} ms");
        }
        catch (Exception ex)
        {
            return HealthCheckResult.Unhealthy("Redis indisponível", ex);
        }
    }
}

/// <summary>GET simples numa URL; qualquer resposta abaixo de 500 conta como saudável.</summary>
internal sealed class UrlHealthCheck(string url) : IHealthCheck
{
    private static readonly HttpClient Client = new() { Timeout = TimeSpan.FromSeconds(3) };

    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        try
        {
            using var response = await Client.GetAsync(url, cancellationToken);
            var status = (int)response.StatusCode;

            return status < 500
                ? HealthCheckResult.Healthy($"HTTP {status}")
                : HealthCheckResult.Unhealthy($"HTTP {status} em {url}");
        }
        catch (Exception ex)
        {
            return HealthCheckResult.Unhealthy($"Sem resposta de {url}", ex);
        }
    }
}