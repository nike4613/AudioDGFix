using System;
using System.Diagnostics;

#if DEBUG
//Console.ReadLine();
Debugger.Launch();
#endif

Console.WriteLine("Searching for audiodg.exe");

var processes = Process.GetProcessesByName("audiodg");

foreach (var process in processes)
{
    Console.WriteLine($"Found {process.ProcessName} ({process.Id})");

    // set high priority
    process.PriorityClass = ProcessPriorityClass.High;
    process.ProcessorAffinity = (IntPtr)0x00000001;

    Console.WriteLine($"Priority {process.PriorityClass}, affinity {process.ProcessorAffinity}");
}