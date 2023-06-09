$de = "script.vmware@cantv.com.ve"
$a = "wtellez@cantv.com.ve;mmurci01@cantv.com.ve;msotog01@cantv.com.ve"
$tit = "Ejecución script cfg_!esxi_!ds_!path_!nfsd.ps1"
$c = "Se ejecutó el script fg_!esxi_!ds_!path_!nfsd.ps1 que crea un data store apuntando al netapp vía NFS" + [char] 10
$c = $c + "con los siguientes parámetros" + [char] 10 + [char] 10
$c = $c + '$esxi' + ": $esxi" + [char] 10
$c = $c + '$ds' + ": $ds" + [char] 10
$c = $c + '$path' + ": $path" + [char] 10
$c = $c + '$nfsd' + ": $nfsd" + [char] 10

$ErrorActionPreference = 'SilentlyContinue'
get-vm -name s
if ($?)
   {c$ = c$ + "El script o comando terminó con sin código de error"}
else
   {c$ = c$ + "El script o comando terminó con el código de erorr siguiente: $Error[0]"}
Send-MailMessage –From $de –To $a –Subject $tit –Body $c