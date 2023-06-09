# vmotion controlado hacia una esxi en particular
param($ruta,$esxi,$num)

. "y:\funciones.ps1" 

$Logfile = "Y:\des\change\Logs\ch_vmotion_!filevms_!esxi.log"
$indice = 0

$vms = Get-Content $ruta
$totvms = $vms.count

$msg1 = "INFO: ------------ Se da inicio al proceso de migracion automatico al servidor $esxi. -------------"
$r = writelog $Logfile $msg1
$msg = "-------------------------------------------------------------------------------------------------------"
$r = writelog $Logfile $msg

clear-host
for($i = 0; $i -lt $totvms; $i++)
{	
	$indice = $indice + 1	
	$vm = $vms[$i]
	$msg2 = "INFO: Se prepara para migrar el servidor $vm"
	$r = writelog $Logfile $msg2
	# Toma información del servidor.
	$vmmigrar = get-vm -name $vm
	# Verifica el esxi actual.
	$esxi_actual = $vmmigrar.Host.Name
	
	$msg3 = "INFO: Levantamos la información y el servidor $vm se encuentra en el esxi $esxi_actual"
	$r = writelog $Logfile $msg3
	
	$msg4 = "INFO: Se procederá a realizar el movimiento del servidor $vm"
	$r = writelog $Logfile $msg4

	# vmotion controlado
	Get-vm -name $vm | move-vm -Destination "$esxi.cantv.com.ve"
	
	# Toma información del servidor.
	$vmmigrar = get-vm -name $vm	
	# Verifica el esxi actual.
	$esxi_nuevo = $vmmigrar.Host.Name
	
	if($esxi_nuevo -eq "$esxi.cantv.com.ve")
	{
		$msg5 = "INFO: El servidor $vm fue migrado satisfactoriamente al ESXi $esxi"
		$r = writelog $Logfile $msg5	
	}
	else
	{
		$msg6 = "ERROR: El servidor $vm no fue migrado satisfactoriamente al ESXi $esxi, REVISAR POR FAVOR."
		$r = writelog $Logfile $msg6
	}	
	$msg = "-------------------------------------------------------------------------------------------------------"
	$r = writelog $Logfile $msg
	If ($indice -eq $num)
	{
		$indice = 0
		$respuesta = read-host "El script pauso para que revise el rendimiento del servidor $esxi segun instrucciones recibida por parametro"
	}
}
$msg100 = "INFO: ----------- Se finaliza el proceso de migracion automatico al servidor $esxi. -------------"
$r = writelog $Logfile $msg100