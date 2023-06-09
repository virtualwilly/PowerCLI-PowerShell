# Script que determina las ip que responden y las que no y general un listado para luego ser utilizado.
# Ejemplo: q_vms_ping.ps1

param($vm)

. "y:\funciones.ps1" 

$Logfile = "Y:\des\Query\Logs\Reporte.txt"

If (Test-Path Logs_ping.txt)
{
	Remove-Item Logs_ping.txt
}

If (Test-Path Reporte.txt)
{
	Remove-Item Reporte.txt
}

New-Item Logs_ping.txt -type file
New-Item Y:\des\Query\Logs\Reporte.txt -type file
clear-host

write-host "Reporte por pantalla de las conexiones, mas informacion ver archivo Reporte.txt"
write-host

if($vm -eq "all")
	{$vms = Get-VM}
else
	{$vms = Get-VM -name $vm}

[int]$totsrv1 = $vms.Count + 1
write-host "Cantidad total de servidores a analizar: $totsrv1"
[int]$totsrv2 = 0
[int]$totnics = 0
[int]$vms_ons = 0
[int]$vms_offs = 0
[int]$problems = 0
[int]$fino = 0

foreach ($vm in $vms)
{	
	[int]$totsrv2 ++
	$vmIPs = $vm.Guest.IPAddress
	[String]$validaIP = $vm.Guest.IPAddress
	write-host "Resultado query ip: $vmIPs"
	$nics = Get-NetworkAdapter -vm $vm	
	[int]$cuantasnics = $nics.Count
	$q_vm_on = $vm.PowerState
	[int]$i = 0	
	
	if ($q_vm_on -eq "PoweredOn")
	{
		write-host "servidor $vm reportado como encendido"
		[int]$vms_ons ++
		if ([String]$validaIP -eq [String]::Empty)
		{
			$problems ++
			write-host "El query hacia las ip resulta fallido"
		}
		else
		{
			$fino ++
			write-host "El query hacia las ip resulta exitoso."			
		}
		
		foreach ($ip in $vmIPs)
		{
			# valida el tipo de ip que tiene el servidor
			$ip4 = $ip.Contains(".")
			$ip6 = $ip.Contains(":")		

			If ($ip4)
			{
				write-host "Servidor $vm reporta ip version 4"
				ping $ip >> Logs_ping.txt 
				ping $ip > ping.txt 

				$find = Select-String "Respuesta" ping.txt
				[int]$chk = $find.Count

				If ([int]$chk -gt 0)
				{
					write-host "Servidor $vm reporta respuesta a ping"
					$status_ping = "OK"
					if ([int]$cuantasnics -eq 0)
						{$nic = $nics.ConnectionState.Connected}
					else
						{$nic = $nics[$i].ConnectionState.Connected}
					write-host "el valor del estatus de la nic es $nic"
					[int]$totnics ++
					If($nic)
					{
						$status_nic = "conectado"
					}
					else
					{
						$status_nic = "DES-conectado"
					}
					
					write-host "El servidor $vm responde a ping hacia la ip $ip"
					write-host
					$esx = $vm.VMHost.Name
					$esx = $esx.subString(1,8)
					$esx = $esx.TrimStart("esxicnt")
					$msg = "$vm,$ip,$status_ping,$status_nic,esx$esx"
					$r = writelog $Logfile $msg
				}
				else
				{
					write-host "Servidor $vm reporta falta de respuesta a ping"
					$status_ping = "FALLA"
					if ([int]$cuantasnics -eq 0)
						{$nic = $nics.ConnectionState.Connected}
					else
						{$nic = $nics[$i].ConnectionState.Connected}
					write-host "el valor del estatus de la nic es $nic"
					[int]$totnics ++
					If($nic)
					{
						$status_nic = "conectado"
					}
					else
					{
						$status_nic = "DES-conectado"
					}
					write-host "El servidor $vm NO responde a ping hacia la ip $ip"
					write-host
					$esx = $vm.VMHost.Name
					$esx = $esx.subString(1,8)
					$esx = $esx.TrimStart("esxicnt")
					$msg = "$vm,$ip,$status_ping,$status_nic,esx$esx"
					$r = writelog $Logfile $msg
				}
				[int]$i++
			}	
			else
			{
				write-host "Servidor $vm reporta ip version 6"
			}
		}
	}
	else
	{
		[int]$vms_offs ++
		write-host "Servidor $vm Reportado como apagado."
	}
}

$msg = "-------------------------------------"
$r = writelog $Logfile $msg
$msg = "Totales del análisis de conectividad."
$r = writelog $Logfile $msg
$msg = "-------------------------------------"
$r = writelog $Logfile $msg
$msg = "Total servidores inventariados al comienzo: $totsrv1"
$r = writelog $Logfile $msg
$msg = "Total servidores analizados: $totsrv2"
$r = writelog $Logfile $msg
$msg = "Total servidores analizados encendidos: $vms_ons"
$r = writelog $Logfile $msg
$msg = "Total servidores analizados apagados: $vms_offs"
$r = writelog $Logfile $msg
$msg = "Total nics analizadas: $totnics"
$r = writelog $Logfile $msg
$msg = "Total de querys a las ip exitosas: $fino"
$r = writelog $Logfile $msg
$msg = "Total de querys a las ip fallidas: $problems"
$r = writelog $Logfile $msg

