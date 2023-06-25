# funci�n que obtiene las estad�sticas de un determinado indicador.
# Par�metros: (1) Nombre esxi, (2) la m�trica
# (3) la cantidad de muestras a tomar y (4) el intervalo en minutos.
# Ejemplo: qmetric_esx_intervalo.ps1 esxicnt01 "cpu.usage.average" 2 5
param ($esxi, $metric, $muestra, $intervalo)
Get-Stat -Entity (Get-VMHost $esxi) -Stat $metric -MaxSamples $muestra -IntervalMins $intervalo

