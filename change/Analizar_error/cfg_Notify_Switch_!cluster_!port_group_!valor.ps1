#param($cluster, $pgroup, $vSwitch, $vlanid, $valor)
param($cluster, $vSwitch, $vlanid, $valor)

Get-VMHost -Location $cluster | Where-Object{$_.Connectionstate -match "Connected|Maintenance"} | Get-View | Where-Object{$_.Config.Network | ForEach-Object{$_.portGroup} | Where-Object{$_.key -imatch "LabAlpha"}} | ForEach-Object{$_.ConfigManager} | ForEach-Object{$_.NetworkSystem} | ForEach-Object{(Get-View $_).UpdatePortGroup("LabAlpha", (New-Object VMware.Vim.HostPortGroupSpec -Property @{Name="LabAlpha"; VlanId=$vlanid; VswitchName=$vSwitch; Policy=(New-Object VMware.Vim.HostNetworkPolicy -Property @{nicTeaming=(New-Object VMware.Vim.HostNicTeamingPolicy -Property @{notifySwitches=$valor})})}))}

