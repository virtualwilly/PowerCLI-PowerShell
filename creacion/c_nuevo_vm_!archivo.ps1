# Script que realiza la creación de una máquina virtual a partir de datos cargados en un archivo CSV
# Ejemplo: .\c_vm_!ruta_archivo.ps1 c:\archivo.csv
param($csv)

############################ Definición de funciones.
. "y:\funciones.ps1" 

write-host
write-host "Asegúrese de tener presente los siguientes puntos:"
write-host
write-host "1. Una conexión de red a la letra y:"
write-host
write-host "2. La carpeta de la conexión debe ser: \\fscantv03\hostingwidows\Documentacion_Plataformas\Equipo02\VMWare\Operaciones\PowerCLI"
write-host
write-host "3. Una conexión de red a la letra v:"
write-host
write-host "4. La carpeta de la conexión debe ser: \\fscantv03\vmware"
write-host
write-host "5. Debe estar conectado al vcenter con usuario con suficientes privilegios, esto se puede hacer con el script: y:\des\adm\connect_!vcenter.ps1 vcenter01" 
write-host
write-host "6. Que el archivo de respuesta que introducirá como parámetro al script de creación esté en y:\des\creacion"
write-host
write-host "Si NO tiene todos los puntos antes descritos, pulse la letra S para salir."
$listo = Read-host "Si todo está listo pulse cualquier otra tecla:"

if ($listo -eq "S" -or $listo -eq "s")
	{Exit}

Copy-Item v:\4vmware\$csv y:\des\creacion\$csv

$net = import-csv $csv | where { $_.Columna1 -match "Network Adapter"; }
[int]$cnet = ($net).Count
if ([int]$cnet -le 1)
	{$echonic = 1}
else
	{$echonic = $cnet}

$disk = import-csv $csv | where { $_.Columna1 -match "vdisk"; }
$cdisk = ($disk).Count

$nota = import-csv $csv | where { $_.Columna1 -match "Nota"; }
$cnota = ($nota).Count
#$debug = read-host "sobre el número de notas: $cnotas"

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
$so = $arch[14].Columna2
$fuente  = $arch[15].Columna2
$backup = $arch[16].Columna2
$echovlan = ""
$echodisk = ""

if ($tipo -eq "nuevo") 
{
	write-host
	write-host "Se validó que el archivo es para crear un servidor nuevo."
}
else
{
	write-host
	read-host "ERROR: El archivo no corresponde para hacer un servidor nuevo, por favor revisa el archivo e informa al cliente."
	write-host
	Exit
}

#$cluster= Read-Host "Introduzca el nombre del cluster en el que se almacenará el servidor virtual (ClusterUCS01 / ClusterIBM01 / ClusterIBM02)"
#$datastore = Read-Host "Introduzca el nombre del datastore donde se almacenarán los discos"
$datastore = q_FindDataStoreInClusterExepcion ClusterUCS01 1 1

New-VM -ResourcePool $rpool -Name $vmname -Version v8 -Datastore $datastore -DiskStorageFormat thick -Location $folder -GuestId $so -CD 

Enable-vCpuHotAdd $vmname
Enable-MemHotAdd $vmname

#Creación de las Tarjetas de Red especificadas
Get-NetworkAdapter -VM $vmname | Remove-NetworkAdapter -Confirm:$false;

