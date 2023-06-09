# Script 
# Autor: William Téllez (CSTS-Windows)
# Fecha última modificación: 20/02/2014
param($csv)

############################ Definicion de funciones.
. "y:\funciones.ps1" 

######################### Cuerpo del script.

write-host
write-host "Asegurese de tener presente los siguientes puntos:"
write-host
write-host "1. Una conexión de red a la letra <y> a la siguiente ruta:"
write-host
write-host "\\fscantv03\hostingwidows\Documentacion_Plataformas\Equipo02\VMWare\Operaciones\PowerCLI"
write-host
write-host "2. Debe estar conectado al vcenter con usuario con suficientes privilegios, esto se puede hacer con el script: y:\des\adm\connect_!vcenter.ps1 vcenter01" 
write-host
write-host "3. Que el archivo de respuesta que introducirá como parámetro al script de creación esté en y:\des\creacion"
write-host
write-host "Si NO tiene todos los puntos antes descritos, pulse la letra <S> o <s> para salir."
write-host
$listo = Read-host "Si todo esta listo pulse cualquier otra tecla"

$arch = import-csv $csv
$vmname = $arch[0].Columna2 
$responsable = $arch[1].Columna2 
$cpu = $arch[2].Columna2 
$arquitectura = $arch[3].Columna2 
$ram = $arch[4].Columna2 
$ambiente = $arch[5].Columna2 
$folder = $arch[6].Columna2 
$servicio = $arch[7].Columna2 
$emalsuper = $arch[8].Columna2
$emailtecn = $arch[9].Columna2
$funcion = $arch[10].Columna2
$rpool = $arch[11].Columna2
$remedy = $arch[12].Columna2
$tipo = $arch[13].Columna2
$sourcetemplate = $arch[14].Columna2 
$cluster = $arch[15].Columna2 

$valido = get-vm -Name $vmname -erroraction 'silentlycontinue'
If ($valido)
{
	write-host "El script encontro que el servidor ya existe, por favor verificar."
	write-host
	Exit
}

# Escribe datos en un archivo paralelo con el mismo nombre pero con los datos necesarios.
Add-Content Y:\des\change\$csv "Columna1,Columna2,Columna3,Columna4"
Add-Content Y:\des\change\$csv "hostname,$vmname"
Add-Content Y:\des\change\$csv "Nombre y Apellido,$responsable"


if ($tipo -eq "template") 
{
	write-host "Se valido que el archivo es para crear un servidor desde un template."
}
else
{
	read-host "ERROR: El archivo no corresponde para crear un servidor desde un template, por favor revisa el archivo e informa al cliente."
	Exit
}

$datastore = q_FindDataStoreInClusterExepcion ClusterUCS01 1 1

# Genera el servidor a partir del template.
New-VM -Name $vmname -Datastore $datastore -ResourcePool $cluster -Template $sourcetemplate 

Enable-vCpuHotAdd $vmname
Enable-MemHotAdd $vmname

# Lo mueve al contenedor solicitado.
Move-VM -VM $vmname -Destination $folder

# Lo mueve a un resource pool apropiado.
Move-VM -VM $vmname -Destination $rpool

# Le crea una tarjeta de red básica.
Get-VM $vmname |  New-NetworkAdapter -NetworkName VLAN204 -WakeOnLan -StartConnected

# Elimina las notas que existen actualmente
Get-vm -Name $vmname | set-vm -Description "" -Confirm:$false

#Agrega las notas
$nota = "El servidor fue generado del template llamado $sourcetemplate"
Get-vm -Name $vmname | set-vm -Description $nota -Confirm:$false

#Agrega las anotaciones 
Get-VM -Name $vmname | Set-CustomField -Name "Ambiente" -Value $ambiente -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "Remedy" -Value $remedy -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "Repositorio" -Value $folder -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "Responsable" -Value $responsable -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "Servicio" -Value $servicio -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "emailSupervisor" -Value $emalsuper -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "emailTecnico" -Value $emailtecn -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "Funcion" -Value $funcion -Confirm:$false

