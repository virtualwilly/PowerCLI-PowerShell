param($esxi)

$vms = Get-VMHost -name "$esxi.cantv.com.ve" | get-vm
foreach ($vm in $vms)
{
	$nsrv = $vm	
	$srv = Get-vm -name $nsrv | %{@{$_.Name=$_.DatastoreIDList | %{(Get-view -Property Name -id $_).Name}}}
	$srv >> c:\esxicnt03.txt
}

