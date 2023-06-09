# Script que realiza la clonación de una máquina virtual a partir de datos cargados en un archivo plano.
# Ejemplo: .\c_clon_!archivo.ps1 c:\archivo.csv 1 1
# Autor: William Téllez (CSTS-Windows)
# Fecha última modificación: 25/09/2013
param($csv,$echo,$log)

#1. $Salida = Se detiene en lugares claves para revisar la salida y poder detectar errores.
# Valor = 1, se detiene
# Valor = 0, no se detiene.
$Salida = 0
$Logfile = "Y:\des\creacion\logs\c_clon_!archivo.log"

############################ Definición de funciones.
. "y:\funciones.ps1" 

######################### Cuerpo del script.

write-host
write-host "Asegúrese de tener presente los siguientes puntos:"
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
$listo = Read-host "Si todo está listo pulse cualquier otra tecla"

if ($listo -eq "S" -or $listo -eq "s")
	{Exit}
	
$msg = "-------------------- Inicio del proceso de clonación automática -----------"
# salida por pantalla.
if ($echo)
	{$r = echo_ 1 $msg}
# Escribe al log.
if ($log)
	{$r = writelog $Logfile $msg}	
	
$arch = import-csv $csv
$hostname_origen = $arch[0].Columna2 
$hostname_destino = $arch[1].Columna2 
$responsable = $arch[2].Columna2
$vcpu = $arch[3].Columna2
$arquitectura = $arch[4].Columna2
$vram = $arch[5].Columna2
$ambiente = $arch[6].Columna2
$folder = $arch[7].Columna2
$servicio = $arch[8].Columna2
$emalsuper = $arch[9].Columna2
$emailtecn = $arch[10].Columna2
$funcion = $arch[11].Columna2
$rpool = $arch[12].Columna2
$remedyCeros = $arch[13].Columna2 
$remedy = EliminaCerosIzq $remedyCeros
$tipo = $arch[14].Columna2
$fuente  = $arch[15].Columna2


if ($tipo -eq "clon_mod") 
{
	write-host "Se validó que el archivo es para clonar un servidor."
}
else
{
	write-host "ERROR: El archivo no corresponde para hacer un clon con modificaciones, por favor revisa el archivo e informa al cliente."
	write-host
	read-host "Valor del tipo tomado por el script: $tipo"
	cd y:\	
	Exit
}


$msg = "Se leyó del archivo $csv recibido por parámetro y se tomaron sus valores para crear el servidor virtual."
if ($echo) 		# salida por pantalla.
	{echo_ 1 $msg}
if ($log)	# Escribe al log.
	{writelog $Logfile $msg}	

clear-host

$msg = "-------------------------------------------- SALIDA POR CONSOLA"
if ($echo)			# salida por pantalla.
	{echo_ 1 $msg}
$msg = "Búsqueda y selección del data store con mayor espacio libre, mayor información Y:\des\Query\Logs\q_FindDataStoreInCluster.log."
if ($echo)			# salida por pantalla.
	{echo_ 1 $msg}


