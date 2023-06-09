# ej: r_nic_!vm_!.ps1
# noté que uno de los parametros no es utilizado, colocaré el archivo inhabilitado para su revisión (Miguel Soto)
param($p_vm,$p_nic)
$adapter = get-networkadapter -VM $p_vm
Remove-NetworkAdapter -NetworkAdapter $adapter

