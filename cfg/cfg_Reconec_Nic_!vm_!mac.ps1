param($esx)
# Get-VM $vm | Get-NetworkAdapter | where {$_.macaddress -eq $mac} | Set-NetworkAdapter -NetworkName $vlan -Connected:$false -Confirm:$false
# Get-VM $vm | Get-NetworkAdapter | where {$_.macaddress -eq $mac} | Set-NetworkAdapter -Connected:$true -Confirm:$false

$vms = Get-VM | where{$_.host -like $esx} | Get-NetworkAdapter | select @{N="VM";E={$_.parent.name}},name,NetworkName,MacAddress

foreach ($vm in $vms)
{
	$vlan = $vm.networkname
	if($vlan -ceq "Vlan 1")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN1" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan1")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN1" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "vlan1")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN1" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "vlan 1")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN1" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 2")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN2" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "VLAN4")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN4" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 6")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN6" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "vlan 6")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN6" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 7")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN7" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "vlan 7")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN7" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 8")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN8" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "vlan 8")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN8" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 11")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN11" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 12")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN12" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 13")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN13" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 21")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN21" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "vlan 21")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN21" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan21")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN21" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 64")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN64" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "vlan 64")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN64" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 25")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN25" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 65")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN65" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 72")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN72" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 79")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN79" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "vlan 79")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN79" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 82")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN82" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 91")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN91" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "vlan 91")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN91" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 200")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN200" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
	if($vlan -ceq "Vlan 211")
	{
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -NetworkName "VLAN211" -Connected:$false -Confirm:$false
		Get-NetworkAdapter -VM $vm.vm | where {$_.macaddress -eq $vm.MacAddress} | Set-NetworkAdapter -Connected:$true -Confirm:$false
	}
}
