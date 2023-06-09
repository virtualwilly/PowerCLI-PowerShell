# Script que hacer una consulta sobre el sistema operativo que tiene una vm.
# ejemplo: .\q_so_!vm.ps1 Train
# Autor: William Téllez
# Fecha: Octubre 2012

param($vm)
get-vmguest -vm $vm | select @{N="Sistema Operativo del equipo consultado";E={$_.OSFullName}}
