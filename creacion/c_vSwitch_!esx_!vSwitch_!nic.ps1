# comandos que crean un nuevo virtual switch en una esx determinada.
# parámetros: 1. esx, el nombre del virtual switch y el nombre de la nic física del esx.
# ej: c_vSwitch_!esx_!vSwitch_!nic.ps1
param($p_esx,$p_vs,$p_nic)
New-VirtualSwitch -VMHost $p_esx -Name $p_vs -nic $p_nic