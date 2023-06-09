# Script que define un valor a un Annotations personalizada en las vm que estén dentro de una carpeta.
# Ejemplo: cfgannotation_in_folder.ps1 Servicio WebServices CSTS-Adecuacion
# Explicación: (1) El script busca todas las vm que corresponden a la carpeta CSTS-Adecuacion.
# 			   (2) Luego por cada vm resultante del paso 1, incluye el valor WebServices en la anotación llamada
#                  Servicio.

param($annotation,$valor,$carpeta)

$vms = get-vm -Location $carpeta
ForEach($vm in $vms)
{
Get-Vm -name $vm | Set-CustomField -Name $annotation -Value $valor
}
