$vmname = read-host "Introduzca el nombre del servidor"
$repositorio = read-host "Introduzca el nombre del repositorio al cual va a ser dirigido"
$emailTec = read-host "Introduzca el email del tecnico omitiendo el @cantv.com.ve"
$emailSuper = read-host "Introduzca el email del supervidor omitiendo el @cantv.com.ve"
$nombre = read-host "Introduzca el nombre del técnico que se encargará de su administración"

#Realiza el movimiento de la maquina virtual
Move-VM -VM $vmname -Destination $repositorio

Get-VM -Name $vmname | Set-CustomField -Name "Repositorio" -Value $repositorio -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "Responsable" -Value $nombre -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "emailSupervisor" -Value "$emailSuper@cantv.com.ve" -Confirm:$false
Get-VM -Name $vmname | Set-CustomField -Name "emailTecnico" -Value "$emailTec@cantv.com.ve" -Confirm:$false