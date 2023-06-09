$salir = 1

do
{
	ping 161.196.27.134 > pingw2k3portalasp02.txt
	$chequeo =  Select-String pingw2k3portalasp02.txt -pattern "agotado" -quiet
	if ($chequeo -eq "False")
	{	
		$date = Get-Date
		Get-VM -name w2k3portalasp02 | Get-NetworkAdapter -Name “Network adapter 1” | Set-NetworkAdapter -Connected:$false -Confirm:$false
		Get-VM -name w2k3portalasp02 | Get-NetworkAdapter -Name “Network adapter 1” | Set-NetworkAdapter -Connected:$true -Confirm:$false
		echo "$date : Se determinó que el servidor no respodía a ping y reinició las tarjeta de red" >> w2k3portalasp02.log
	}
	Start-Sleep -s 150
}
while ($salir -eq 1)