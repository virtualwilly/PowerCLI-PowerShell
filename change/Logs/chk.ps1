$ruta = "Y:\des\change\Logs\Fallidos_ch_vmotion_!filevms_!esxi.log"
$vms = Get-Content $ruta
$totvms = $vms.count

clear-host
for($i = 0; $i -lt $totvms; $i++)
{
	$vm = $vms[$i]
	$obj_vm = Get-vm -name $vm
	$esxi = $obj_vm.Host.Name
	write-host "El servidor $vm se encuentra en el esxi $esxi"
}