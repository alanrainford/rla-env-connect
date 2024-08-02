if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$cidr = "10.235.0.0"
$mask = "255.255.0.0"

$wslIp = ((wsl ifconfig eth0) | Where-Object { $_.Contains("inet ") }).Trim().Split(" ")[1].Trim()
Write-Host "WSL ip address $wslIp"
$routes = (route print) -join "`n"

if ( $routes.Contains($cidr))
{
    Write-Host "Delete route for $cidr"
    route delete $cidr    
}

Write-Host "route add $cidr mask $mask $wslIp metric 1"
route add $cidr mask $mask $wslIp metric 1
$routes = (route print -4) -join "`n"
Write-Host $routes

$wslAdapter = Get-NetAdapter -Name "*Ethernet*WSL*" -IncludeHidden
Write-Host $wslAdapter.Name
Set-NetIPInterface -InterfaceAlias $wslAdapter.Name -AutomaticMetric Enabled
Write-Host "Disable public DNS on" $wslAdapter.Name
Set-DnsClientServerAddress -InterfaceAlias $wslAdapter.Name -ServerAddresses ("127.0.0.1")
Write-Host "Done - Press Any Key to close this window"
[void][System.Console]::ReadKey($FALSE)