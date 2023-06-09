# Script que consulta las diferentes vlans que tiene un esxi en un vSwitch determinado.
# terminarlo.

param($plat, $esxi,$vSwitch) 
 
 get-vmhost -name "$esxi.cantv.com.ve" -location  ClusterIBM01 | get-virtualswitch -name $vSwitch | get-virtualportgroup