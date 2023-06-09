# Asigna un grupo de seguridad 
# CANTV\GGI_VMWare_Network_
# Ejemplo .\permiso_vlan.ps1 esxicnt01.cantv.com.ve VLAN10 CANTV\GGI_Vmware_Network_ Administrator
param($esxi, $vlan, $user, $rol)
$esxName = $esxi
$pgName = $vlan
$user = $user                  # Ex "TEST\luc"
$role = $rol                     # Ex "Admin"
$group = $true
$propagate = $false

$authMgr = Get-View (Get-View ServiceInstance).Content.authorizationManager
$perm = New-Object VMware.Vim.Permission
$perm.Principal = $user
$perm.roleId = ($authMgr.RoleList | where{$_.Name -eq $role}).RoleId
$perm.group = $group
$perm.propagate = $propagate

$esx = Get-VMHost -Name $esxName
$esx.ExtensionData.Network | %{
     $net = Get-View $_
     if($net.Name -eq $pgName){
          $authMgr.SetEntityPermissions($_,$perm)
     }
}