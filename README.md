# AudioDG Automatic Fix

This is an application which automatically fixes AudioDG for Voicemeeter.

## Using

Either run the executable directly each time you start your computer, or run

```powershell
& .\install-service.ps1
```

in the publish output in Powershell to install it as a service. `.\uninstall-service.ps1` can
be used to stop and remove the service, but it must be run from Powershell Core.