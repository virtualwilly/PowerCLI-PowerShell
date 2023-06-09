$vm = Read-host "Introduzca el nombre de la maquina virtual"
$mqs = Get-VM $vm
$annos = Get-CustomAttribute -TargetType "VirtualMachine"
foreach($anno in $annos)
{
	$valor = Read-Host "Introduzca el valor del siguiente annotation"$anno.name
	if(!$valor)
	{
	
	}
	else
	{
		Get-VM -Name $vm | Set-CustomField -Name $anno.name -Value $valor -Confirm:$false
	}
}