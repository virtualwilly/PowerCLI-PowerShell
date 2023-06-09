param($p_vm, $p_esxi)
Get-VM -Name $p_vm |Move-VM -Destination (Get-VMHost $p_esxi)
