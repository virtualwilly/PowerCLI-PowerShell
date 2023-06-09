param ($p_cluster, $p_ds, $p_path, $nfsd)

process
{
connect-viserver -server 10.1.194.202
$l_hosts = get-vmhost -location (get-cluster -name $p_cluster) foreach ($server in $l_hosts)
	{
	nre-datastore -nfs -vmhost $server -name $p_ds -path $p_path -nfshost $p_nfsd
	}
}