$DStore_Won  = q_FindDataStoreInClusterExepcion ClusterUCS01 $echo $log

	clear-host	
	$msg = " -------------------------------- Proceso de clonación del servidor"	
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}
	
	# Genera un número aleatorio entre 1 y 9
	$num_random = get-random -minimum 1 -maximum 9
	$esxi = "esxicnt0$num_random" + ".cantv.com.ve"
	
	$msg = "Definición aleatoria del servidor Esxi donde se alojará el servidor virtual, resultado: $esxi "
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}
	
	# Clona el servidor en el data store con mayor espacio y en el folder que corresponde.	
	$clon = New-VM -Name $hostname_destino -VM $hostname_origen -Datastore $DStore_Won -VMHost $esxi -Location $folder
	
	Enable-vCpuHotAdd $hostname_destino
	Enable-MemHotAdd $hostname_destino
	
	$msg = "Se procedió a clonar el servidor $hostname_destino tomado del ya existente $hostname_origen ."
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}
	
	# Consulta el tamaño del primer disco del servidor del cual se clonará.
	$disks = get-harddisk -vm $hostname_origen
	$disk0 = $disks[0].CapacityKB/1024/1024
	
	$msg = "Se consulta el tamaño del servidor origen del cual se clonó el servidor, siendo el resultado de la consulta: $disk0 Gb."
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}
	
	clear-host	
	$msg = " Se procede a registrar los annotations correspondiente al servidor $hostname_origen "
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}	

	
	#Agrega las anotaciones 
	Get-VM -Name $hostname_destino | Set-CustomField -Name "Ambiente" -Value $ambiente -Confirm:$false
	Get-VM -Name $hostname_destino | Set-CustomField -Name "Remedy" -Value $remedy -Confirm:$false
	Get-VM -Name $hostname_destino | Set-CustomField -Name "Repositorio" -Value $folder -Confirm:$false
	Get-VM -Name $hostname_destino | Set-CustomField -Name "Responsable" -Value $responsable -Confirm:$false
	Get-VM -Name $hostname_destino | Set-CustomField -Name "Servicio" -Value $servicio -Confirm:$false
	Get-VM -Name $hostname_destino | Set-CustomField -Name "emailSupervisor" -Value $emalsuper -Confirm:$false
	Get-VM -Name $hostname_destino | Set-CustomField -Name "emailTecnico" -Value $emailtecn -Confirm:$false
	Get-VM -Name $hostname_destino | Set-CustomField -Name "Funcion" -Value $funcion -Confirm:$false
	
	$msg = "El proceso de registro de los annotations ha culminado."
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}	
	
	clear-host	
	$msg = "-------------------------------- Proceso de configuración de los discos."
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}		
		
	#Rutina que elimina los discos del servidor recién clonado.
	$disk = Get-HardDisk -vm $hostname_destino
	$num_disk = ($disk).count	
	
	$msg = "Se detectaron $num_disk de los cuales se procederá a eleminar todos menos el primario que corresponde al de sistema operativo."
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}	
	
	for ($i=$num_disk; $i -eq 2;$i--)
		{ 
			switch ($i)
				{
				2 {get-harddisk -vm $hostname_destino | where {$_.Name -eq "Hard disk 2"} | Remove-HardDisk -Confirm:$false -DeletePermanently}
				3 {get-harddisk -vm $hostname_destino | where {$_.Name -eq "Hard disk 3"} | Remove-HardDisk -Confirm:$false -DeletePermanently}
				4 {get-harddisk -vm $hostname_destino | where {$_.Name -eq "Hard disk 4"} | Remove-HardDisk -Confirm:$false -DeletePermanently}
				5 {get-harddisk -vm $hostname_destino | where {$_.Name -eq "Hard disk 5"} | Remove-HardDisk -Confirm:$false -DeletePermanently}
				6 {get-harddisk -vm $hostname_destino | where {$_.Name -eq "Hard disk 6"} | Remove-HardDisk -Confirm:$false -DeletePermanently}
				7 {get-harddisk -vm $hostname_destino | where {$_.Name -eq "Hard disk 7"} | Remove-HardDisk -Confirm:$false -DeletePermanently}
				8 {get-harddisk -vm $hostname_destino | where {$_.Name -eq "Hard disk 8"} | Remove-HardDisk -Confirm:$false -DeletePermanently}
				9 {get-harddisk -vm $hostname_destino | where {$_.Name -eq "Hard disk 9"} | Remove-HardDisk -Confirm:$false -DeletePermanently}
				}		
			$msg = "Se procedió a eliminar $i discos del servidor $hostname_destino "
			if ($echo)			# salida por pantalla.
				{echo_ 1 $msg}
			if ($log)			# Escribe al log.
			{writelog $Logfile $msg}			
		}
		
	#Error 20 "ya pasó por la eliminacion de los discos."
	
	#Agrega los discos que se requieren.
	$disk = import-csv $csv | ?{$_.Columna1 -match "vdisk"}
	$cdisk = ($disk).Count

	
	$msg = "El archivo de clonación nos informa que se necesitan $cdisk discos a incluir en el servidor $hostname_destino "
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}
	
	
	if (!$cdisk)
	{
		$msg = "Se detectó que necesita la creación de un solo disco, se procede a crearlo."
		if ($echo)			# salida por pantalla.
			{echo_ 1 $msg}
		if ($log)			# Escribe al log.
		{writelog $Logfile $msg}		
		
		$hd = $disk.Columna2	
		
		$msg = "Tamaño o capacidad del disco a adicionar: $hd con la siguiente configuración $disk[$i].Columna3 "
		if ($echo)			# salida por pantalla.
			{echo_ 1 $msg}
		if ($log)			# Escribe al log.
		{writelog $Logfile $msg}	
		
		
		$resultado = New-Harddisk -vm $hostname_destino -CapacityKB $disk.Columna2 -StorageFormat $disk.Columna3
		$msg = "El resultado de la creación del disco fue: $resultado "
		if ($echo)			# salida por pantalla.
			{echo_ 1 $msg}
		if ($log)			# Escribe al log.
		{writelog $Logfile $msg}	
	}
	else
	{
		for($i=0; $i -lt $cdisk;$i++)
			{
				$msg = "Se detectó que necesita la creación de un solo disco, se procede a crearlo."
				if ($echo)			# salida por pantalla.
					{echo_ 1 $msg}
				if ($log)			# Escribe al log.
				{writelog $Logfile $msg}

				$hd = $disk[$i].Columna2					
				$msg = "El tamaño del nuevo disco a incorporar es $hd con la siguiente configuración $disk[$i].Columna3 "
				if ($echo)			# salida por pantalla.
					{echo_ 1 $msg}
				if ($log)			# Escribe al log.
				{writelog $Logfile $msg}
				
				
				$resultado = New-Harddisk -vm $hostname_destino -CapacityKB $disk[$i].Columna2 -StorageFormat $disk[$i].Columna3
				$msg = "El resultado de la creación del disco fue: $resultado "
				if ($echo)			# salida por pantalla.
					{echo_ 1 $msg}
				if ($log)			# Escribe al log.
				{writelog $Logfile $msg}							
			}
	}
	
	clear-host	
	$msg = "-------------------------------- Configuración de la vRam y vCpu "
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}	
	
	#Modifica la momeria y cpus de la vm
	Get-VM -Name $hostname_destino | Set-VM -MemoryMB $vram -NumCPU $vcpu -Confirm:$false
	$msg = "Se procedió a ajustar tanto la vRam a $vram como la vCpu a $vcpu"
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}	
	
	
	# Elimina todas las tarjetas del servidor para luego reconfigurarlas según solicitud.
	Get-NetworkAdapter -VM $hostname_destino | Remove-NetworkAdapter -Confirm:$false;
	$msg = "Se procedió a eliminar todas las tarjetas del servidor para luego reconfigurarlas según solicitud."
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}
	
	#Creación de las Tarjetas de Red especificadas
	$net = import-csv $csv | where { $_.Columna1 -match "Network Adapter"; }
	$cnet = ($net).Count
	$echovlan = ""
	
	$msg = "Se procedió a configurar la cantidad de tarjetas virtuales a configurar: $cnet"
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}
	

	If (!$cnet)
	{			
		$msg = "Se determinó que se requiere adicionar una sola tarjeta de red."
		if ($echo)			# salida por pantalla.
			{echo_ 1 $msg}
		if ($log)			# Escribe al log.
		{writelog $Logfile $msg}
		
		
		if($net.Columna2 -eq "VM Network")
		{			
			$msg = "Se detectó que la columna dos tiene la clave VM Network que indica que la vlan no está creada."
			if ($echo)			# salida por pantalla.
				{echo_ 1 $msg}
			if ($log)			# Escribe al log.
			{writelog $Logfile $msg}		
	
			$vlan = $net.Columna3
			$vlancon = "VLAN$vlan"
			Get-VMHost | Get-VirtualSwitch -Name vSwitch1 | New-VirtualPortGroup -Name VLAN$vlan -VLANID $vlan			
			$msg = "Se procedió a crear la vlan en todos los ESXi, específicamente en el Switch 1."
			if ($echo)			# salida por pantalla.
				{echo_ 1 $msg}
			if ($log)			# Escribe al log.
			{writelog $Logfile $msg}								
			
			# Actualización del archivo vlan.cfg para el mantenimiento de vlan en el proceso automático de instalación de s.o.
			$echovlan = $echovlan + "vLan Nueva= $vlan"
			$archivo = "y:\des\creacion\vlan.cfg"
			$enter = "`n"
			$linea1 = "esxcli network vswitch standard portgroup add --portgroup-name=VLAN$vlan --vswitch-name=vSwitch1"
			$linea2 = "esxcli network vswitch standard portgroup set --portgroup-name=VLAN$vlan --vlan-id=$vlan"
			Add-Content $archivo $linea1
			Add-Content $archivo $linea2
			
			
			$msg = "Se actualizó el archivo vlan.cfg quien tiene el listado de las vlans."
			if ($echo)			# salida por pantalla.
				{echo_ 1 $msg}
			if ($log)			# Escribe al log.
			{writelog $Logfile $msg}	
		}
		else
		{	
			write-host "Se toma el número de vlan registrado en la columna 2, se crea una nueva tarjeta y se asigna dicha vlan."
			$tmp1 = $net.Columna2
			$tmp2 = $tmp1.split("N")
			$v = $tmp2[1]
			Get-VM $hostname_destino |  New-NetworkAdapter -NetworkName $net.Columna2 -WakeOnLan -StartConnected 
			$echovlan = $echovlan + "vLan = $v"
			
			$msg = "Se procedió a crear una nueva vNic o tarjeta y se asigna a la vlan $v."
			if ($echo)			# salida por pantalla.
				{echo_ 1 $msg}
			if ($log)			# Escribe al log.
			{writelog $Logfile $msg}		
		}
		
		if($net.Columna2 -eq "VM Network")
		{
			Get-VM $hostname_destino | Get-NetworkAdapter -Name $net.Columna1 | Set-NetworkAdapter -NetworkName $vlancon -Confirm:$false
			$echovlan = $echovlan + "VM Network"
			
			$msg = "Crea un nuevo port group. NOTA: No entiendo exactamente que hace la instrucción. Investigar y documentar"
			if ($echo)			# salida por pantalla.
				{echo_ 1 $msg}
			if ($log)			# Escribe al log.
			{writelog $Logfile $msg}				
		}
	}
	else
	{		
			$msg = "Se identifica la necesidad de crear más de una vNic, se procede a su creación y configuración."
			if ($echo)			# salida por pantalla.
				{echo_ 1 $msg}
			if ($log)			# Escribe al log.
			{writelog $Logfile $msg}		
		
		for($i=0; $i -lt $cnet;$i++)
		{
			if($net[$i].Columna2 -eq "VM Network")
			{
				$vlan = $net[$i].Columna3
				$vlancon = "VLAN$vlan"
				Get-VMHost | Get-VirtualSwitch -Name vSwitch1 | New-VirtualPortGroup -Name VLAN$vlan -VLANID $vlan
				$msg = "Se procedió a crear la vlan núero $i etiquetada $vlan en todos los ESXi, específicamente en el Switch 1."
				if ($echo)			# salida por pantalla.
					{echo_ 1 $msg}
				if ($log)			# Escribe al log.
				{writelog $Logfile $msg}			
				
				$archivo = "y:\des\creacion\vlan.cfg"
				$enter = "`n"
				$linea1 = "esxcli network vswitch standard portgroup add --portgroup-name=VLAN$vlan --vswitch-name=vSwitch1"
				$linea2 = "esxcli network vswitch standard portgroup set --portgroup-name=VLAN$vlan --vlan-id=$vlan"
				Add-Content $archivo $linea1
				Add-Content $archivo $linea2
				$echovlan = $echovlan + "vLan$i=$vlan, "
				
				$msg = "Se actualizó el archivo vlan.cfg quien tiene el listado de las vlans."
				if ($echo)			# salida por pantalla.
					{echo_ 1 $msg}
				if ($log)			# Escribe al log.
				{writelog $Logfile $msg}	
			}
			else
			{				
				$tmp1 = $net[$i].Columna2
				$tmp2 = $tmp1.split("N")
				$v = $tmp2[1]
				Get-VM $hostname_destino |  New-NetworkAdapter -NetworkName $net[$i].Columna2 -WakeOnLan -StartConnected 
				$echovlan = $echovlan + "vLan$i=" + $v + ", "
				$msg = "Se procedió a crear una nueva vNic o tarjeta y se asigna a la vlan $v."
				if ($echo)			# salida por pantalla.
					{echo_ 1 $msg}
				if ($log)			# Escribe al log.
				{writelog $Logfile $msg}	
			}
		}
			if($net[$i].Columna2 -eq "VM Network")
			{
				Get-VM $hostname_destino | Get-NetworkAdapter -Name $net[$i].Columna1 | Set-NetworkAdapter -NetworkName $vlancon -Confirm:$false			
				$msg = "Crea un nuevo port group. NOTA: No entiendo exactamente que hace la instrucción. Investigar y documentar"
				if ($echo)			# salida por pantalla.
					{echo_ 1 $msg}
				if ($log)			# Escribe al log.
				{writelog $Logfile $msg}	
			}
	}	
	
