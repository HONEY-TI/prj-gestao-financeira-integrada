using Business.Authentication.Abstractions;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using System.Security.Cryptography.X509Certificates;

namespace Application.Authentication;

public static class CertificateLoader
{
    public static X509Certificate2? Load(IOptions<TokenOptions> options)
    {
        var environment = Environment.GetEnvironmentVariable(
            "ASPNETCORE_ENVIRONMENT");

        if (environment == Environments.Development)
            return LoadDevelopmentCertificate();

        if (environment == Environments.Production)
            return LoadProductionCertificate(options.Value);

        return null;
    }

    private static X509Certificate2? LoadDevelopmentCertificate()
    {
        using var store = new X509Store(
            StoreName.My,
            StoreLocation.CurrentUser);

        store.Open(OpenFlags.ReadOnly);

        return store.Certificates
            .Find(
                X509FindType.FindBySubjectName,
                "localhost",
                validOnly: false)
            .OfType<X509Certificate2>()
            .FirstOrDefault(c => c.HasPrivateKey);
    }

    private static X509Certificate2 LoadProductionCertificate(
        TokenOptions options)
    {
        if (string.IsNullOrWhiteSpace(options.CertificatePath) ||
            string.IsNullOrWhiteSpace(options.PrivateKeyPath))
        {
            throw new InvalidOperationException(
                "JWT certificate configuration is missing.");
        }

        return X509Certificate2.CreateFromPemFile(
            options.CertificatePath,
            options.PrivateKeyPath);
    }
}