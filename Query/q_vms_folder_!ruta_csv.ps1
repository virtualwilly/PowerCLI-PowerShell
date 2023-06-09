# Ejemplo .\qvm_folder C:\Temp\vm-folder.csv

param ($ruta)
Get-VM | select Name,@{N="Folder";E={$_.Folder.Name}} | `
 Export-Csv $ruta -NoTypeInformation -UseCulture