# Script que busca la dirección ip pasada por parámetro y devuelve el nombre de la vm.
# Ejemplo: q_vm_!ip.ps1 10.1.194.248
param($ip_a_buscar)

#Variables
$i = 0
$result = 0

clear-host
write-host  
write-host "    Barra de progreso de la busqueda, NO se desespere.    "
write-host "1% |--------------------------------------------------| 100%"
$vms = Get-VM
$num = $vms.count
write-host $num

foreach($vm in $vms)
{
  # Cálculos de porcentajes de avances.
  $i++
  $p = $i/$num*50
  $pr = "{0:N0}" -f $p
  $pr1 = $i/$num*100
  $preal = "{0:N0}" -f $pr1
  
  clear-host  
  write-host  
  write-host "    Barra de progreso de la busqueda, NO se desespere.  $preal%"
  write-host "1% |--------------------------------------------------| 100%"
  write-host "1%  $('*'*$pr)" -foregroundcolor Cyan
  $vmIPs = $vm.Guest.IPAddress
  foreach ($ip in $vmIPs)
  {
	$chk = $ip -eq $ip_a_buscar
	#write-host $chk
	#read-host "ip analizada: $ip contra la ip buscada: $ip_a_buscar"
    if ($chk)
	{
	  $result = 1
      $nombre = $vm.Name 
	  write-host
	  write-host	  
	  write-host "Resultado de la busqueda:"
	  write-host 
	  write-host "El servidor con la ip: $ip_a_buscar es: $nombre"
	  write-host
	  read-host "Pulse cualquier tecla para terminar y limpiar la pantalla."
	  clear-host
	  break	  
    }
    if ($result -eq 1)	{break}
  }
  if ($result -eq 1)	{break}
}

#write-host "El valor de la bandera de resultado es $result"
if ($result -eq 0)
	{
		write-host
		write-host
		write-host "Resultado de la busqueda:"
		write-host
		write-host "La ip no fue encontrada, puede ser que el servidor no tiene instalado los vmware-tools o no la tiene configurada."
		write-host
		read-host "Pulse cualquier tecla para terminar y limpiar la pantalla."
	    clear-host
	    break	  
	}