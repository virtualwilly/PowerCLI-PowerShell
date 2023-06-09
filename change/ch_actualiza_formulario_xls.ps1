# Script que actualiza la hoja de excel Formulario_vms.xls
# Ejemplo: ch_actualiza_formulario_xls.ps1
# Autor: William Téllez (CSTS-Windows)
# Fecha última modificación: 30/01/2014

write-host
write-host "Asegurese de tener presente los siguientes puntos:"
write-host
write-host "1. Una conexion de red a la letra v:"
write-host
write-host "2. La carpeta de la conexion debe ser: \\fscantv03\vmware"
write-host
write-host "3. Debe estar conectado al vcenter con usuario con suficientes privilegios, esto se puede hacer con el script: y:\des\adm\connect_!vcenter.ps1 vcenter01" 
write-host
write-host "4. Que el archivo v:\Formulario_vms.xls no este tomado por nadie ya que en forma solo lectura no puede ser modificado."
write-host
write-host "5. Cierre todos los archivos de excel ya que el proceso los cerrara por seguridad, luego puede abrirlos de nuevo."
write-host
write-host "Si NO tiene todos los puntos antes descritos, pulse la letra S para salir."
$listo = Read-host "Si todo está listo pulse cualquier otra tecla:"

$arch = "V:\des\Formulario_vms.xls"
$hoja = "Datos"
$col = 23
$fil = 2


$xl = new-Object -comobject Excel.Application
$wb=$xl.WorkBooks.Open($arch)	
$xl.Visible=$True
$quien = $wb.WriteReservedBy
$datos = $wb.worksheets | where {$_.Name -eq $hoja}

$hoja1 = $wb.worksheets.item(1)
$NameHoja1 = $hoja1.name
$datos.activate()

$vms = get-vm -Location CSTS-Adecuacion

ForEach ($vm in $vms)
{	
	$srv = $vm.Name
	$srv = $srv.ToUpper()
	$datos.Cells.item($fil,$col) = $srv
	$fil++
}

$vms = get-vm -Location CSTS-Unix

ForEach ($vm in $vms)
{
	$srv = $vm.Name
	$srv = $srv.ToUpper()
	#read-host "Se procede a sustituir el servidor $viejo por $srv"
	$datos.Cells.item($fil,$col) = $srv
	$fil++
}

$vms = get-vm -Location CSTS-Windows

ForEach ($vm in $vms)
{
	$srv = $vm.Name
	$srv = $srv.ToUpper()
	#read-host "Se procede a sustituir el servidor $viejo por $srv"
	$datos.Cells.item($fil,$col) = $srv
	$fil++
}

$datos.Cells.item(2,256) = $fil - 1

$datos = $wb.worksheets | where {$_.Name -eq $NameHoja1}
$datos.activate()		

$resp = read-host "Se va a cerrar la hoja y todos los procesos de Excel."
$wb.Save()
$wb.Close()
$xl.Quit()
stop-process -name EXCEL

