$de = "script.vmware@cantv.com.ve"
$a = "wtellez@cantv.com.ve;mmurci01@cantv.com.ve;msotog01@cantv.com.ve"
$tit = "Ejecuci�n script cfg_!esxi_!ds_!path_!nfsd.ps1"
$c = "Se ejecut� el script fg_!esxi_!ds_!path_!nfsd.ps1 que crea un data store apuntando al netapp v�a NFS" + [char] 10
$c = $c + "con los siguientes par�metros" + [char] 10 + [char] 10
$c = $c + '$esxi' + ": $esxi" + [char] 10
$c = $c + '$ds' + ": $ds" + [char] 10
$c = $c + '$path' + ": $path" + [char] 10
$c = $c + '$nfsd' + ": $nfsd" + [char] 10

$ErrorActionPreference = 'SilentlyContinue'
get-vm -name s
if ($?)
   {c$ = c$ + "El script o comando termin� con sin c�digo de error"}
else
   {c$ = c$ + "El script o comando termin� con el c�digo de erorr siguiente: $Error[0]"}
Send-MailMessage �From $de �To $a �Subject $tit �Body $c