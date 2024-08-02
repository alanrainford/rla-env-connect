#
#  This script should be run from the windows OS powershell.  The sleep value may not be correct for your use.
#
#  Author: arainfor
#
function Start-Sleep($seconds) {
    $doneDT = (Get-Date).AddSeconds($seconds)
    while ($doneDT -gt (Get-Date)) {
        $secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
        $percent = ($seconds - $secondsLeft) / $seconds * 100
        Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining $secondsLeft -PercentComplete $percent
        [System.Threading.Thread]::Sleep(500)
        $wslHosts = @(wsl cat /etc/hosts)
        $finished = ($wslHosts[($wslHosts.length - 1)].Contains("AUTOCREATED"))
        if ( $finished )
        {
            $doneDT = (Get-Date)
        }
    }
    Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining 0 -Completed
}

cd $PSScriptRoot

Echo "Starting WSL tunnels...."
$commands = "bash -c ./sshuttle-admin-d0.sh"
Start-Process -FilePath "wsl" -ArgumentList " -- $commands" -PassThru 
#wsl bash -c ./sshuttle-admin-d0.sh&
Echo "Waiting 120 seconds for tunnels to complete...."
Start-Sleep -Seconds 120

Echo "Adding route to WSL network adapter...."
.\win-add-route.ps1

Echo "Syncing WSL to Windows host entries...."
.\win-sync-hosts.ps1
Echo "Done!"
