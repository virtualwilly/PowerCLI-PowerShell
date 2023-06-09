$salir = 1

do
{
	ping 161.196.189.199 > pingsappasp01.txt
	$chequeo =  Select-String pingsappasp01.txt -pattern "agotado" -quiet
	if ($chequeo -eq "False")
	{	
		$date = Get-Date
		Get-VM -name sappasp01 | Get-NetworkAdapter -Name “Network adapter 1” | Set-NetworkAdapter -Connected:$false -Confirm:$false
		Get-VM -name sappasp01 | Get-NetworkAdapter -Name “Network adapter 1” | Set-NetworkAdapter -Connected:$true -Confirm:$false
		echo "$date : Se determinó que el servidor no respodía a ping y reinició las tarjeta de red" >> sappasp01.log
	}
	 Start-Sleep -s 150
}
while ($salir -eq 1)