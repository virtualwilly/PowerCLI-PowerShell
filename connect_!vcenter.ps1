#Add-PSSnapin “VMware.VimAutomation.Core”
#Set-ExecutionPolicy RemoteSigned


param($vcenter)

Set-ExecutionPolicy Unrestricted

$default = Read-Host "¿El usuarios es: administrator@vsphere.local? (y/n)"
If ($default -eq "y")
	{$user = "administrator@vsphere.local"}
elseif
	{$user = Read-Host "Introduzca el nombre del usuario"}

$pass = Read-Host "Introduzca la Contraseña" -assecurestring
$decode = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))

# Comando en PowerCLI para conectarse al vCenter con sus 3 parámetros.
Connect-VIServer -Server  $vcenter -User $user -Password $decode