If (!$cnet)
{	
	if($net.Columna2 -eq "VM Network")
	{
		$vlan = $net.Columna3
		$vlancon = "VLAN$vlan"
		Get-VMHost | Get-VirtualSwitch -Name vSwitch1 | New-VirtualPortGroup -Name VLAN$vlan -VLANID $vlan
		$echovlan = $echovlan + "vLan Nueva= $vlan"
		$archivo = "y:\des\creacion\vlan.cfg"
		$enter = "`n"
		$linea1 = "esxcli network vswitch standard portgroup add --portgroup-name=VLAN$vlan --vswitch-name=vSwitch1"
		$linea2 = "esxcli network vswitch standard portgroup set --portgroup-name=VLAN$vlan --vlan-id=$vlan"
		Add-Content $archivo $linea1
		Add-Content $archivo $linea2
	}
	else
	{	
		$tmp1 = $net.Columna2
		$tmp2 = $tmp1.split("N")
		$v = $tmp2[1]
		$echovlan = $echovlan + "vLan = $v"
		Get-VM $vmname |  New-NetworkAdapter -NetworkName $net.Columna2 -WakeOnLan -StartConnected 
	}
	
	if($net.Columna2 -eq "VM Network")
	{
		Get-VM $vmname | Get-NetworkAdapter -Name $net.Columna1 | Set-NetworkAdapter -NetworkName $vlancon -Confirm:$false
		$echovlan = $echovlan + "VM Network"
	}
}
else
{
	for($i=0; $i -lt $cnet;$i++)
	{
		if($net[$i].Columna2 -eq "VM Network")
		{
			$vlan = $net[$i].Columna3
			$vlancon = "VLAN$vlan"
			Get-VMHost | Get-VirtualSwitch -Name vSwitch1 | New-VirtualPortGroup -Name VLAN$vlan -VLANID $vlan
			$echovlan = $echovlan + "vLan$i=$vlan, "
			#$debug = read-host "chequeo 3 $echovlan"
			$archivo = "y:\des\creacion\vlan.cfg"
			$enter = "`n"
			$linea1 = "esxcli network vswitch standard portgroup add --portgroup-name=VLAN$vlan --vswitch-name=vSwitch1"
			$linea2 = "esxcli network vswitch standard portgroup set --portgroup-name=VLAN$vlan --vlan-id=$vlan"
			Add-Content $archivo $linea1
			Add-Content $archivo $linea2
		}
		else
		{
			$tmp1 = $net[$i].Columna2
			$tmp2 = $tmp1.split("N")
			$v = $tmp2[1]
			$echovlan = $echovlan + "vLan$i=" + $v + ", "
			Get-VM $vmname |  New-NetworkAdapter -NetworkName $net[$i].Columna2 -WakeOnLan -StartConnected 
		}
	}
		if($net[$i].Columna2 -eq "VM Network")
		{
			Get-VM $vmname | Get-NetworkAdapter -Name $net[$i].Columna1 | Set-NetworkAdapter -NetworkName $vlancon -Confirm:$false			
		}
}

#Creación de la cantidad de discos especificados
Get-HardDisk -VM $vmname | Remove-HardDisk -Confirm:$false
if (!$cdisk)
{
	$hd = $disk.Columna2
	$echodisk = $echodisk + "vDisk1=" + $hd/1048576 + " Gb."
	New-Harddisk -vm $vmname -CapacityKB $disk.Columna2 -StorageFormat $disk.Columna3 

}
else
{

	for($i=0; $i -lt $cdisk;$i++)
	{
		$hd = $disk[$i].Columna2
		$echodisk = $echodisk + "vDisk$i= " + $hd/1048576 + " Gb, "
		New-Harddisk -vm $vmname -CapacityKB $disk[$i].Columna2 -StorageFormat $disk[$i].Columna3 
	}
}

#Agrega las notas
if($cnota)
{
	$debug = !$cnota
	#$debug = read-host "si no tiene notas, porque entra?, investigar. $debug"
	Set-VM -VM $vmname -Description $nota.Columna2 -Confirm:$false;
}
else
{
	$notaf = $nota[0].Columna2 
	for($i=1; $i -lt $cnota;$i++)
	{
		#Get-VM -Name $vmname | Set-CustomField -Name "Creation Date" -Value $date -Confirm:$false
		$notaf = $notaf + "`n " + $nota[$i].Columna2 
	}
	Set-VM -VM $vmname -Description $notaf -Confirm:$false;
}

#Modifica la momeria y cpus de la vm
Get-VM -Name $vmname | Set-VM -MemoryMB $ram -NumCPU $cpu -Confirm:$false

# Get-ScsiController -VM $vmname | Set-ScsiController -Type $SCSI
Get-ScsiController -VM $vmname

#Agrega las anotaciones 
Get-VM -Name $vmname | Set-CustomField -Name "Ambiente" -Value $ambiente -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "Remedy" -Value $remedy -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "Repositorio" -Value $folder -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "Responsable" -Value $responsable -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "Servicio" -Value $servicio -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "emailSupervisor" -Value $emalsuper -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "emailTecnico" -Value $emailtecn -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "Funcion" -Value $funcion -Confirm:$false

