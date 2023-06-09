param($esxi,$vswitch,$vlan)

Get-VMHost -name "$esxi.cantv.com.ve" | Get-VirtualSwitch -Name $vswitch | New-VirtualPortGroup -Name "VLAN$vlan" -VLANID $vlan