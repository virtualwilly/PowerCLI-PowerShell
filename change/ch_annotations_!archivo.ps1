param($csv)

############################ Definición de funciones.
. "y:\funciones.ps1" 

######################### Cuerpo del script.

$arch = import-csv $csv
$servidor = $arch[0].Valor
$servicio = $arch[1].Valor
$Remedy = $arch[2].Valor
$Tecnico = $arch[3].Valor
$email = $arch[4].Valor
$ambiente = $arch[5].Valor
$funcion = $arch[6].Valor
$Contenedor = $arch[7].Valor
$Supervisor = $arch[8].Valor
$funcionales = $arch[9].Valor

# Consulta de las anotaciones para no sobreescribirla en caso de que estén vacias.
$vm = get-vm -name $servidor
clear-host
write-host "Valores ya existentes."
write-host 
$servicio_i	= $vm | Get-Annotation -CustomAttribute Servicio
write-host $servicio_i
$remedy_i	= $vm | Get-Annotation -CustomAttribute Remedy
write-host $remedy_i
$tecnico_i	= $vm | Get-Annotation -CustomAttribute Responsable
write-host $tecnico_i
$email_i	= $vm | Get-Annotation -CustomAttribute emailTecnico
write-host $email_i
$ambiente_i	= $vm | Get-Annotation -CustomAttribute Ambiente
write-host $ambiente_i
$funcion_i	= $vm | Get-Annotation -CustomAttribute Funcion
write-host $funcion_i
$Contenedor_i	= $vm | Get-Annotation -CustomAttribute Repositorio
write-host $Contenedor_i
$Supervisor_i	= $vm | Get-Annotation -CustomAttribute emailSupervisor
write-host $Supervisor_i
$funcionales_i	= $vm | Get-Annotation -CustomAttribute Funcionales
write-host $funcionales_i
write-host
write-host "Se procede a ejecutar las actualizaciones."
write-host

#Agrega las anotaciones 
if ($servicio.value.Length -eq 0)
	{
	Get-VM -Name $servidor | Set-CustomField -Name "Servicio" -Value $servicio -Confirm:$false
	write-host "se cambio el valor de $servicio_i a $servicio"
	}

if ($remedy.value.Length -eq 0)
	{
	Get-VM -Name $servidor | Set-CustomField -Name "Remedy" -Value $Remedy -Confirm:$false
	write-host "se cambio el valor de $Remedy_i a $Remedy"
	}

Get-VM -Name $servidor | Set-CustomField -Name "Responsable" -Value $Tecnico -Confirm:$false
write-host "se cambio el valor de $Responsable_i a $Responsable"

Get-VM -Name $servidor | Set-CustomField -Name "emailTecnico" -Value $email -Confirm:$false
write-host "se cambio el valor de $email_i a $email"

Get-VM -Name $servidor | Set-CustomField -Name "Ambiente" -Value $ambiente -Confirm:$false
Get-VM -Name $servidor | Set-CustomField -Name "Funcion" -Value $funcion -Confirm:$false
Get-VM -Name $servidor | Set-CustomField -Name "Repositorio" -Value $Contenedor -Confirm:$false
Get-VM -Name $servidor | Set-CustomField -Name "emailSupervisor" -Value $Supervisor -Confirm:$false
	
if ($funcionales.value.Length -eq 0)
	{Get-VM -Name $servidor | Set-CustomField -Name "Funcionales" -Value $funcionales -Confirm:$false}
	
# Mueve el archivo para liberar el directorio a un histórico llamado ejecutados.
write-host
write-host "Desea mover el archivo $csv a la carpeta de ejecutados para respaldo?."
write-host
$resp = read-host "Pulse <S> ó <s> para moverlo de carpeta u otra letra para no moverlo"
if ($resp -eq "s" -or $resp -eq "S")
{
	Move-Item y:\des\change\$csv y:\des\change\ejecutados\$csv	
	$msg = "Se procedió a mover el archivo de configuración $csv para tenerlo como respaldo a la ruta y:\des\change\ejecutados\"
	clear-host
	write-host "Se procedió a mover el archivo de configuración $csv para tenerlo como respaldo a la ruta y:\des\change\ejecutados\"
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
	if ($log)			# Escribe al log.
	{writelog $Logfile $msg}
}

