$salir = 1

do
{
	ping 161.196.27.134 > pingw2k3portalasp02.txt
	$chequeo =  Select-String pingw2k3portalasp02.txt -pattern "agotado" -quiet
	if ($chequeo -eq "False")
	{	
		$date = Get-Date
		Get-VM -name w2k3portalasp02 | Get-NetworkAdapter -Name �Network adapter 1� | Set-NetworkAdapter -Connected:$false -Confirm:$false
		Get-VM -name w2k3portalasp02 | Get-NetworkAdapter -Name �Network adapter 1� | Set-NetworkAdapter -Connected:$true -Confirm:$false
		echo "$date : Se determin� que el servidor no respod�a a ping y reinici� las tarjeta de red" >> w2k3portalasp02.log
	}
	Start-Sleep -s 150
}
while ($salir -eq 1)