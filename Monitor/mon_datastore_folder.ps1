# Script que monitorea los data store fuera de las carpetas o folders definido para clasificarlas.
# Autor: William T�llez.
# Fecha: 14 / 12 / 2012
# En contrucci�n.

$folders = 4,"IBM","lIBM","UCS","lUCS"
#$fid += 5
for ($i = 1;$i -eq 4;$i++)
   {
   write-host "hola $i"
   #$fid = get-folder -name $folders[$i] | select {$_.Id}
   }

#$ds = get-datastore | where {($_.ParentFolderId -ne "Folder-group-s1370") -and ($_.ParentFolderId -ne "Folder-group-s5036") -and ($_.ParentFolderId -ne "Folder-group-s5035") -and ($_.ParentFolderId -ne "Folder-group-s1371")} | select name

