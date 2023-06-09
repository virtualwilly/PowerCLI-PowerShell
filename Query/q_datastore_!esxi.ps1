param($p_esxi)
get-vmhost -name $p_esxi | get-datastore