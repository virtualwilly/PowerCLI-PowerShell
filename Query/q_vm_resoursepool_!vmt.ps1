

param ($vm)

function Get-Path{
    param($Object)
    
    $path = $object.Name
    $parent = Get-View $Object.ExtensionData.ResourcePool
	$i = 1
    while($parent){
        $path = $parent.Name + "/" + $path
		write-host "$i. ruta: $path"
		$i++
        if($parent.Parent){
            $parent = Get-View $parent.Parent
        }
        else{$parent = $null}
    }
    $path
}

Get-VM -name $vm | Select Name,@{N="Path";E={Get-Path -Object $_}}
