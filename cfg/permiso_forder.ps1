# Ejemplo: permiso_folder (CANTV, GG_Vmware_Adecuacion_RM_, CST-Adecuacion, ADM_NivelBasico)
param($dominio, $grupo, $contenedor, $role)
$domain = $dominio
$groupname = $grupo
$svcgroup = $domain + "\" + $groupname

$folder = Get-Folder -Name $contenedor
$authMgr = Get-View AuthorizationManager
$perm = New-Object VMware.Vim.Permission
$perm.principal = $svcgroup
$perm.group = $true
$perm.propagate = $true
$perm.roleid = ($authMgr.RoleList | where{$_.Name -eq $role}).RoleId
$authMgr.SetEntityPermissions(($folder | Get-View).MoRef, $perm)