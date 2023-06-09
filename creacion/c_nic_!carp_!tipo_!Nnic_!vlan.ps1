# ej: c_nic_!carp_!tipo_!Nnic_!vlan.ps1
param($carpeta,$tipo,$num,$vlan)

$vms = get-vm -Location $carpeta
ForEach($vm in $vms)
{
New-NetworkAdapter -VM $vm -NetworkName "VM Network" -WakeOnLan -StartConnected -Type $tipo
$vm | Get-NetworkAdapter | where { $_.Name -eq "Network Adapter $num" } | Set-NetworkAdapter -NetworkName $vlan -Confirm:$false
}
