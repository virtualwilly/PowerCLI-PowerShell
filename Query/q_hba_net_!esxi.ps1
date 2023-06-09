param($p_host)
get-vmhosthba -vmhost $p_host
get-vmhostnetwork -vmhost $p_host
Get-VMHostNetworkAdapter -vmhost $p_host
get-vmhostntpserver -vmhost $p_host
