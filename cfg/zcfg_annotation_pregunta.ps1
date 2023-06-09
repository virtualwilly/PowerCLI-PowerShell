# Script que define un valor a un Annotations personalizada en una vm determinada.
# Ejemplo: cfgannotation.ps1 Train Ambiente Laboratorio
# Explicación: (1) El script busca la vm a registrar la anotación.
# 			   (2) Luego incluye el valor Laboratorio en la anotación llamada Ambiente.

$vm = Read-Host "Servidor: "
$amb = "Produccion"
$Remedy = Read-Host "Remedy: "
$Repositorio = "CSTS-Adecuacion"
$Responsable = "Ramón Arias"
$emailSupervisor = "rchapa"
$emailTecnico = "aramon01"

Get-Vm -name $vm | Set-CustomField -Name Ambiente -Value $amb
Get-Vm -name $vm | Set-CustomField -Name Remedy -Value $Remedy
Get-Vm -name $vm | Set-CustomField -Name Repositorio -Value $Repositorio
Get-Vm -name $vm | Set-CustomField -Name Responsable -Value $Responsable
Get-Vm -name $vm | Set-CustomField -Name emailSupervisor -Value $emailSupervisor
Get-Vm -name $vm | Set-CustomField -Name emailTecnico -Value $emailTecnico


