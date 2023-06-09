$vms = get-vm -name ACSCE
$path = "c:\temp\reporte_annotation.xls"
$xl = new-Object -comobject Excel.Application
$wb=$xl.WorkBooks.Open($path)
$ws=$wb.ActiveSheet
$xl.Visible=$True
$cells=$ws.Cells
$j = 0

foreach($vm in $vms)
{
	for($i=0; $i -lt $vm.CustomFields.Keys.Count; $i++ )
	{
		if(!$vm.CustomFields.Values[$i])
		{
			$cells.item($j,2) = "$vm"
			$cells.item($j,3) = $vm.CustomFields.Keys[$i]
			# write-host "El servidor virtual:" $vm "le falta completar el annotation's:" $vm.CustomFields.Keys[$i]
			# La Maquina virtual $vm carece del valor: vm.CustomFields.Keys[$i]
			$j++
		}
	}
}

$wb.Save()
$wb.Close()
$xl.Quit()