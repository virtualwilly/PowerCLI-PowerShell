# vmotion controlado
param($vm_r,$esxi_destino)

. "y:\funciones.ps1" 

# Inicialización de variables
$rip = "s"
$rip1 = "s"
$recomendacion = ""
$Logfile = "Y:\des\change\Logs\ch_vmotion_!vm_!esxi.log"

clear-host
write-host "Confirma que desea mover el servidor $vm_r al ESXi $esxi_destino"
write-host
$resp = read-host "Desea mover de manera controlada el servidor $vm_r hacia la ESXi $esxi_destino? (S/s)"

$msg11 = "INFO: --------------------------------- Se aprobó vmotion del servidor $vm_r hacia el esxi $esxi_destino."
$r = writelog $Logfile $msg11

if ($resp -eq "s" -or $resp -eq "S")
{
	clear-host
	$vm = get-vm -name $vm_r

	[int]$totsrv2 = 0
	[int]$totnics = 0
	[int]$vms_ons = 0
	[int]$vms_offs = 0
	[int]$problems = 0
	[int]$fino = 0


	[int]$totsrv2 = [int]$totsrv2 + 1
	$vmIPs = $vm.Guest.IPAddress
	[String]$validaIP = $vm.Guest.IPAddress
	write-host
	write-host "INFO: Resultado query ip: $vmIPs"
	write-host
	
	$nics = Get-NetworkAdapter -vm $vm	
	[int]$cuantasnics = $nics.Count
	$q_vm_on = $vm.PowerState
	[int]$i = 0	

	if ($q_vm_on -eq "PoweredOn")
	{
		write-host
		write-host "INFO: El servidor $vm esta encendido"
		write-host
		[int]$vms_ons = [int]$vms_ons + 1
		if ([String]$validaIP -eq [String]::Empty)
		{
			$problems = $problems + 1
			write-host
			write-host "STATUS: El query hacia las ip resulta fallido"
			$rip = read-host "INFO: El resultado fallido puede ser por falta de vmware tool, desea continuar? (s/S)"
			write-host
		}
		else
		{
			$fino = $fino + 1
			write-host
			write-host "INFO: El query hacia las ip resulta exitoso."			
			write-host
		}
		
		# Chequeo de las nics.
		$array_nics = @()
		[int]$j = 0
		if ([int]$cuantasnics -eq 0)
		{
			$j = $j + 1
			$statusnic = $nics.ConnectionState.Connected
			$msg9 = "STATUS: El resultado de la verificacion de la conexion de la tarjeta # 1 es $statusnic"
			write-host  $msg9
			$r = writelog $Logfile $msg9
			write-host	
			$array_nics += $statusnic
		}
		else
		{
			foreach ($nic in $nics)
			{				
				$j = $j + 1
				$statusnic = $nic.ConnectionState.Connected
				$msg10 = "STATUS: El resultado de la verificacion de la conexion de la tarjeta # $j es $statusnic"
				$r = writelog $Logfile $msg10
				write-host					
				$array_nics += $statusnic
			}
		}
		
		#reset de la variable en caso de que se use más adelante.
		[int]$j = 0
		
		foreach ($ip in $vmIPs)
		{
			# valida el tipo de ip que tiene el servidor
			$ip4 = $ip.Contains(".")
			$ip6 = $ip.Contains(":")		

			If ($ip4)
			{
				write-host
				write-host "INFO: Servidor $vm reporta ip version 4"
				write-host
				ping $ip >> Logs_ping.txt 
				ping $ip > ping.txt 

				$find = Select-String "Respuesta" ping.txt
				[int]$chk = $find.Count

				If ([int]$chk -gt 0)
				{
					write-host
					write-host "INFO: Servidor $vm reporta respuesta a ping"
					write-host
					$status_ping = "OK"
					if ([int]$cuantasnics -eq 0)
						{$nic = $nics.ConnectionState.Connected}
					else
						{$nic = $nics[$i].ConnectionState.Connected}
					write-host
					write-host "INFO: El valor del estatus de la nic es $nic"
					write-host
					[int]$totnics = [int]$totnics + 1
					If($nic)
					{
						$status_nic = "conectado"
					}
					else
					{
						$status_nic = "DES-conectado"
						$rip1 = read-host "La tarjeta esta desconectada, revisar y si desea migrar igual pulsar (s/S)"
					}
					write-host
					write-host "INFO: El servidor $vm responde a ping hacia la ip $ip"
					write-host
					$esx = $vm.VMHost.Name
					$esx = $esx.subString(1,8)
					$esx = $esx.TrimStart("esxicnt")
					write-host
					write-host "INFO: $vm,$ip,$status_ping,$status_nic,esxi$esx"
					write-host
				}
				else
				{
					write-host
					write-host "INFO: Servidor $vm reporta falta de respuesta a ping"
					write-host
					$status_ping = "FALLA"
					if ([int]$cuantasnics -eq 0)
						{$nic = $nics.ConnectionState.Connected}
					else
						{$nic = $nics[$i].ConnectionState.Connected}
					write-host
					write-host "INFO: el valor del estatus de la nic es $nic"
					write-host
					[int]$totnics = [int]$totnics + 1
					If($nic)
					{
						$status_nic = "conectado"
					}
					else
					{
						$status_nic = "DES-conectado"
						$rip1 = read-host "La tarjeta esta desconectada, revisar y si desea migrar igual pulsar (s/S)"
					}
					write-host
					write-host "INFO: El servidor $vm NO responde a ping hacia la ip $ip"
					write-host
					$esx = $vm.VMHost.Name
					$esx = $esx.subString(1,8)
					$esx = $esx.TrimStart("esxicnt")
					write-host "INFO: $vm,$ip,$status_ping,$status_nic,esxi$esx"
					write-host
				}
				[int]$i = [int]$i + 1
			}	
			else
			{
				write-host
				write-host "INFO: Servidor $vm reporta ip version 6"
				write-host
			}
		}
	}
	else
	{
		[int]$vms_offs = [int]$vms_offs + 1
		write-host
		write-host "INFO: Servidor $vm Reportado como apagado."
		write-host
	}
	
	If(($rip -eq "s" -or $rip -eq "S") -and ($rip1 -eq "s" -or $rip1 -eq "S"))
	{
		write-host "------------------------------------------------------------------------------"
		write-host "INFO: Procederemos a realizar el movimiento del servidor $vm a la esxi $esxi_destino"
		write-host
		Get-vm -name $vm | move-vm -Destination $esxi_destino
		
		# Simulación de una falla de conexión al hacer el movimiento.
		# $simulacion_falla = Get-NetworkAdapter -vm $vm | Set-NetworkAdapter -Connected:$false -StartConnected:$true -WakeOnLan:$true -Confirm:$false		
		
		$msg = "INFO: Se movio el servidor $vm de la ESXi $esxi_fuente hacia la ESXi $esxi_destino"
		$r = writelog $Logfile $msg
	}	
	write-host 
	write-host "------------------- PROCESO DE VALIDACION -------------------"
	write-host 
	$vm = get-vm -name $vm_r
	$nics2 = Get-NetworkAdapter -vm $vm	
	[int]$cuantasnics2 = $nics2.Count
	$i = 0
	$esxi_chk = $vm.host.name
	
	write-host
	write-host "CHK: En estos momentos el servidor $vm_r se encuentra en la esxi $esxi_chk" 
	write-host
	
	
		$howmanynics = $array_nics.length
		write-host "tamanno del array $howmanynics"
		write-host "contenido del array $array_nics"
		for($h=0;$h -lt $howmanynics;$h++)
		{
			if($howmanynics -eq 1)
			{
				$vnic = $nics2.ConnectionState.Connected
				$name_nic = $nics2.name	
				$ahora = $vnic
			}
			else
			{
				$vnic = $nics2[$h].ConnectionState.Connected
				$name_nic = $nics2[$h].name	
				$ahora = $vnic
			}
			
			$i = $h + 1
			if ($vnic)
			{
				write-host
				$msg3 = "PASS: Se verifico que la vNic # $i identificada como $name_nic del servidor $vm se encuentra conectada." 
				write-host  $msg3
				$r = writelog $Logfile $msg3
				write-host
			}
			else
			{
				write-host
				$msg4 = "ERROR: Se determino que la vNic # $i identificada como $name_nic del servidor $vm está desconectada"
				write-host  $msg4
				$r = writelog $Logfile $msg4
				write-host
				$antes = $array_nics[$h]	
				if($ahora -eq $antes)
				{
					$msg5 = "INFO: La tarjeta anteriormente estaba desconectada, se dejará en el mismo estatus."
					write-host  $msg5
					$r = writelog $Logfile $msg5
					write-host
				}
				else
				{
					$msg6 = "INFO: La tarjeta anteriormente estaba conectada, se procedera a conectarla para dejarla como estaba antes del vmotion."
					write-host  $msg6
					$r = writelog $Logfile $msg6
					write-host
					Get-NetworkAdapter -vm $vm | Set-NetworkAdapter -Connected:$true -StartConnected:$true -WakeOnLan:$true -Confirm:$false
					
					$nics2 = Get-NetworkAdapter -vm $vm	
					if($howmanynics -eq 1)
					{
						$vrfnic = $nics2.ConnectionState.Connected
					}
					else
					{
						$vrfnic = $nics2[$h].ConnectionState.Connected
					}	
					if($vrfnic)
					{
						$msg7 = "CHK: La re-conexion de la tarjeta fue exitosa."
						write-host  $msg7
						$r = writelog $Logfile $msg7
						write-host						
					}
					else
					{
						$msg8 = "ERROR: La re-conexion de la tarjeta fue Fallida, por favor revisar y pulsar <enter> para continuar"
						write-host  $msg8
						$r = writelog $Logfile $msg8
						write-host						
					}
				}
				
			}
		}
}
else
	{
	clear-host
	}
	
$resp = read-host "Si reviso, podemos volver al menu (s/n)"
if ($resp -eq "s" -or $resp -eq "S")
{
	clear-host
}