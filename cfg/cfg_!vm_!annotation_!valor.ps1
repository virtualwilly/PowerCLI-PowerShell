# Script que define un valor a un Annotations personalizada en una vm determinada.
# Ejemplo: cfgannotation.ps1 Train Ambiente Laboratorio
# Explicaci�n: (1) El script busca la vm a registrar la anotaci�n.
# 			   (2) Luego incluye el valor Laboratorio en la anotaci�n llamada Ambiente.
param($vm,$annotation,$valor)
Get-Vm -name $vm | Set-CustomField -Name $annotation -Value $valor
