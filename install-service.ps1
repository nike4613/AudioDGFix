
# Ensure that  the script is elevated
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

# Create the service 
$svc = New-Service -Name "AudioDGFix" -BinaryPathName "$(resolve-path .\AudioDGFix.exe) -s" -DependsOn "audiosrv" -StartupType AutomaticDelayedStart
# Immediately start the Service
Start-Service $svc
