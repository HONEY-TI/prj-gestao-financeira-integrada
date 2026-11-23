using Application.Dtos.Abstractions;
using Application.Dtos.Core;
using Microsoft.AspNetCore.Mvc;
using Microsoft.OpenApi;
using Swashbuckle.AspNetCore.SwaggerGen;
using System.Reflection;

namespace WebApi.CommonDependenceInject;

public static class SwaggerApiVersioningDependenceInject
{
    private readonly static string appName = "API Balanço Positivo";
    private readonly static string currentVersion = "v3.0.0";
    private readonly static string appDescription = @$"
           A API Balanço Positivo fornece serviços para o gerenciamento de finanças pessoais de forma simples e objetiva.  Por meio de seus endpoints, é possível registrar 
       gastos e receitas, consultar relatórios, obter gráficos consolidados e organizar informações financeiras de maneira prática e eficiente.
           Essa API foi projetada para permitir que aplicações clientes — como aplicativos móveis ou sistemas web — acessem e manipulem dados financeiros de forma segura 
       e estruturada, auxiliando usuários a tomarem decisões mais conscientes e alcançarem a estabilidade financeira com confiança.";

    public static void AddSwaggerApiVersioning(this IServiceCollection services)
    {
        services.AddEndpointsApiExplorer();

        services.AddSwaggerGen(static c =>
        {
            c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
            {
                In = ParameterLocation.Header,
                Name = "Authorization",
                Type = SecuritySchemeType.ApiKey,
                Scheme = "Bearer",
                Description = "Adicione o token JWT (ex: Bearer {seu token})"
            });

            // AddSecurityRequirement agora recebe um delegate que recebe o
            // OpenApiDocument sendo construído, necessário para resolver a
            // referência ao esquema "Bearer" registrado acima.
            c.AddSecurityRequirement(static document => new OpenApiSecurityRequirement
            {
                [new OpenApiSecuritySchemeReference("Bearer", document)] = []
            });

            c.SchemaFilter<HideDtosFilter>();

            c.SwaggerDoc(currentVersion, new OpenApiInfo
            {
                Title = appName,
                Version = currentVersion,
                Description = appDescription,
                Contact = new OpenApiContact
                {
                    Name = "Projeto Balanço Pessoal  - HONEY TI",
                    Url = new Uri("https://github.com/alexribeirofaria/prj-despesas-pessoais")
                },
            });

            c.DocInclusionPredicate((docName, apiDesc) =>
            {
                if (!apiDesc.TryGetMethodInfo(out MethodInfo methodInfo)) return false;
                var controllerNamespace = methodInfo?.DeclaringType?.Namespace;

                if (docName == currentVersion)
                    return true;

                return false;
            });
        });
    }

    public static void AddSwaggerUIApiVersioning(this WebApplication app)
    {
        app.UseSwagger();
        app.UseSwaggerUI(c =>
        {
            string swaggerJsonBasePath = string.IsNullOrWhiteSpace(c.RoutePrefix) ? "." : "..";
            c.SwaggerEndpoint(@$"{swaggerJsonBasePath}/swagger/{currentVersion}/swagger.json", $"{appName} ");
        });
    }
}

internal class HideDtosFilter : ISchemaFilter
{
    public void Apply(IOpenApiSchema schema, SchemaFilterContext context)
    {
        if (schema is not OpenApiSchema openApiSchema)
            return;

        if (context.Type == typeof(AuthenticationDto))
        {
            openApiSchema.Description = "DTO contendo informações de autenticação.";
            openApiSchema.Type = JsonSchemaType.Object;
            openApiSchema.Properties.Clear();
        }

        if (context.Type == typeof(GoogleAuthenticationDto))
        {
            openApiSchema.Description = "DTO contendo informações de autenticação google.";
            openApiSchema.Type = JsonSchemaType.Object;
            openApiSchema.Properties.Clear();
        }

        if (context.Type == typeof(ProblemDetails))
        {
            openApiSchema.Description = "Informações de erro retornado pela API.";
            openApiSchema.Type = JsonSchemaType.Object;
            openApiSchema.Properties.Clear();
        }
    }
}