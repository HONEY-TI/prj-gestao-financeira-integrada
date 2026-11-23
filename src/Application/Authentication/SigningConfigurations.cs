
using Application.Authentication.Abstractions;
using Business.Authentication.Abstractions;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

namespace Application.Authentication;

public class SigningConfigurations : ISigningConfigurations
{
    public SecurityKey? Key { get; }
    public TokenConfiguration? TokenConfiguration { get; private set; }
    public SigningCredentials? SigningCredentials { get; private set; }

    public SigningConfigurations(
        X509Certificate2? x509Certificate,
        IOptions<TokenOptions> options) : this(options)
    {
        RSA rsa = x509Certificate?.GetRSAPrivateKey()
            ?? (Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == Environments.Production
                ? throw new InvalidOperationException("A valid RSA certificate is required in Production.")
                : RSA.Create(2048));

        var rsaKey = new RsaSecurityKey(rsa)
        {
            KeyId = x509Certificate?.Thumbprint ?? Guid.NewGuid().ToString()
        };

        Key = rsaKey;
        SigningCredentials = new SigningCredentials(
            Key,
            SecurityAlgorithms.RsaSha256);
    }

    private SigningConfigurations(IOptions<TokenOptions> options)
    {
        TokenConfiguration = new TokenConfiguration(options);
    }

    public string CreateAccessToken(ClaimsIdentity identity)
    {
        var handler = new JwtSecurityTokenHandler();

        var securityToken = handler.CreateToken(new SecurityTokenDescriptor
        {
            Issuer = TokenConfiguration!.Issuer,
            Audience = TokenConfiguration.Audience,
            SigningCredentials = SigningCredentials,
            Subject = identity,
            NotBefore = DateTime.UtcNow,
            IssuedAt = DateTime.UtcNow,
            Expires = DateTime.UtcNow.AddSeconds(TokenConfiguration.Seconds)
        });

        return handler.WriteToken(securityToken);
    }

    public string GenerateRefreshToken()
    {
        var handler = new JwtSecurityTokenHandler();

        var securityToken = handler.CreateToken(new SecurityTokenDescriptor
        {
            Audience = TokenConfiguration!.Audience,
            Issuer = TokenConfiguration.Issuer,
            Claims = new Dictionary<string, object>
            {
                ["KEY"] = Guid.NewGuid()
            },
            NotBefore = DateTime.UtcNow,
            Expires = DateTime.UtcNow.AddDays(TokenConfiguration.DaysToExpiry)
        });

        return handler.WriteToken(securityToken);
    }

    public bool ValidateRefreshToken(string refreshToken)
    {
        var handler = new JwtSecurityTokenHandler();

        if (string.IsNullOrWhiteSpace(refreshToken))
            return false;

        try
        {
            var token = handler.ReadJwtToken(
                refreshToken.Replace("Bearer ", "", StringComparison.OrdinalIgnoreCase));

            return token.ValidTo >= DateTime.UtcNow;
        }
        catch (ArgumentException)
        {
            return false;
        }
    }
}
