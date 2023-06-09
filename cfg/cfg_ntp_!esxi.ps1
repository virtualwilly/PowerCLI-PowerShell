param($p_esxi)
Add-VMHostNtpServer –VMHost $p_esxi –NtpServer "200.44.32.89", "200.44.32.178"
Set-VMHost –VMHost $p_esxi –TimeZone "UTC"
Get-VMHost $p_esxi | Get-VMHostService | where {$_.Key -eq "ntpd"} |Set-VMHostService -Policy "on"
Get-VmHostService -VMHost $p_esxi | Where-Object {$_.key -eq “ntpd“} | Start-VMHostService






