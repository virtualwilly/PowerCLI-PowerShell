# Script que consulta en el vCenter un servidor virtual
# y regresa el folder donde se encuentra.
# Ejemplo .\qvm_folder_!vm w2k3lab02

param ($vm)
Get-VM -name $vm | select Name,@{N="Carpeta";E={$_.Folder.Name}}