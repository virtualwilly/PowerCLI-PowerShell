# Script que hacer una consulta sobre las direcciones ip que tiene una vm.
# ejemplo: .\q_ip_!vm.ps1 Train
# Autor: William Téllez
# Fecha: Octubre 2012

param($vm)
get-vmguest -vm $vm | select @{N="Direcciones ip reportadas por los vmware tools";E={$_.IPAddress}}
