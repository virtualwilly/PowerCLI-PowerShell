# Elimina una vlan pasada por parámetro en el vSwitch especificado de todos los ESXi
# EJEMPLO .\r_!vlan_!vSwitch.ps1 "VLAN219" vSwitch1
#
param($dvlan,$vswitch)
get-vmhost | Get-VirtualSwitch -Name $vswitch | Get-VirtualPortGroup -Name $dvlan | Remove-VirtualPortGroup
