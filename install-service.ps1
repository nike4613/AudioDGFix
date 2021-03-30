if ($PSEdition -neq "Core") {
    Write-Host "This script requires PowerShell Core. Get it here: https://github.com/powershell/powershell#get-powershell"
    $HOST.UI.RawUI.ReadKey(“NoEcho,IncludeKeyDown”) | OUT-NULL
    $HOST.UI.RawUI.Flushinputbuffer()
}

# Ensure that  the script is elevated
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process pwsh "-ExecutionPolicy","Unrestricted","-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

Set-Location -LiteralPath $PSScriptRoot
# Create the service 
New-Service -Name "AudioDGFix" -BinaryPathName "`"$(resolve-path .\AudioDGFix.exe)`" -s" -DependsOn "audiosrv" -StartupType AutomaticDelayedStart
# Immediately start the Service
Start-Service -Name "AudioDGFix"
