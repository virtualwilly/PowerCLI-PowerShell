param($file,$clust)

############################ Definici�n de funciones.
. "y:\funciones.ps1" 

echo "CSTS-Adecuaci�n" >> $file
echo "---------------" >> $file
echo "" >> $file
$res = QueryVmsInFolderAndEsx $file CSTS-Adecuacion $clust
echo "CSTS-Unix" >> $file
echo "---------------" >> $file
echo "" >> $file
$res = QueryVmsInFolderAndEsx $file CSTS-Unix $clust
echo "CSTS-Windows" >> $file
echo "---------------" >> $file
echo "" >> $file
$res = QueryVmsInFolderAndEsx $file CSTS-Windows $clust
echo "Deposito" >> $file
echo "---------------" >> $file
$res = QueryVmsInFolderAndEsx $file Deposito $clust