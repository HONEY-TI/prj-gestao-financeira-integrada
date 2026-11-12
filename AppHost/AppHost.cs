using Microsoft.Extensions.DependencyInjection;
using AppHost.resources;

var builder = DistributedApplication.CreateBuilder(args);

var cache = builder.AddRedis("cache");

var server = builder
    .AddProject<Projects.Server>("server")
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
