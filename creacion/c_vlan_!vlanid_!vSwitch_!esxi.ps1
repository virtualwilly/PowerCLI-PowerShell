# Crea una vlan pasada por parámetro en el vSwitch especificado de todos los ESXi
# EJEMPLO .\c_vlan_!vlan_!vswitch.ps1 219 vSwitch1

param($vlan,$vswitch,$esxi)
$vswitch = $vswitch.ToLower()
$Error.Clear()
$validar = get-virtualswitch -Name $vswitch
if ($Error.Count -eq 1)
	{
	write-host "El virtual switch introducido en no existe. A continuación mostramos el error que abre al aplicar el comando."
	write-host
	write-host $Error[0]
	}
else		
	{
	if ($vswitch -eq "vswitch1")
		{
		Get-VMHost -name $esxi.cantv.com.ve | Get-VirtualSwitch -Name $vswitch | New-VirtualPortGroup -Name "VLAN$vlan" -VLANID $vlan		
		}
	}
