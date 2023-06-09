#script que crea una nueva nic a un vm.
#parámetros:
#1. nombre de la vm
#2. tipo de tarjeta de red.
#3. número de la vlan.
#ej: c_nic_!vm_!typeNic_!vlan.ps1 Train E1000 "VLAN29" 3

param($p_vm, $p_tipo, $p_vlan, $p_num)
$vm = Get-VM $p_vm
New-NetworkAdapter -VM $vm -NetworkName "VM Network" -WakeOnLan -StartConnected -Type $p_tipo
$vm | Get-NetworkAdapter | where { $_.Name -eq "Network Adapter $p_num" } | Set-NetworkAdapter -NetworkName $p_vlan -Confirm:$false

 