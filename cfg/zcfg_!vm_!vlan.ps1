# comando que define la vlan a una vNic. Parámetros nombre vm y vlan nueva a configurar
#ej: cfgvlan.ps1 vmlinux "VLAN20"
param($p_vm, $p_vlan)
$vm = Get-VM $P_vm
$vm | Get-NetworkAdapter | where { $_.Name -eq "Network Adapter 2" } | Set-NetworkAdapter -NetworkName $p_vlan -Confirm:$false
