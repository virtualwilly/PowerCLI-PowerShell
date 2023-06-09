# Script que actualiza la hoja de excel de aprovisionamiento de vm´s.
# Ejemplo: 
# Autor: William Téllez (CSTS-Windows)
# Fecha última modificación: 30/01/2014
param ($csv)

write-host
write-host "Asegurese de tener presente los siguientes puntos:"
write-host
write-host "1. Cierre todas las hojas de excel ya que el sistema por precaucion lo hará"
write-host
write-host "2. Una conexion de red a la letra y:"
write-host
write-host "3. La carpeta de la conexión debe ser: \\fscantv03\hostingwidows\Documentacion_Plataformas\Equipo02\VMWare\Operaciones\PowerCLI"
write-host
write-host "4. Debe estar conectado al vcenter con usuario con suficientes privilegios, esto se puede hacer con el script: y:\des\adm\connect_!vcenter.ps1 vcenter01" 
write-host
write-host "5. Que el archivo de respuesta que introducira como parametro al script este en y:\des\change"
write-host
write-host "Si NO tiene todos los puntos antes descritos, pulse la letra S para salir."
$listo = Read-host "Si todo esta listo pulse cualquier otra tecla"

stop-process -name EXCEL

clear-host
if ($listo -eq "S" -or $listo -eq "s")
	{Exit}

############################ Definición de funciones.
. "y:\funciones.ps1" 

$vm_txt = import-csv $csv
$j = 0
$ver = $vm_txt[13].Columna1

If ($ver -eq "tipo")
	{$j = 2}
else
	{$j = 1}
	
$hostname = $vm_txt[0].Columna2 
$hostname = $hostname.ToUpper()
$responsable = $vm_txt[$j].Columna2
$j++
$vcpu = $vm_txt[$j].Columna2
$j++
$arq = $vm_txt[$j].Columna2
$j++
$vram = $vm_txt[$j].Columna2
$j++
$ambiente = $vm_txt[$j].Columna2
$j++
$folder = $vm_txt[$j].Columna2
$j++
$servicio = $vm_txt[$j].Columna2
$j++
$emalsuper = $vm_txt[$j].Columna2
$j++
$emailtecn = $vm_txt[$j].Columna2
$j++
$funcion = $vm_txt[$j].Columna2
$j++
$rpool = $vm_txt[$j].Columna2
$j++
$remedyCeros = $vm_txt[$j].Columna2 
$j++
$remedy = EliminaCerosIzq $remedyCeros
$j++
$tipo = $vm_txt[$j].Columna2

$arch = "Y:\des\change\Aprovisionamiento_vms.xls"
$hoja = "Real"
$Col = 1
$fil = 1
$date = Get-Date
$ubicacion = "vDataCenterEQII"

$xl = new-Object -comobject Excel.Application
$wb=$xl.WorkBooks.Open($arch)	
$xl.Visible=$True
$quien = $wb.WriteReservedBy
$datos = $wb.worksheets | where {$_.Name -eq $hoja}

$hoja1 = $wb.worksheets.item(1)
$NameHoja1 = $hoja1.name
$datos.activate()

$chk = $datos.Cells.item($fil,$Col).text

while ($chk -ne "")
{		
	$fil++		
	$chk = $datos.Cells.item($fil,$Col).text		
}

$datos.Cells.item($fil,$Col) = $hostname
[int]$vram = $vram
$datos.Cells.item($fil,$Col + 1) = [int]$vram
$datos.Cells.item($fil,$Col + 2) = [int]$vcpu

$vm = get-vm -name $hostname
$vmDisks = $vm | get-harddisk
$DiskNoSO = 0
$i = 1
foreach ($vmDisk in $vmDisks)
{
	$DiskSO = $vmDisk.CapacityKB/1024/1024
	If ($i -eq 1)
	{	
		$datos.Cells.item($fil,$Col + 3) = $DiskSO

	}	
	If ($i -gt 1)
	{
		$DiskNoSO = $vmDisk.CapacityKB/1024/1024
		$DiskNoSO = $CapacityGB + $DiskNoSO
	}
	$i++
}

$datos.Cells.item($fil,$Col + 4) = $DiskNoSO
$datos.Cells.item($fil,$Col + 5) = $remedy
$datos.Cells.item($fil,$Col + 6) = $date
$datos.Cells.item($fil,$Col + 7) = $ubicacion

$area = read-host "Area originadora (1) CCYDP, (2) Adecuacion, (3) Unix, (4) Windows."
switch ($area)
{
	1 {$datos.Cells.item($fil,$Col + 8) = "CCYDP"}
	2 {$datos.Cells.item($fil,$Col + 8) = "csts-adecuacón"}
	3 {$datos.Cells.item($fil,$Col + 8) = "csts-windows"}
	4 {$datos.Cells.item($fil,$Col + 8) = "csts-unix"}
}

$datos = $wb.worksheets | where {$_.Name -eq $NameHoja1}
$datos.activate()		

$wb.Save()
$wb.Close()
$xl.Quit()
stop-process -name EXCEL

clear-host

# Mueve el archivo para liberar el directorio a un histórico llamado ejecutados.
write-host "Desea mover el archivo $csv a la carpeta de ejecutados para respaldo?."
$resp = read-host "Pulse <S> o <s> para moverlo de carpeta u otra letra para no moverlo"
if ($resp -eq "s" -or $resp -eq "S")
{
	Move-Item Y:\des\change\$csv Y:\des\change\ejecutados\$csv
	$msg = "Se procedio a mover el archivo de configuración $csv para tenerlo como respaldo a la ruta y:\des\creacion\ejecutados\"
	if ($echo)			# salida por pantalla.
		{echo_ 1 $msg}
}
