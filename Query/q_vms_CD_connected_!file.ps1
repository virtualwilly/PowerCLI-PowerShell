# Script que realiza la busqueda de todas las maquinas que tengan establecida una conexi�n contra su unidad de CD
# generando una salida separado por comas que nos informa: (1) nombre de la vm, (2) si tiene conectado un archivo a la unidad y 
# (3) si tiene conectado el cd del host esxi. Si el valor es "OK" todo est� bien, si tiene el valor "conectado" hay que
# informar a los administradores para que revisen ya que esta condici�n impide la migraci�n entre esxi.
# El script recibe como par�metro una ruta m�s el archivo a donde exportar� el resultado, ejemplo:
# query_cd.ps1 c:\cd.txt

param($file)

Add-content	$file -value "vm,IsoPath,HostDevice"
$vms = get-vm
foreach ($vm in $vms)
	{
		$cd = Get-CDDrive -VM $vm
		$iso = $cd.IsoPath		
		$num_iso = $iso -as[int]
		#read-host "el valor numerico de isopath es $num_iso"
		if ($num_iso -eq 0)
			{$status_iso = "OK"}
		else
			{$status_iso = "Conectado"}
		
		$chost = $cd.HostDevice
		$num_host = $chost -as[int]
		#read-host "el valor numerico de hostdevice es $num_host"
		if ($num_host -eq 0)
			{$status_host = "OK"}
		else
			{$status_host = "Conectado"}					
			
		Add-content	$file -value "$vm,$status_iso,$status_host"
	}