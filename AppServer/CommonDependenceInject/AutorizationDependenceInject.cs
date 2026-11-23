using Application.Authentication;
using Application.Authentication.Abstractions;
using Business.Authentication.Abstractions;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.Security.Cryptography.X509Certificates;

namespace WebApi.CommonDependenceInject;

public static class AutorizationDependenceInject
{
    private const string AUTHORIZATION_POLICY = "Bearer";

    private static readonly string[] ALLOWED_ORIGINS =
    {
        "https://alexfariakof.com",
        "https://localhost",
        "https://localhost:42535",
        "https://localhost:4200",
        "https://127.0.0.1",
        "https://127.0.0.1:4200",
        "https://127.0.0.1:42535",
        "https://accounts.google.com"
    };

    public static void AddCORSConfigurations(this WebApplicationBuilder builder)
    {
        builder.Services.AddCors(options =>
        {
            options.AddDefaultPolicy(policy =>
            {
                policy.WithOrigins(ALLOWED_ORIGINS)
                      .AllowAnyMethod()
                      .AllowAnyHeader()
                      .AllowCredentials();
            });
        });
    }

    public static void AddSigningConfigurations(this WebApplicationBuilder builder)
    {
        builder.Services.Configure<TokenOptions>(
            builder.Configuration.GetSection("TokenConfigurations"));

        builder.Services.AddSingleton<X509Certificate2?>(provider =>
        {
            var options = provider.GetRequiredService<IOptions<TokenOptions>>();

            return CertificateLoader.Load(options);
        });

        builder.Services.AddSingleton<SigningConfigurations>();

        builder.Services.AddSingleton<ISigningConfigurations>(
            provider => provider.GetRequiredService<SigningConfigurations>());
    }

    public static void AddAuthenticationConfigurations(this WebApplicationBuilder builder)
    {
        builder.Services
            .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer();

        builder.Services
            .AddOptions<JwtBearerOptions>(JwtBearerDefaults.AuthenticationScheme)
            .Configure<ISigningConfigurations, IOptions<TokenOptions>>(
                (options, signingConfigurations, tokenOptions) =>
                {
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        IssuerSigningKey = signingConfigurations.Key,

                        ValidIssuer = tokenOptions.Value.Issuer,
                        ValidAudience = tokenOptions.Value.Audience,

                        ValidateIssuerSigningKey = true,
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ValidateLifetime = true,

                        ClockSkew = TimeSpan.Zero
                    };
                });

        builder.Services.AddAuthorization(options =>
        {
            options.AddPolicy(AUTHORIZATION_POLICY, policy =>
            {
                policy.AddAuthenticationSchemes(
                    JwtBearerDefaults.AuthenticationScheme);

                policy.RequireAuthenticatedUser();
            });
        });
    }
}