switch ($so)
{
	rhel6_64Guest {$dato_so = "Red Hat Enterprise Linux 6 (64 bit)"}
	rhel6Guest {$dato_so = "Red Hat Enterprise Linux 6"}
	rhel5_64Guest {$dato_so = "Red Hat Enterprise Linux 5 (64 bit)"}
	rhel5Guest {$dato_so = "Red Hat Enterprise Linux 5"}
	rhel4_64Guest {$dato_so = "Red Hat Enterprise Linux 4 (64 bit)"}
	rhel4Guest  {$dato_so = "Red Hat Enterprise Linux 4"}
	rhel3_64Guest {$dato_so = "Red Hat Enterprise Linux 3 (64 bit)}"}
	rhel3Guest {$dato_so = "Red Hat Enterprise Linux 3"}
	rhel2Guest {$dato_so = "Red Hat Enterprise Linux 2"}
	windows7Server64Guest {$dato_so = "Windows Server 2008 R2 (64 bit) "}
	winNetEnterprise64Guest {$dato_so = "Windows Server 2003, Enterprise Edition (64 bit) "}
	winNetEnterpriseGuest {$dato_so = "Windows Server 2003, Enterprise Edition "}
	winNetStandard64Guest {$dato_so = "Windows Server 2003, Standard Edition (64 bit) "}
	winNetStandardGuest {$dato_so = "Windows Server 2003, Standard Edition "}
	winNetWebGuest {$dato_so = "Windows Server 2003, Web Edition "}
	win2000ServGuest {$dato_so = "Windows 2000 Server "}
	win2000AdvServGuest {$dato_so = "Windows 2000 Advanced Server "}	
	debian6Guest  {$dato_so = "Debian GNU/Linux 6 (32 bit) "}
	debian6_64Guest {$dato_so = "Debian GNU/Linux 6 (64 bit) "}
	debian5_64Guest {$dato_so = "Debian GNU/Linux 5 (64 bits) "}
	debian5Guest {$dato_so = "Debian GNU/Linux 5 (32 bits) "}
	debian4_64Guest {$dato_so = "Debian GNU/Linux 4 (64 bit) "}
	debian4Guest {$dato_so = "Debian GNU/Linux 4 (32 bits) "}
	centos64Guest {$dato_so = "CentOS 4/5/6 (64 bit)"}
	centosGuest {$dato_so = "CentOS 4/5/6 (32 bit)"}
}

$ramgb = $ram/1024
$datos = "vSo=$dato_so, vCpu=$cpu, vRam= $ramgb Gb, vNic=$echonic, $echovlan $echodisk"
echo "Se creó el servidor virtual $vmname con las siguientes características:" > Y:\des\creacion\remedy.txt
echo $datos >> Y:\des\creacion\remedy.txt
echo $emailtecn >> Y:\des\creacion\remedy.txt
Invoke-Item Y:\des\creacion\remedy.txt

clear-host

# Copia el archivo de $csv al directorio Y:\des\change para que actualice el arhivo de excel Aprovisionamiento_vms.xls.
Copy-Item y:\des\creacion\$csv y:\des\change\$csv
$msg = "Se procedió a copiar el archivo de configuración $csv a la ruta y:\des\change\"
if ($echo)			# salida por pantalla.
	{echo_ 1 $msg}
if ($log)			# Escribe al log.
{writelog $Logfile $msg}
write-host
write-host "Se copio el archivo de $csv al directorio Y:\des\change para que actualice el arhivo de excel Aprovisionamiento_vms.xls"
write-host
$resp = read-host "Pulse cualquier tecla para informarnos que ha leido el aviso de la copia."
write-host

# Mueve el archivo para liberar el directorio a un histórico llamado ejecutados.
write-host "Desea mover el archivo $csv a la carpeta de ejecutados para respaldo?."
$resp = read-host "Pulse <S> ó <s> para moverlo de carpeta u otra letra para no moverlo"
write-host
write-host
if ($resp -eq "s" -or $resp -eq "S")
{
	Move-Item y:\des\creacion\$csv y:\des\creacion\ejecutados\$csv
	$msg = "Se procedió a mover el archivo de configuración $csv para tenerlo como respaldo a la ruta y:\des\creacion\ejecutados\"
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}
}

write-host "Recomendamos que al terminar de revisar la clonación registre esta creación ejecutando el script"
write-host 
write-host "Y:\des\change\ch_registra_creaciones_!archivo.ps1 [nombre del archivo.txt]"
write-host
write-host "Este proceso ya copió el archivo de control en la ruta y:\des\change para su mayor comodidad."

$res = read-host "Desea que ejecutemos el scritp de registro del servidor en en archivo Aprovisionamiento_vms.xls? (s/n)"
write-host
write-host
if ($res -eq "s" -or $res -eq "S")
{
	clear-host
	write-host "Recuerde cerrar o guardar todos las hojas de excel que tiene abierta."
	write-host
	read-host "Pulse cualquier tecla"	
	cd y:\des\change
	write-host	
	.\ch_registra_Aprovisionamiento_vms_!archivo.ps1 $csv
}
else
{
cd y:\
.\Menu.ps1
}