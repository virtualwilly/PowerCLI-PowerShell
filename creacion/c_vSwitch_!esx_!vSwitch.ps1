# comandos que crean un nuevo virtual switch en una esx determinada.
# parámetros: 1. esx, el nombre del virtual switch.
# ej: c_vSwitch_!esx_!vSwitch.ps1
param($p_esx,$p_vs)
New-VirtualSwitch -VMHost $p_esx -Name $p_vs