clear-host
$msg = "-------------------------------- Configuración de las notas"
if ($echo)			# salida por pantalla.
	{echo_ 1 $msg}
if ($log)			# Escribe al log.
{writelog $Logfile $msg}

$nota = import-csv $csv | where { $_.Columna1 -match "Nota"; }
$cnota = ($nota).Count

# Elimina las notas que existen actualmente
Get-vm -Name $hostname_destino | set-vm -Description "" -Confirm:$false
	
#Agrega las notas
if($cnota -eq 1)
{
	Get-vm -Name $hostname_destino | set-vm -Description $nota.Columna2 -Confirm:$false
}
else
{
	$notaf = $nota[0].Columna2 
	for($i=1; $i -lt $cnota;$i++)
	{
		#Get-VM -Name $vmname | Set-CustomField -Name "Creation Date" -Value $date -Confirm:$false
		$notaf = $notaf + "`n " + $nota[$i].Columna2 
	}
	# lo que estaba antes: Set-VM -VM $vmname -Description $notaf -Confirm:$false;
	Get-vm -Name $hostname_destino | set-vm -Description $notaf -Confirm:$false
}

$msg = "Se procedió a eliminar las notas existenten y se sustituyeron por las notas del archivo de configuración."
if ($echo)			# salida por pantalla.
	{echo_ 1 $msg}
