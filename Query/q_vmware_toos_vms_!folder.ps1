# valores posibles del status de los vmware tools
# 1. toolsOk
# 2. toolsOld
# 3. toolsNotInstalled
# 4. toolsNotRunning

param($folder)

# Iniciación de variables.
$tok = 0
$told = 0
$tni = 0 
$tnr = 0
$tnc = 0
$fil = 2

clear-host

# Manejo de excel.
$file = "c:\temp\reporte_vtools.xls"

If (Test-Path $file)
	{Remove-Item $file}

$xl = New-Object -ComObject "Excel.Application"
$xl.visible = $true
$wb =$xl.workbooks.Add()
$wb.SaveAs("$file")
$ws=$wb.ActiveSheet
$ws.Name = $folder
$S2 = $wb.sheets | where {$_.name -eq "Hoja2"} 
$S3 = $wb.sheets | where {$_.name -eq "Hoja3"} 
$s2.delete() 
$s3.delete() 


# Configura las columnas para registrar datos.
$cells=$ws.Cells
$cells.item(1,1) = "Nombre del Servidor"
$cells.item(1,1).Font.Bold=$True
$cells.item(1,2) = "Status vmware tools"
$cells.item(1,2).Font.Bold=$True
$ws.Range("A1:B1").EntireColumn.AutoFit()


$vms = Get-vm -Location $folder

$readdatos = Import-Csv y:\supervisores.txt | Where-Object {$_.Folder -eq $folder}
$emailsup = $readdatos.Correo
$Nombre = $readdatos.Nombre

foreach ($vm in $vms)
{	
	$read_status = Get-VM -name $vm | Get-View | Select-Object @{Name="Status_vmware_tools";E={$_.Guest.ToolsStatus}}
	$status = $read_status.Status_vmware_tools
	
	$ann = get-vm -name $vm | Get-Annotation
	$esup = $ann[6].Value
	
	if($esup -ne $emailsup)
	{
		Get-VM -Name $vm | Set-CustomField -Name "emailSupervisor" -Value $emailsup -Confirm:$false
	}	
	switch ($status) 
    { 
        toolsOk 
		{
			"toolsOk"		
			$tok++
		} 
        
		toolsOld 
		{						
			$cells.item($fil,1) = $vm.Name
			$cells.item($fil,2) = "Vmware tools necesita actualizacion"
			$fil++	
			$told++				
		} 
        
		toolsNotInstalled 
		{
			$cells.item($fil,1) = $vm.Name
			$cells.item($fil,2) = "Vmware tools NO Instalados"
			$fil++
			$tni++
		} 
        
		toolsNotRunning 
		{
			$cells.item($fil,1) = $vm.Name
			$cells.item($fil,2) = "Vmware tools NO estan corriendo"
			$fil++
			$tnr++
		} 
        
		default 
		{
			$cells.item($fil,1) = $vm.Name
			$cells.item($fil,2) = "Vmware tools estatus desconocidos"
			$fil++
			$tnc++
		}
    }	
}
# Estadísticas
$cells.item($fil+1,1) = "Estadisticas"
$cells.item($fil+1,1).Font.Bold=$True
$cells.item($fil+2,2) = "Total Servidores con vmware tools instaldos:"
$cells.item($fil+2,3) = "$tok"
$cells.item($fil+3,2) = "Total Servidores con vmware tools Desactualizados:"
$cells.item($fil+3,3) = "$told"
$cells.item($fil+4,2) = "Total Servidores con vmware tools No Instalados:"
$cells.item($fil+4,3) = "$tni"
$cells.item($fil+5,2) = "Total Servidores con vmware tools No corriendo:"
$cells.item($fil+5,3) = "$tnr"
$cells.item($fil+6,2) = "Total Servidores con vmware tools con estatus desconocidos:"
$cells.item($fil+6,3) = "$tnc"

# Cierre libro de excel
$ws.Range("A1:C1").EntireColumn.AutoFit()
$wb.Save()
$wb.Close()
$xl.Quit()
stop-process -name EXCEL
clear-host

