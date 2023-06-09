# script 
param($cluster, $vSwitch, $vlanid)

# Dado el cluster que se recibe como parámetro, se busca todos los esx / esxi que pertenezcan 
# al cluster sin importar que estén en mantenimiento o no y lo almacena en la variable $esxi
$esxi = Get-VMHost -Location $cluster  | Where-Object{$_.Connectionstate -match "Connected|Maintenance"} 


$esxi | Get-View | ?{$_.Config.Network | %{$_.portGroup} | ?{$_.key -imatch $pgroup}} | %{$_.ConfigManager} | %{$_.NetworkSystem} | %{(Get-View $_).UpdatePortGroup($pgroup, (New-Object VMware.Vim.HostPortGroupSpec -Property @{Name=$pgroup; VlanId=$vlanid; VswitchName=$vSwitch; Policy=(New-Object VMware.Vim.HostNetworkPolicy -Property @{nicTeaming=(New-Object VMware.Vim.HostNicTeamingPolicy -Property @{notifySwitches=$false})})}))}




