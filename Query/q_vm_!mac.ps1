param($p_mac)
Get-vm | Select Name, @{N=“Network“;E={$_ | Get-networkAdapter | ? {$_.macaddress -eq $p_mac}}} | Where {$_.Network-ne “”}

