param($srv)
$vm = get-vm -name $srv
$folderN = $vm.folder
write-host $folderN
$FolderN_Id = $vm.folder.Id
write-host $FolderN_Id
$fcfg = get-view $vm.folder.Id
$fp = $fcfg.Parent
write-host $fp
$fpN1 = get-folder -Id $fp
write-host $fpN1
$f = get-folder -Name $fpN1
$fid = $f.Parent.Name
write-host $fid

