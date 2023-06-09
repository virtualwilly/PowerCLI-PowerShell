param($vm)

Get-VM -name $vm | Select-Object -property Name, 
@{N="Cluster: ";E={$_.VMhost.Parent}},
 @{N="ESX Host: ";E={$_.VMHost}},
 @{N="Contenedor: ";E={
  $nodes = @()
  $obj = $_.ExtensionData
  while ($obj.Parent){
    $obj = Get-View $obj.Parent
    if("Datacenter: ","vm" -notcontains $obj.Name){
      $nodes += $obj.Name
    }
  }
  [string]::Join('/',$nodes[($nodes.Count - 1)..0])}},
@{N="Datastore: ";E={Get-Datastore -VM $_}}

get-vmguest -vm $vm | select @{N="Sistema Operativo del equipo consultado";E={$_.OSFullName}}

Get-VM -name $vm | Get-View | Select-Object @{Name="Status vmware tools";E={$_.Guest.ToolsStatus}}

$datos = get-vm -name $vm | Select-Object -property NumCpu,MemoryMB
$cpu = $datos.NumCpu
$ram = $datos.MemoryMB


"vCpu: $cpu"
"vRam: $ram Mg"
""

$srv = Get-VM -name $vm
$vmIPs = $srv.Guest.IPAddress
$i = 0

foreach ($ip in $vmIPs)
{	
	$i++
	"Ips($i) registrada: $ip"
}

""
$nics = Get-NetworkAdapter -vm $vm
$i = 0

foreach ($nic in $nics)
{	
	$i++
	$mac = $nic.MacAddress
	$vlan = $nic.NetworkName
	"Macs($i) registrada: $mac"
	"vlan($i) registrada: $vlan"
}

$disks = Get-HardDisk -VM $vm
$i = 0
""

foreach ($d in $disks)
{
	$i++
	$Cap = $d.CapacityKb
	$tot = $Cap/1024/1024
	"Capacidad disco ($i): $tot Gb"
}

