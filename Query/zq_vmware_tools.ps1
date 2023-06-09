# Add in the VI Toolkit goodness
if ( (Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue) -eq $null )
{
Add-PSsnapin VMware.VimAutomation.Core
}
 
# Connect to the vCenter server(s)
$vcserver= @()
 
$vcserver += connect-VIServer &quot;&lt;Your vCenter Server&gt;&quot;
 
# get the vmware tools version for each VM
 
get-vm |% { get-view $_.id } | select Name, @{ Name=&quot;ToolsVersion&quot;; Expression={$_.config.tools.toolsVersion}}
 
# Disconnect from the vCenter server(s)
disconnect-viserver $vcserver -Confirm:$False
 
# END
###

#The get-vm is not needed in the script, simply used this command :

Get-View -ViewType VirtualMachine | select Name, @{ Name=”ToolsVersion”; Expression={$_.config.tools.toolsVersion}}