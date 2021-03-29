
# Ensure that  the script is elevated
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell "-ExecutionPolicy","Unrestricted","-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

Set-Location -LiteralPath $PSScriptRoot
# Create the service 
New-Service -Name "AudioDGFix" -BinaryPathName "`"$(resolve-path .\AudioDGFix.exe)`" -s" -DependsOn "audiosrv" -StartupType Automatic
# Immediately start the Service
Start-Service -Name "AudioDGFix"