if ($log)			# Escribe al log.
{writelog $Logfile $msg}


# Mueve el servidor al resource pool correspondiente.
move-vm -vm $hostname_destino -Destination $rpool

$msg = "Se procedió a mover el servidor al resource pool correspondiente."
if ($echo)			# salida por pantalla.
	{echo_ 1 $msg}
if ($log)			# Escribe al log.
{writelog $Logfile $msg}

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
if ($resp -eq "s" -or $resp -eq "S")
{
	Move-Item y:\des\creacion\$csv y:\des\creacion\ejecutados\$csv	
	$msg = "Se procedió a mover el archivo de configuración $csv para tenerlo como respaldo a la ruta y:\des\creacion\ejecutados\"
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}
}

# Toma los datos de los discos virtuales.
$diskvm = get-harddisk -vm $hostname_destino
[int]$n = 0
$echodisk = ""
foreach($disk in $diskvm)
{
	[int]$n++
	If ([int]$n -gt 1)
		{$echodisks = $echodisks + ", "}
	$disco = $disk.CapacityKB/1024/1024
	$echodisk = $echodisk + "vDisk$n=$disco"
}

# Toma los datos de la red.
$vm = get-vm -name $hostname_destino
[int]$vnic = $vm.NetworkAdapters.count
$nics = $vm.NetworkAdapters
[int]$n = 0
$echovlans = ""
foreach($nic in $nics)
{
	[int]$n++
	If ([int]$n -gt 1)
		{$echovlans = $echovlans + ", "}
	$vlan = $nic.NetworkName
	$echovlans = $echovlans + "vLan$n=$vlan"
}

