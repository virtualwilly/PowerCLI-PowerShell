# Función que valida si el servidor virtual existe.
# fecha, autor: William Téllez.
param($vm)

$obj_vm = get-VM $vm
if (!$?) 
   {
   if ($error[0].Exception –is [VMware.VimAutomation.ViCore.Types.V1.ErrorHandling.DuplicateName]) 
      {
	  write-host "error"
	  }   
   }
$nombre = $obj_vm.name

if ($nombre -eq $vm)
   {
   write-host
   write-host
   write-host "El servidor existe y se encuentra en el vCenter Server"
   write-host
   write-host
   }
else 
   {
   write-host
   write-host
   write-host "El servidor NO  existe"
   write-host
   write-host
   }
