#Script que elimina un servidor virtual tanto del inventario como del disco y no pide confirmación.
# NOTA: SCRIPT DELICADO YA QUE BORRA LA VM DEL DISCO, EJECUTAR CON CAUTELA.
#Ejemplo: .\r_vm!.ps1 test 

param ($vm)
remove-vm -vm $vm -DeletePermanently -Confirm:$false