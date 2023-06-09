# Lista los indicadores para un servidor esxi y todos los intervalos.
param ($esx)
Get-StatType -Entity (Get-VMHost $esx)