# script que mueve un servidor virtual hacia un data store definido 
# y el tipo de disco hacia el destino (thin,thick)
# Fecha: Octubre 2012
# Autor: William Téllez / Miguel Soto
# Ejemplo: move_!vm_!DataStorage_!format.ps1 Train VMFS_CNT150 thick

param($vm,$dstore,$format)
If ($format -eq "")
   {
   get-vm $vm | move-vm -datastore (get-datastore $dstore)
   }
else
   {
   get-vm $vm | move-vm -datastore (get-datastore $dstore) -DiskStoreageFormat $format
   }	