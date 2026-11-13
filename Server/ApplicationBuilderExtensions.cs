
using HealthChecks.UI.Client;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.Extensions.DependencyInjection;
using Repository.Mapping.Abstractions;
using WebApi.CommonDependenceInject;
using Migrations.DataSeeders.CommonDependenceInject;

namespace Microsoft.Extensions.Hosting;

public static class ApplicationBuilderExtensions
{
    public static WebApplication UseApplicationConfiguration(
        this WebApplication app)
    {
        // OpenAPI e Swagger
        if (app.Environment.IsDevelopment())
        {
            app.MapOpenApi();
            app.AddSwaggerUIApiVersioning();
        }

        // A base InMemory é criada vazia a cada inicialização do processo.
        // Execute os seeders também fora de Development para que a API de
        // demonstração/teste tenha os usuários iniciais disponíveis.
        if (app.Services.GetRequiredService<DatabaseProvider>() == DatabaseProvider.InMemory)
            app.Services.RunDataSeeders();

        // Segurança
        app.UseHsts();
        //app.UseHttpsRedirection();

        // Arquivos estáticos
        app.UseDefaultFiles();
        app.UseStaticFiles();

        // Certificados e localização
        app.UseCertificateForwarding();
        app.AddSupporteCulturesPtBr();

        // Roteamento
        app.UseRouting();

        // CORS
        app.UseCors();

        // Autenticação e autorização
        app.UseAuthentication();
        app.UseAuthorization();

        // Cache
        app.UseOutputCache();

        return app;
    }

    public static WebApplication MapApplicationEndpoints(
        this WebApplication app)
    {
        // Controllers
        app.MapControllers();

        // Health Checks
        app.MapDefaultEndpoints();

        // Health Checks UI
        if (app.Environment.IsDevelopment())
        {
            app.MapHealthChecks("/health/details", new HealthCheckOptions
            {
                ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse
            });

            app.MapHealthChecksUI(options =>
            {
                options.UIPath = "/health-ui";
            });
        }

        // SPA fallback
        app.MapFallbackToFile("index.html");

        return app;
    }
}
