ej: r_ntp_!ipNtp_!esx.ps1
param ($ip_ntp, $esxi)
Remove-VmHostNtpServer -NtpServer $ip_ntp -VMHost $esxi | Out-Null
