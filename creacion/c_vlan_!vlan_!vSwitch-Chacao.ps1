# Crea una vlan pasada por parámetro en el vSwitch especificado de todos los ESXi
# EJEMPLO .\c_vlan_!vlan_!vSwitch-Chacao.ps1 219 VLAN219

param($p_vlan,$p_vland)
Get-VMHost | Get-VirtualSwitch -Name "vSwitch0" | New-VirtualPortGroup -Name $p_vland -VLANID $p_vlan