$so1 = get-vm -Name $hostname_destino | get-view
$dato_so = $so1.Summary.Config.GuestFullName
$ramgb = $vram/1024
$datos = "vSo=$dato_so, vCpu=$vcpu, vRam= $ramgb Gb, vNic=$cnet, $echovlans, $echodisk"
echo "Se creó el servidor virtual $hostname_destino a partir del servidor $hostname_origen con las siguientes características:" > Y:\des\creacion\remedy.txt
echo $datos >> Y:\des\creacion\remedy.txt
echo $emailtecn >> Y:\des\creacion\remedy.txt
Invoke-Item Y:\des\creacion\remedy.txt

$msg = "-------------------------------- Clonación automática finalizada, se puede proceder a revisar."
if ($echo)			# salida por pantalla.
	{echo_ 1 $msg}
if ($log)			# Escribe al log.
{writelog $Logfile $msg}

write-host
write-host "Recomendamos que al terminar de revisar la clonación registre esta creación ejecutando el script"
write-host 
write-host "Y:\des\change\ch_registra_creaciones_!archivo.ps1 [nombre del archivo.txt]"
write-host
write-host "Este proceso ya copió el archivo en la ruta y:\des\change para su mayor comodidad."
write-host
$res = read-host "Desea que ejecutemos el scritp de registro del servidor en en archivo Aprovisionamiento_vms.xls? (s/n)"
write-host
if ($res -eq "s" -or $res -eq "S")
{
	clear-host
	write-host "Recuerde cerrar o guardar todos las hojas de excel que tiene abierta."
	write-host
	read-host "Pulse cualquier tecla"
	Copy-Item y:\des\creacion\ejecutados\$csv y:\des\change\$csv
	cd y:\des\change
	write-host	
	.\ch_registra_creaciones_!archivo.ps1 $csv
}
else
{
cd y:\
#.\Menu.ps1
}