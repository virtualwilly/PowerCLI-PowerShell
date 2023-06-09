# Script que Analiza las vlan de cada una de los virtual switchs por cada Esxi.

# Las vlans deben alimentarse automáticamente.
$vlans = @(889,7,801,1616,800,808,811,750,22,23,2004,142,24,204,29,94,33,200,2000,88,2020,2002,13,266,2001,219,14,20,10,114,16,96,45,46,61,15,260,185,1,802,50,87,11,698,699,53,26,697,205,250,80)


. "y:\funciones.ps1" 

$esxis = Get-VMHost
$arch = "c:\vlan_report.txt"
$xcrear = "c:\xcrear.txt"
$demas = "c:\demas.txt"

foreach ($esxi in $esxis)
{
	clear-host
	write-host "-------- ANALISIS DE LOS vSWITCHs SOBRE LOS ESXi ---------"
	write-host	
	$msg0= "INFO: Nos encontramos analizando el servidor fisico: $esxi"
	writelog $arch "-------------------------------------------------------------------------------"
	writelog $arch $msg0
	writelog $arch "-------------------------------------------------------------------------------"
	write-host $msg0

	$vlanesxi = @()
	$pgroup = $esxi | Get-VirtualPortGroup
	
	# Inicio de variables.	
	$numvlan = $vlans.length - 1
	$salir=0
	$i=0
	do 
	{
		$switch = $pgroup[$i].VirtualSwitch.Name
		[int]$chk = [bool]$switch
		[int]$vlan = [int]$pgroup[$i].VLanId
		$vlanesxi += [int]$vlan
		$name = $pgroup[$i].Name
		
		# INFO
		$msg1 = "Analisis del Switch $switch vLan $vlan etiquetada $name"
		writelog $arch $msg1
		write-host
		write-host $msg1
		write-host	
		
		
		$i++
		if($vlan -eq 0 -and $chk -eq $False)
		{
			write-host "Fin del analisis, vlan es igual a $vlan"
			$salir=1
		}		
	}
	until ($salir -eq 1)
	
	#### Analisis del esxi.
	
	$nvlanesxi = $vlanesxi.length - 1
	write-host
	write-host "total de vlan encontradas: $nvlanesxi"
	write-host	
	
	# compara cada vlan registrada en la esxi con el listado de vlans para buscar vlan sobrantes
	for ($j=0;$j -lt $numvlan;$j++)
	{
		$vlan_d_mas = 0
		for ($i=0;$i -lt $nvlanesxi;$i++)
		{
			if ($vlans[$j] -eq $vlanesxi[$i])
			{
				$vlan_d_mas = 1
			}			
		}
		if ($vlan_d_mas -eq 0)
		{
			$echo1 = $vlans[$j]
			$msg3 = "NOTA: La vLan $echo1 falta ser creada en la Esxi $esxi"
			writelog $arch $msg3
			writelog $xcrear $msg3
			# read-host $msg3
		}
	}
	
	# Compara cada vlan del listado con la vlan de cada esxi para buscar que vlan le faltaría
	for ($i=0;$i -lt $numvlan;$i++)
	{
		$vlan_faltante = 0
		for ($j=0;$j -lt $nvlanesxi;$j++)
		{
			if ($vlans[$j] -eq $vlanesxi[$i])
			{
				$vlan_faltante = 1
			}
		}
		if ($vlan_faltante -eq 0)
		{
			$echo2 = $vlanesxi[$i]
			$msg4 = "NOTA: La vLan $echo2 se encuentra de mas en el Esxi $esxi"
			writelog $arch $msg4
			writelog $demas $msg4
			# read-host $msg4
		}
	}
}