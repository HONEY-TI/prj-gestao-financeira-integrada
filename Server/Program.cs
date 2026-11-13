
using Application.CommonDependenceInject;
using CrossCutting.CommonDependenceInject;
using GlobalException.CommonDependenceInject;
using Infrastructure.CommonDependenceInject;
using Infrastructure.CommonInjectDependence;
using Repository.CommonDependenceInject;
using WebApi.CommonDependenceInject;
using Migrations.DataSeeders.CommonDependenceInject;
using Microsoft.Extensions.Caching.Distributed;

var builder = WebApplication.CreateBuilder(args);

// ============================================================
// HOST E INFRAESTRUTURA
// ============================================================

builder.AddServiceDefaults();

builder.AddRedisClientBuilder("cache")
    .WithDistributedCache()
    .WithOutputCache();

// ============================================================
// SERVIÇOS
// ============================================================

builder.Services
    .AddProblemDetails()
    .AddOpenApi()
    .AddRouting(options =>
    {
        options.LowercaseUrls = true;
    })
    .AddControllers();

builder.AddCORSConfigurations();

// ============================================================
// PERSISTÊNCIA
// ============================================================

// Oracle
// builder.Services.ConfigureOracleServerMigrationsContext(
//     builder.Configuration);

// SQL Server
// builder.Services.ConfigureMsSqlServerContext(
//     builder.Configuration);

// MySQL
// builder.Services.ConfigureMySqlServerContext(
//     builder.Configuration);

// InMemory
builder.Services.ConfigureInMemoryServerContext(
    builder.Configuration);

// ============================================================
// SEGURANÇA
// ============================================================

builder.AddSigningConfigurations();
builder.AddAuthenticationConfigurations();

builder.Services.AddServicesCryptography(
    builder.Configuration);

// ============================================================
// INJEÇÃO DE DEPENDÊNCIAS
// ============================================================

builder.Services.AddApplicationAutoMapper();
builder.Services.AddAmazonS3BucketConfigurations(builder.Configuration);
builder.Services.AddRepositories();
builder.Services.AddServices();
builder.Services.AddCrossCuttingConfiguration();
builder.Services.AddDataSeeders();

// ============================================================
// HEALTH CHECKS
// ============================================================

builder.AddHealthCheckConfigurations();

// ============================================================
// APLICAÇÃO
// ============================================================

var app = builder.Build();

// ============================================================
// MIDDLEWARES
// ============================================================

app.UseGlobalExceptionHandler();

app.UseApplicationConfiguration();

// ============================================================
// ENDPOINTS
// ============================================================

app.MapApplicationEndpoints();
app.MapGet("/api/teste/redis", async (Microsoft.Extensions.Caching.Distributed.IDistributedCache c) =>
{
    await c.SetStringAsync("teste:ok", DateTime.UtcNow.ToString("O"));
    return await c.GetStringAsync("teste:ok");
}).AllowAnonymous();
app.Run();
