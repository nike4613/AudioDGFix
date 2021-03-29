#Requires -Version 6.0

# Ensure that  the script is elevated
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process pwsh "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

# Remove the service
Stop-Service -Name "AudioDGFix"
Remove-Service -Name "AudioDGFix"