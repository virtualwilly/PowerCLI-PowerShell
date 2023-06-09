# Crea una vlan pasada por parámetro en el vSwitch especificado de todos los ESXi
# EJEMPLO .\c_vlan_!vlan_!vswitch_!Cluster.ps1 219 vSwitch1 ClusterIBM01

param($vlan,$vswitch,$cluster)
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
		Get-Cluster $cluster | Get-VMHost | Get-VirtualSwitch -Name $vswitch | New-VirtualPortGroup -Name "VLAN$vlan" -VLANID $vlan
		$archivo = "y:\des\creacion\vlan.cfg"
		$enter = "`n"
		$linea1 = "esxcli network vswitch standard portgroup add --portgroup-name=VLAN$vlan --vswitch-name=vSwitch1"
		$linea2 = "esxcli network vswitch standard portgroup set --portgroup-name=VLAN$vlan --vlan-id=$vlan"
		Add-Content $archivo $linea1
		Add-Content $archivo $linea2
		write-host
		write-host "NOTA: Por favor mover la recien creada VLAN en Inventory --> Networking a la carpeta respectiva para su mejor administración mientras automatizamos el proceso."
		}
	else
		{
		write-host "Las vlans asociadas a otros virtual Switch diferentes al vSwitch1 se definen directamente desde el script c_archivo_respuesta_instalacion_ESXi.ps1"
		Get-Cluster $cluster | Get-VMHost | Get-VirtualSwitch -Name $vswitch | New-VirtualPortGroup -Name "VLAN$vlan" -VLANID $vlan
		write-host
		write-host "De todas formas se creó la vlan solicitada en el vSwitch solicitado y en el cluster solicitado."
		}
	}
