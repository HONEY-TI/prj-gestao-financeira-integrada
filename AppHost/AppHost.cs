using AppHost.resources;

var builder = DistributedApplication.CreateBuilder(args);

//var cache = builder.AddRedis("cache");
var cache = builder.AddRedisCache("cache",
    new ExternalRedisSettings(ConnectionString: "redis://default:redis@redis-cache:6379"),
    useExternalByDefault: true);

var server = builder
    .AddProject<Projects.AppServer>("server")
    .WithReference(cache)
    .WaitFor(cache)
    .WithExternalHttpEndpoints();

// Health / Swagger resources
builder.AddServerHealthResources(
    server,
    ("swagger", "/swagger", "Swagger"),
    ("health", "/health", "Health"),
    ("health-details", "/health/details", "Health Details"),
    ("health-ui", "/health-ui", "Health Checks UI"));

var webfrontend = builder
    .AddNpmApp("webfrontend", "../frontend", "dev")
    .WithReference(server)
    .WaitFor(server)
    .WithHttpEndpoint(env: "PORT")
    .WithExternalHttpEndpoints();

builder.Build().Run();