$vm1 = get-vm -Name $vmname | get-view
$vm2 = get-vm -Name $vmname
$so = $vm1.Summary.Config.GuestFullName
$vcpu = $vm2.NumCpu
Add-Content Y:\des\change\$csv "vcpu,$vcpu"
$vramgb = $vm2.MemoryMb/1024
Add-Content Y:\des\change\$csv "arq,0"
Add-Content Y:\des\change\$csv "vram,$vramgb"
Add-Content Y:\des\change\$csv "Ambiente,$ambiente"
Add-Content Y:\des\change\$csv "Repositorio,$folder"
Add-Content Y:\des\change\$csv "Servicio,$servicio"
Add-Content Y:\des\change\$csv "emailsuper,$emalsuper"
Add-Content Y:\des\change\$csv "correo,$emailtecn"
Add-Content Y:\des\change\$csv "Función,$funcion"
Add-Content Y:\des\change\$csv "Resource Pool,$rpool"
Add-Content Y:\des\change\$csv "Remedy,$remedy"
Add-Content Y:\des\change\$csv "tipo,$tipo"
Add-Content Y:\des\change\$csv "template,$sourcetemplate"
Add-Content Y:\des\change\$csv "cluster,$cluster"
Add-Content Y:\des\change\$csv "Network Adapter,0"
Add-Content Y:\des\change\$csv "vdisk,0"


$cnet = ""
$fin = ($vm2.NetworkAdapters).count
If ($fin -eq 0)
{
	$cnet = "Sin tarjetas"
}
else
{
	for ($i=0; $i -eq $fin;$i++)
	{	
		$j = $i + 1
		$net = $vm2.NetworkAdapters[$i].Name
		$lan = $vm2.NetworkAdapters[$i].Networkname
		$cnet = "vNic $j $net en la vLan $lan " + $cnet
	}
}

$hds=""
$fin = ($vm2.HardDisks).count
for ($i=0; $i -eq $fin;$i++)
{
	$hd = $vm2.HardDisks[$i].CapacityKB/1024/1024
	$j = $i + 1
	$hds = "vDisk $j de $hd Gb" + $hds	
}

# Mueve el archivo para liberar el directorio a un histórico llamado ejecutados.
write-host "Desea mover el archivo $csv a la carpeta de ejecutados para respaldo?."
$resp = read-host "Pulse <S> o <s> para moverlo de carpeta u otra letra para no moverlo"
if ($resp -eq "s" -or $resp -eq "S")
{
	Move-Item y:\des\creacion\$csv y:\des\creacion\ejecutados\$csv	
	$msg = "Se procedio a mover el archivo de configuracion $csv para tenerlo como respaldo a la ruta y:\des\creacion\ejecutados\"
}

# Copia el archivo de $csv al directorio Y:\des\change para que actualice el arhivo de excel Aprovisionamiento_vms.xls.
write-host "Copia el archivo de $csv al directorio Y:\des\change para que actualice el arhivo de excel Aprovisionamiento_vms.xls"
$resp = read-host "Pulse cualquier tecla para informarnos que ha leido el aviso."
if ($resp -eq "s" -or $resp -eq "S")
{
	Copy-Item y:\des\creacion\$csv y:\des\change\$csv
	$msg = "Se procedio a copiar el archivo de configuración $csv a la ruta y:\des\change\"
}

$datos = "vSo=$so, vCpu= $vcpu, vRam= $vramgb Gb, $cnet, vDisk= $hds"
echo "Se creo el servidor virtual $vmname a partir de el template $sourcetemplate con las siguientes caracteristicas:" > Y:\des\creacion\remedy.txt
echo $datos >> Y:\des\creacion\remedy.txt
echo $emailtecn >> Y:\des\creacion\remedy.txt
Invoke-Item Y:\des\creacion\remedy.txt

write-host "Recomendamos que al terminar de revisar la clonación registre esta creación ejecutando el script"
write-host 
write-host "Y:\des\change\ch_registra_creaciones_!archivo.ps1 [nombre del archivo.txt]"
write-host
write-host "Este proceso ya copio el archivo de control en la ruta y:\des\change para su mayor comodidad."
