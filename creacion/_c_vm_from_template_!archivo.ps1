

$displayname = "Coremc01-chc-prod"


$vcpu = 2 $memMB = 2048 
$Disk1GB = 30
$Disk2GB = 20  # 0 = no 2nd/3rd disk
$Disk3GB = 0    # 0 = no 2nd/3rd disk
$haprio = "ClusterRestartPriority" #ClusterRestartPriority, Disabled, Low, Medium, High
$prodtest = "PROD" # PROD or TEST

$description = "testvm scripted"
$sourcetemplate = "W2k8R2-Template" #vCenter name of the template
$responsible = "Mr. Nameless"

$network =  "VLAN_311" #Name of the vSSwitch/dvSwitch Portgroup
$NetIP = "10.1.1.72"
$NetMask = "255.255.255.0"
$NetGW = "10.1.1.1"
$NetDNS = ("10.10.1.20", "10.10.1.21", "10.10.1.22")
$NetWins = "10.10.1.25"

$computername = "MyNETBIOSName"
$domainfqdn = "mydomain.local"
$localadmingroup = "MyADAdmins"

$RunOnce = (
    "net config server /SRVCOMMENT:`"$description`"",
    "netsh interface set interface name=`"Local Area Connection`" newname=`"NIC1 - $NetIP`"",
    "c:\install\someagent.exe /install"
)

Then I have a couple of functions or code blocks doing the actual work, here are a few (UpdateVMSettings is probably what you want):
 
if($prodtest -eq "PROD") {
    $cluster = (Get-Cluster ProductiveCluster)
    $datastore = (Get-DatastoreCluster MyDRSCluster)
}
elseif($prodtest -eq "TEST") {
    $cluster = (Get-Cluster TestCluster)
    $datastore = ($cluster | Get-VMHost | Get-Datastore TEST_LUN_* | Sort -Property FreeSpaceMB | Select -last 1)
}

function Get-LocalAdminCreds {
    Write-Host "Enter Password for local admin of the VM:`n"    return (Get-Credential administrator)
}

function CreateTemplateSpec {
    New-OSCustomizationSpec -Type NonPersistent -Name "Tempspec" -OSType Windows -Description "Temp scripted Spec $description" -FullName "My Name" -OrgName "My Company" -NamingScheme Fixed -NamingPrefix $computername -AdminPassword $localadmincreds.GetNetworkCredential().password -TimeZone 110 -ChangeSid -Domain $domainfqdn -DomainCredentials $adcredentials -GuiRunOnce $RunOnce -AutoLogonCount 1    Get-OSCustomizationSpec Tempspec | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IPAddress $NetIP -SubnetMask $NetMask -DefaultGateway $NetGW -Dns $NetDNS -Wins $NetWins}

function UpdateVMSettings {
    Write-Host "Changing Portgroup and virtual Hardware..."
    $PortGroup = ($vm | Get-VMHost | Get-VirtualPortGroup -Name $network)
    Get-NetworkAdapter -VM $vm | Set-NetworkAdapter -NetworkName $PortGroup -StartConnected $true -Confirm:$false
    Set-VM $vm -MemoryMB $memMB -NumCpu $vcpu -Confirm:$false

    Get-HardDisk -VM $vm | Set-HardDisk -CapacityKB ($Disk1GB * 1MB) -Confirm:$false    
    if($Disk2GB -gt 0) { New-HardDisk -VM $vm -CapacityKB ($Disk2GB * 1MB) -Storageformat Thin -Confirm:$false }
    if($Disk3GB -gt 0) { New-HardDisk -VM $vm -CapacityKB ($Disk3GB * 1MB) -Storageformat Thin -Confirm:$false }

    Set-Annotation $vm -CustomAttribute "Created on" -Value (Get-Date -uformat %d.%m.%Y) -Confirm:$false
    Set-Annotation $vm -CustomAttribute "Created by" -Value $env:username -Confirm:$false
    Set-Annotation $vm -CustomAttribute "System owner" -Value $responsible -Confirm:$false
}

New-VM -Name $displayname -Location $vclocation -ResourcePool $cluster -Datastore $datastore -Description $description -Template $sourcetemplate -OSCustomizationspec Tempspec -HARestartPriority $haprio -DiskStorageFormat Thin