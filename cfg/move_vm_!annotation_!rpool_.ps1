param($etiqueta, $rpool)

$vms = Get-VM | Get-Annotation | where {$_.Value -eq $etiqueta}

ForEach($vm in $vms.AnnotatedEntity.Name)
{
Move-VM -VM (get-vm -Name $vm) -Destination (Get-ResourcePool -Name $rpool)
}

#Move-VM -VM (Get-VM -Name MyVM)-Destination (Get-ResourcePool -Name “Important“)
