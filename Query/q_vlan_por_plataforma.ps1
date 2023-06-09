$opcion = read-host "Si desdea saber las vlan de servicio registradas en la plataforma UCS, pulse 1, <enter> para IBM"
if ($opcion -eq 1)
   {
   get-vmhost -name esxicnt01.cantv.com.ve | get-virtualswitch -name vSwitch1 | get-virtualportgroup   
   }
else
   {
   write-host "Entendemos que desea tener el listado de vlan en la plataforma IBM"
   get-vmhost -name vmcnt01.cantv.com.ve | get-virtualswitch -name vSwitch0 | get-virtualportgroup   
   }

