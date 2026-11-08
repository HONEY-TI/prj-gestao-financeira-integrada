
var builder = DistributedApplication.CreateBuilder(args);

var cache = builder.AddRedis("cache");
/*
var server = builder
    .AddProject<Projects.prj_estacio_despesas_pessoais_Server>("server")
    .WithReference(cache)
    .WaitFor(cache)
    .WithHttpHealthCheck("/health")
    .WithExternalHttpEndpoints();
*/

var server = builder
    .AddProject<Projects.prj_estacio_despesas_pessoais_Server>("server")
    .WithReference(cache)
    .WaitFor(cache)
    .WithHttpHealthCheck("/health")
    .WithExternalHttpEndpoints()
    .WithUrlForEndpoint("https", ep => new()
    {
        Url = "/health-ui",
        DisplayText = "Health Checks UI"
    })
    .WithUrlForEndpoint("https", ep => new()
    {
        Url = "/health/details",
        DisplayText = "Health Details"
    });

var webfrontend = builder
    .AddNpmApp("webfrontend", "../frontend", "dev")
    .WithReference(server)
    .WaitFor(server)
    .WithHttpEndpoint(env: "PORT")
    .WithExternalHttpEndpoints();

//server.PublishWithContainerFiles(webfrontend, "wwwroot");

builder.Build().Run();
