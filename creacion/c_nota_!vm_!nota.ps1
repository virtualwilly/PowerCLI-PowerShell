#ej: c_nota_!vm_!nota.ps1
param($vm, $servicio_completo)

Set-VM -VM $vm -Description $servicio_completo -Confirm:$false;