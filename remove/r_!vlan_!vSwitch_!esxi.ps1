# Elimina una vlan pasada por parámetro en el vSwitch especificado de todos los ESXi
# EJEMPLO .\r_!vlan_!vSwitch.ps1 "VLAN219" vSwitch1
#
param($dvlan,$vswitch,$esxi)
get-vmhost -name $esxi.cantv.com.ve | Get-VirtualSwitch -Name $vswitch | Get-VirtualPortGroup -Name $dvlan | Remove-VirtualPortGroup
