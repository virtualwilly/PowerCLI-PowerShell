# Script que hacer una consulta sobre el estado que tiene una vm (apagado o encendido)
# ejemplo: .\q_Estado_!vm.ps1 Train
# Autor: William T�llez
# Fecha: Octubre 2012

param($vm)
$qvm = get-vmguest -vm $vm
if ($qvm.state -eq "Running")
    {
	write-host
	write-host
	write-host "El servidor $vm est� ENCENDIDO"
	write-host
	write-host
    } 
else
	{
	write-host
	write-host
	write-host "El servidor $vm est� APAGADO"
	write-host
	write-host
	}

