param (
    [switch]$resolve = $false
)

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$hostsFile = "C:\Windows\System32\drivers\etc\hosts"

& "$PSScriptRoot\win-clean-hosts.ps1"

$wslHosts = @(wsl cat /etc/hosts)

Foreach ($wslHost in $wslHosts) {
    if ($wslHost.Contains("AUTOCREATED")) {
        Write-Host "Adding $wslHost"
        $wslHost | Out-File -FilePath $hostsFile -Append
    }
}

& ipconfig.exe /flushdns
& nbtstat -R

if ($resolve)
{
    Foreach ($wslHost in $wslHosts)
    {
        if ( $wslHost.Contains("AUTOCREATED"))
        {
            $hostName = $wslHost.Split(' ')[1]
            Resolve-DnsName -name $hostName
        }
    }
}

Write-Host ""
Write-Host "***** Open edge://net-internals/#dns and Clear host cache"
Write-Host "***** Open edge://net-internals/#sockets and Flush socket pools"
Write-Host "***** Open chrome://net-internals/#dns and Clear host cache"
Write-Host "***** Open chrome://net-internals/#sockets and Flush socket pools"
Write-Host "Done - Press Any Key to close this window"
[void][System.Console]::ReadKey($FALSE)