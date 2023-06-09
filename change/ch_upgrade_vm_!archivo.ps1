# Script que hace upgrade de cpu, ram, disco y nic a un servidor virtual según datos recibidos como parámetro.
# Ejemplo: ch_upgrade_vm_!archivo.ps1
# Autor: William Téllez (CSTS-Windows)
# Fecha última modificación: 16/05/2014
param($csv)

#1. $Salida = Se detiene en lugares claves para revisar la salida y poder detectar errores.
# Valor = 1, se detiene
# Valor = 0, no se detiene.
# $Salida = 0
# $Logfile = "Y:\des\creacion\logs\c_clon_!archivo.log"

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
write-host "3. Que el archivo de respuesta que introducirá como parametro al script de creación este en y:\des\change"
write-host
write-host "Si NO tiene todos los puntos antes descritos, pulse la letra <S> o <s> para salir."
write-host
$listo = Read-host "Si todo esta listo pulse cualquier otra tecla"

if ($listo -eq "S" -or $listo -eq "s")
	{Exit}
	
$msg = "-------------------- Inicio del proceso de upgrade automático -----------"
# salida por pantalla.
if ($echo)
	{$r = echo_ 1 $msg}
# Escribe al log.
if ($log)
	{$r = writelog $Logfile $msg}	
	
$arch = import-csv $csv
$hostname = $arch[0].Columna2
[int]$vcpu = $arch[1].Columna2
[int]$vram = $arch[2].Columna2
[int]$nDisk = $arch[3].Columna2
[int]$vdisk = $arch[4].Columna2
[int]$vnic = $arch[5].Columna2
$remedyCeros = $arch[6].Columna2 
[int]$remedy = EliminaCerosIzq $remedyCeros
$emailtecn = $arch[7].Columna2
$tipo = $arch[8].Columna2

$notes = get-vm $hostname | select-object Notes

if ($tipo -eq "upgrade") 
{
	write-host
	write-host "Se valida que el archivo es para upgrade del servidor ."
	write-host
}
else
{
	write-host "ERROR: El archivo no corresponde para hacer upgrade, por favor revisa el archivo e informa al cliente."
	write-host
	read-host "Valor del tipo tomado por el script: $tipo"
	cd y:\	
	Exit
}

# Query del estado de la opción cpu hot
$q1_vm = Get-VM -name $hostname | Get-View | Select Name, @{N="CpuHotAddEnabled";E={$_.Config.CpuHotAddEnabled}}
$qCpuHot = $q1_vm.CpuHotAddEnabled

# Query del estado de la opción memory hot
$q2_vm = Get-VM -name $hostname | Get-View | Select Name, @{N="MemoryHotAddEnabled";E={$_.MemoryHotAddEnabled}}
$qMemHot = $q2.vm.MemoryHotAddEnabled

# Query para ver si el servidor está prendido o apagado.
$q3_vm = get-vmguest -vm $hostname

if ($q3_vm.state -eq "Running")
	{	
	write-host
	$resp = read-host "Se determino que el servidor $hostname se encuentra encendido, desea que intentemos hacer el upgrade en caliente? (S/N)"
	write-host 
	}
else
	{
	Enable-vCpuHotAdd $hostname
	Enable-MemHotAdd $hostname
	}

$msg = "Se leyó del archivo $csv recibido por parámetro y se tomaron sus valores para hacer upgrade al servidor virtual."
if ($echo) 		# salida por pantalla.
	{echo_ 1 $msg}
if ($log)	# Escribe al log.
	{writelog $Logfile $msg}	

$msg = "-------------------------------------------- SALIDA POR CONSOLA"
if ($echo)			# salida por pantalla.
	{echo_ 1 $msg}
$msg = "Búsqueda y selección del data store con mayor espacio libre, mayor información Y:\des\Query\Logs\q_FindDataStoreInCluster.log."
if ($echo)			# salida por pantalla.
	{echo_ 1 $msg}

#Modifica la momeria y cpus de la vm
if ([int]$vcpu -ne 0)
{
	Get-VM -Name $hostname | Set-VM -NumCPU $vcpu -Confirm:$false
	$notas_v = get-vm $hostname | select-object Notes
	$notas = $notas_v.Notes + "`nSe realiza upgrade bajo el numero de caso $remedy de vCpu a $vcpu"
	Set-VM -VM $hostname -Description $notas -Confirm:$false
	$msg = "Se procedió a ajustar tanto  vCpu a $vcpu"
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}
}

if ([int]$vram -ne 0)
{
	$gbs = [int]$vram*1024
	Get-VM -Name $hostname | Set-VM -MemoryMB $gbs -Confirm:$false
	$notas_v = get-vm $hostname | select-object Notes	
	$notas = $notas_v.Notes + "`nSe realiza upgrade bajo el numero de caso $remedy de vRam a $vram Gb"	
	Set-VM -VM $hostname -Description $notas -Confirm:$false
	$msg = "Se procedió a ajustar tanto la vRam a $vram"
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}		
}

if ([int]$nDisk -ne 0 -and $vDisk -ne 0)
{
	$disco = "Hard disk " + $nDisk
	$gb = [int]$vDisk*1024*1024	
	Get-HardDisk -vm $hostname | where {$_.Name -eq $disco} | Set-HardDisk -CapacityKB $gb -Confirm:$false	
	$notas_v = get-vm $hostname | select-object Notes
	$notas = $notas_v.Notes + "`nSe realiza upgrade bajo el numero de caso $remedy de vDisk a $gb Gb"
	Set-VM -VM $hostname -Description $notas -Confirm:$false
	$msg = "Se procedió a ajustar el vDisk"
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}		
}

if ([int]$vnic -ne 0)
{
	Get-VM $hostname |  New-NetworkAdapter -NetworkName "SinRed" -WakeOnLan -StartConnected 
	$notas_v = get-vm $hostname | select-object Notes
	$notas = $notas_v.Notes + "`nSe realiza upgrade bajo el numero de caso $remedy de una vNic adicional"	
	Set-VM -VM $hostname -Description $notas -Confirm:$false
	$msg = "Se procedió a crear una nueva vNic"
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}		
}

cd y:\