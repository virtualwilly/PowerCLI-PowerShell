# Script que realiza la clonación exacta, sin modificaciones de una máquina virtual a partir de datos cargados en un archivo plano.
# Ejemplo: .\c_clon_exacto_!archivo.ps1 c:\archivo.csv 1 1
# Autor: William Téllez (CSTS-Windows)
# Fecha última modificación: 24/02/2014
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



if ($tipo -eq "clon_igual") 
{
	write-host "Se validó que el archivo es para clonar un servidor."
}
else
{	
	write-host "ERROR: El archivo no corresponde para hacer un clon, por favor revisa el archivo e informa al cliente."
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
write-host
write-host "Desea mover el archivo $csv a la carpeta de ejecutados para respaldo?."
write-host
$resp = read-host "Pulse <S> ó <s> para moverlo de carpeta u otra letra para no moverlo"
if ($resp -eq "s" -or $resp -eq "S")
{
	Move-Item y:\des\creacion\$csv y:\des\creacion\ejecutados\$csv	
	$msg = "Se procedió a mover el archivo de configuración $csv para tenerlo como respaldo a la ruta y:\des\creacion\ejecutados\"
	clear-host
	write-host "Se procedió a mover el archivo de configuración $csv para tenerlo como respaldo a la ruta y:\des\creacion\ejecutados\"
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}
}

# Toma el sistema operativo.
$so1 = get-vm -Name $hostname_destino | get-view
$dato_so = $so1.Summary.Config.GuestFullName

# Toma la ram y cpu
$vm = get-vm -name $hostname_destino
$ramgb = $vm.MemoryMB/1024
$vcpu = $vm.NumCpu

# Toma los datos de la red.
[int]$vnic = $vm.NetworkAdapters.count
$nics = $vm.NetworkAdapters
[int]$n = 0
$echovlans = ""
foreach($nic in $nics)
{
	[int]$n++
	If ([int]$n -gt 1)
		{$echovlans = $echovlans + ", "}
	$vlan = $nics.NetworkName
	$echovlans = $echovlans + "vLan$n=$vlan"
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

$datos = "vSo=$dato_so, vCpu=$vcpu, vRam= $ramgb Gb, vNic=$vnic, $echovlans, vDisk0=$disk0, $echodisk"
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