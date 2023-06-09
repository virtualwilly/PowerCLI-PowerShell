$vm = get-vm -name Pexip02
$path = "c:\temp\reporte_annotation.xls"
$xl = new-Object -comobject Excel.Application
$wb=$xl.WorkBooks.Open($path)
$ws=$wb.ActiveSheet
$xl.Visible=$True
$cells=$ws.Cells
$fin = $vm.CustomFields.Keys.Count
write-host $fin
$j = 0

	for($i=0; $i -lt $fin; $i++ )
	{
		write-host "entra al for (i)"
		[String]$validar = $vm.CustomFields.Values[$i]
		if([String]$validar -eq [String]::Empty)
		{
			write-host "entra al if"
			$cells.item($j,2) = "$vm"
			$cells.item($j,3) = $vm.CustomFields.Keys[$i]
			$cells.item($j,4) = "Campo vacio"
			$j++
		}
	}

$wb.Save()
$wb.Close()
$xl.Quit()