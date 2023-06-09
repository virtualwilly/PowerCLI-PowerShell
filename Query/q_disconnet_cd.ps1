Get-Vm | Where-Object {
((Get-CDDrive -VM $_ | Where-Object { (($_.ConnectionState.Connected -eq $True) -or ($_.ConnectionState.StartConnected -eq $True))} ) -ne $Null } | %{
"VM: " + $_.Name + " (" + $_.PowerState + ")"

Get-CDDrive -VM $_ | ForEach-Object { " " + $_.Name + " Connected=" + $_.ConnectionState.Connected + " ConnectAtPowerUp=" + $_.ConnectionState.StartConnected }

}