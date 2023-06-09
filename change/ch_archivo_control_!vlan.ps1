#Script que incluye una vlan en el archivo de control de vlan´s.
param ($vlan)

#New-PSDrive -Name s -PSProvider FileSystem -Root \\fscantv03\hostingwindows\Documentacion_Plataformas\Equipo02\VMWare\Operaciones\PowerCLI\des\creacion
$archivo = "y:\des\creacion\vlan.cfg"
$enter = "`n"
$linea1 = "esxcli network vswitch standard portgroup add --portgroup-name=VLAN$vlan --vswitch-name=vSwitch1"
$linea2 = "esxcli network vswitch standard portgroup set --portgroup-name=VLAN$vlan --vlan-id=$vlan"
Add-Content $archivo $linea1
Add-Content $archivo $linea2