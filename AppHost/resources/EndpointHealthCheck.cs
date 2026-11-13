using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace AppHost.resources;

internal sealed class EndpointHealthCheck(
    EndpointReference endpoint,
    string path) : IHealthCheck
{
    private readonly HttpClient _httpClient = new();

    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        try
        {
            var baseUrl = await EndpointHostHelpers
                .GetUrlWithTargetHostAsync(endpoint, cancellationToken);

            var url = $"{baseUrl!.TrimEnd('/')}/{path.TrimStart('/')}";

            using var response = await _httpClient.GetAsync(url, cancellationToken);

            return response.IsSuccessStatusCode
                ? HealthCheckResult.Healthy()
                : HealthCheckResult.Unhealthy($"HTTP {(int)response.StatusCode}");
        }
        catch (Exception ex)
        {
            return HealthCheckResult.Unhealthy(ex.Message, ex);
        }
    }
}