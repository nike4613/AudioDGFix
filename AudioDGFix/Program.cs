using CommandLine;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Serilog;
using System;
using System.Diagnostics;
using System.Reflection.Metadata.Ecma335;
using System.Threading;
using System.Threading.Tasks;

#if DEBUG
//Console.ReadLine();
Debugger.Launch();
#endif

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .WriteTo.File("log.txt")
    .WriteTo.EventLog("AudioDGFix", "Application", manageEventSource: true)
    .CreateLogger();

var code = await Parser.Default.ParseArguments<CommandLineOptions>(args)
    .MapResult(async opts =>
    {
        var builder = CreateBuilder(args);
        if (opts.RunAsService)
        {
            await builder.UseWindowsService().Build().RunAsync();
        }
        else
        {
            var svc = builder.Build().Services.GetRequiredService<DGFixerService>();
            svc.DoFixProcesses();
        }
        return 0;
    },
    errs => Task.FromResult(-1));

Environment.Exit(code);

static IHostBuilder CreateBuilder(string[] args)
    => Host.CreateDefaultBuilder(args)
        .UseSerilog()
        .ConfigureServices((ctx, services) =>
        {
            services.AddHostedService<DGFixerService>();
            services.AddTransient<DGFixerService>();
        });

class CommandLineOptions
{
    [Option(shortName: 's', longName: "run-as-service", Required = false, HelpText = "Runs as a service.", Default = false)]
    public bool RunAsService { get; set; }
}

class DGFixerService : BackgroundService
{
    private readonly ILogger log;

    public DGFixerService()
        => log = Log.Logger;

    public void DoFixProcesses()
    {
        log.Information("Searching for audiodg.exe");

        var processes = Process.GetProcessesByName("audiodg");

        foreach (var process in processes)
        {
            log.Information("Found {ProcessName} ({ProcessId})", process.ProcessName, process.Id);

            // set high priority
            process.PriorityClass = ProcessPriorityClass.High;
            process.ProcessorAffinity = (IntPtr)0x00000001;

            log.Information("Priority {Priority}, affinity {Affinity}", process.PriorityClass, process.ProcessorAffinity);
        }
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            DoFixProcesses();
            await Task.Delay(TimeSpan.FromMinutes(60), stoppingToken);
        }
    }
}