# ej: r_nic_!vm_!.ps1
# not� que uno de los parametros no es utilizado, colocar� el archivo inhabilitado para su revisi�n (Miguel Soto)
param($p_vm,$p_nic)
$adapter = get-networkadapter -VM $p_vm
Remove-NetworkAdapter -NetworkAdapter $adapter

