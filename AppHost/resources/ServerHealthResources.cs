
using Microsoft.Extensions.DependencyInjection;

namespace AppHost.resources;

internal static class ServerHealthResources
{
    /// <summary>
    /// Cria recursos filhos do <paramref name="server"/> para cada endpoint informado,
    /// com health check, origem e URL publicada quando o server estiver pronto.
    /// </summary>
    public static IDistributedApplicationBuilder AddServerHealthResources(
        this IDistributedApplicationBuilder builder,
        IResourceBuilder<ProjectResource> server,
        params (string Name, string Path, string DisplayText)[] endpoints)
    {
        var https = server.GetEndpoint("https");

        foreach (var (name, path, displayText) in endpoints)
        {
            AddHealthResource(builder, server, https, name, path, displayText);
        }

        return builder;
    }

    private static void AddHealthResource(
        IDistributedApplicationBuilder builder,
        IResourceBuilder<ProjectResource> server,
        EndpointReference https,
        string name,
        string path,
        string displayText)
    {
        var checkName = $"{name}-check";

        // 1) Registra o health check ANTES de referenciá-lo
        builder.Services.AddHealthChecks()
            .AddCheck(checkName, new EndpointHealthCheck(https, path));

        // 2) Cria o recurso filho usando exatamente o mesmo nome
        var resource = builder.AddResource(new EndpointResource(name))
            .WithParentRelationship(server)
            .WithHealthCheck(checkName)
            .WithInitialState(new CustomResourceSnapshot
            {
                ResourceType = "Health endpoint",
                State = KnownResourceStates.Running,
                Properties =
                [
                    new(CustomResourceKnownProperties.Source, $"server → {path}")
                ]
            });

        // 3) Publica a URL quando o server estiver pronto
        builder.Eventing.Subscribe<ResourceReadyEvent>(server.Resource, async (evt, ct) =>
        {
            var notifications = evt.Services.GetRequiredService<ResourceNotificationService>();

            if (!notifications.TryGetCurrentState(server.Resource.Name, out var current))
                return;

            var baseUrl = current.Snapshot.Urls
                .Where(u => !u.IsInternal && u.Url.StartsWith("https://"))
                .OrderByDescending(u => u.Url.Contains(".dev.localhost"))
                .Select(u => u.Url)
                .FirstOrDefault();

            if (baseUrl is null)
                return;

            await notifications.PublishUpdateAsync(resource.Resource, snapshot => snapshot with
            {
                Urls = [new UrlSnapshot(displayText, $"{baseUrl.TrimEnd('/')}/{path.TrimStart('/')}", IsInternal: false)]
            });
        });
    }
}

