param ($vswitch, $vlan)
$pg = Get-VMHost -location (get-cluster -name ClusterUCS01) | Get-VirtualSwitch -Name $vswitch | Get-VirtualPortGroup -Name VLAN$vlan
Remove-VirtualPortGroup -VirtualPortGroup $pg

