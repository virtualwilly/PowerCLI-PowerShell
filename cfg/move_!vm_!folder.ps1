# comando que mueve una vm a un folder determinado.
# parámetros: el nombre de la vm y el nombre del folder.
# Ejemplo: move_vm_folder.ps1 train CSTS-Windows
param ($vm, $folder)
Move-VM -VM (get-vm -name $vm) -Destination $folder