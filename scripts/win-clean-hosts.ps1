if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$hostsFile = "C:\Windows\System32\drivers\etc\hosts"
$cleanHostsFile = "C:\Windows\System32\drivers\etc\hosts.clean"

Get-Content $hostsFile | Where-Object {!$_.Contains("AUTOCREATED")} | Out-File -FilePath $cleanHostsFile -Force
Copy-Item $cleanHostsFile -Destination $hostsFile -Force
Remove-Item -Path $cleanHostsFile -Force