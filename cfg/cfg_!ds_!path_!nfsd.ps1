# Script que crea un data store apuntando a un volumen v�a nfs en todos los servidores.
# Nota: Se asume que hay una conexi�n v�lida al vcenter para ejecutar este script.
# Par�metros:
# (1) El nombre del data store a ser creado.
# (2) Camino o ruta del volumen que montar� el data store.
# (3) nombre o direcci�n ip del servidor que ofrece el volumen.
# Autor: William T�llez.
# Fecha: 10/01/2013
# ej1. cfg_!ds_!path_!nfsd.ps1 esxicnt02.cantv.com.ve VMFS_NFS_DS01 /VOL/VMFS_VOL0 161.196.109.24
# ej2 cfg_!ds_!path_!nfsd.ps1 esxicnt02.cantv.com.ve RDM_NFS_DSBackup /vol/rdm_vol0 161.196.109.24

param ($ds, $path, $nfsd)

process
{
$esxi = get-vmhost -location (get-cluster) foreach ($server in $esxi)
	{
	new-datastore -nfs -vmhost $server -name $ds -path $path -nfshost $nfsd
	}
}
