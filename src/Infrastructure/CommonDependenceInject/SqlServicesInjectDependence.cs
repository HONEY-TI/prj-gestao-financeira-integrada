
using Infrastructure.DatabaseContexts;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Repository.Mapping.Abstractions;
using System.Reflection;

namespace Infrastructure.CommonInjectDependence;

public static class SqlServicesInjectDependence
{
    public static IServiceCollection ConfigureMsSqlServerContext(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var provider = DatabaseProvider.SqlServer;

        var connectionString =
            configuration.GetConnectionString("SqlServerConnectionString")
            ?? configuration.GetConnectionString("SqlConnectionString")
            ?? throw new InvalidOperationException(
                "Connection string 'SqlServerConnectionString' não encontrada.");

        return ConfigureContext(
            services,
            connectionString,
            provider,
            (options, connection) =>
                options.UseSqlServer(
                    connection,
                    b => b.MigrationsAssembly(
                        Assembly.GetExecutingAssembly().GetName().Name)));
    }

    public static IServiceCollection ConfigureMySqlServerContext(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var provider = DatabaseProvider.MySql;

        var connectionString =
            configuration.GetConnectionString("MySqlConnectionString")
            ?? configuration.GetConnectionString("SqlConnectionString")
            ?? throw new InvalidOperationException(
                "Connection string 'MySqlConnectionString' não encontrada.");

        return ConfigureContext(
            services,
            connectionString,
            provider,
            (options, connection) =>
                options.UseMySQL(
                    connection,
                    b => b.MigrationsAssembly("Migrations.MySqlServer")));
    }

    public static IServiceCollection ConfigureOracleServerContext(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var provider = DatabaseProvider.Oracle;

        var connectionString =
            configuration.GetConnectionString("OracleConnectionString")
            ?? configuration.GetConnectionString("SqlConnectionString")
            ?? throw new InvalidOperationException(
                "Connection string 'OracleConnectionString' não encontrada.");

        return ConfigureContext(
            services,
            connectionString,
            provider,
            (options, connection) =>
                options.UseOracle(
                    connection,
                    b => b.MigrationsAssembly(
                        Assembly.GetExecutingAssembly().GetName().Name)));
    }

    public static IServiceCollection ConfigureInMemoryServerContext(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var provider = DatabaseProvider.InMemory;

        services.Add(new ServiceDescriptor(typeof(DatabaseProvider), provider));

        services.AddDbContext<RegisterContext>((sp, options) =>
        {
            var loggerFactory = sp.GetRequiredService<ILoggerFactory>();

            options.UseInMemoryDatabase("RegisterDbInMemory")
                   .UseLoggerFactory(loggerFactory)
                   .UseLazyLoadingProxies();
        });

        return services;
    }

    private static IServiceCollection ConfigureContext(
        IServiceCollection services,
        string connectionString,
        DatabaseProvider provider,
        Action<DbContextOptionsBuilder, string> configureDatabase)
    {
        services.Add(new ServiceDescriptor(typeof(DatabaseProvider), provider));

        services.AddDbContext<RegisterContext>((sp, options) =>
        {
            var loggerFactory = sp.GetRequiredService<ILoggerFactory>();

            configureDatabase(options, connectionString);

            options.UseLoggerFactory(loggerFactory);
            options.UseLazyLoadingProxies();
        });

        return services;
    }
}
