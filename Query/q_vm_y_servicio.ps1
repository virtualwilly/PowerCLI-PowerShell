$vms = Get-vm


$xl = New-Object -ComObject "Excel.Application"
$wb=$xl.Workbooks.Add()
$ws=$wb.ActiveSheet
$xl.visible = $true
$cells=$ws.Cells
$cells.item(1,1) = "Servidor"
$cells.item(1,2) = "Servicio"

$fil = 2

foreach ($vm in $vms)
{
$name = $vm.name
$ann = $vm | Get-Annotation
$servicio = $ann[5].Value
$ambiente = $ann[0].Value
$cells.item($fil,1) = $name
$cells.item($fil,2) = $servicio
$fil++
}


$wb.SaveAs("c:\Listado_vms.xls")
$wb.Close()
$xl.Quit()



