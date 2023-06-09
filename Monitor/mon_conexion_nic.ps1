param ($srv,$ip)

# *********** Definición de variables ********************
$vCenter = "vcenter01"

add-PSSnapin VMware.VimAutomation.Core  
Connect-VIServer -Server $vCenter -User admwtellez -Password Alejandr0

ping $ip > d:\admsrv\automatico\ping.txt
$chequeo =  Select-String d:\admsrv\automatico\ping.txt -pattern "agotado" -quiet
if ($chequeo -eq "False")
{	
	Get-VM -name $srv | Get-NetworkAdapter -Name “Network adapter 1” | Set-NetworkAdapter -Connected:$false -Confirm:$false
	Get-VM -name $srv | Get-NetworkAdapter -Name “Network adapter 1” | Set-NetworkAdapter -Connected:$true -Confirm:$false
	echo "Se determinó que el servidor no respodía a ping y reinició las tarjeta de red" >> d:\admsrv\automatico\resultado.txt
}
else
{
	echo "El servidor responde a ping" >> d:\admsrv\automatico\resultado.txt
}