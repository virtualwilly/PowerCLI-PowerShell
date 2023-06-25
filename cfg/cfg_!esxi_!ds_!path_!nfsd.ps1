# Script que crea un data store apuntando a un volumen v�a nfs.
# Nota: Se asume que hay una conexi�n v�lida al vcenter para ejecutar este script.
# Par�metros:
# (1) Nombre del servidor esxi a quien aplicar� la creaci�n del data store.
# (2) El nombre del data store a ser creado.
# (3) Camino o ruta del volumen que montar� el data store.
# (4) nombre o direcci�n ip del servidor que ofrece el volumen.
# Autor: William T�llez.
# Fecha: 10/01/2013
# ej1. cfg_!esxi_!ds_!path_!nfsd.ps1 esxicnt02.cantv.com.ve VMFS_NFS_DS01 /VOL/VMFS_VOL0 161.196.109.24
# ej2 cfg_!esxi_!ds_!path_!nfsd.ps1 esxicnt02.cantv.com.ve RDM_NFS_DSBackup /vol/rdm_vol0 161.196.109.24

function ECorreoBasico($de,$a,$tit,$cuerpo)
{
Send-MailMessage �From $de �To $a �Subject $tit �Body $cuerpo
}

param ($esxi,$ds, $path, $nfsd)
new-datastore -nfs -vmhost $esxi -name $ds -path $path -nfshost $nfsd
$d = script.vmware@cantv.com.ve
$a = "wtellez@cantv.com.ve;mmurci01@cantv.com.ve;msotog01@cantv.com.ve"
$t = "Ejecuci�n script cfg_!esxi_!ds_!path_!nfsd.ps1"
$c = "Se ejecut� el script fg_!esxi_!ds_!path_!nfsd.ps1 que crea un data store apuntando al netapp v�a NFS" + [char] 10
$c = c + "con los siguientes par�metros" + [char] 10 + [char] 10
$c = c + '$esxi'": $esxi" + [char] 10
$c = c + '$ds'": $ds" + [char] 10
$c = c + '$path'": $path" + [char] 10
$c = c + '$nfsd'": $nfsd" + [char] 10
ECorreoBasico($d,$a,$t,$c)

