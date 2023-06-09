param($esxi, $metric, $intervalo)
#, $instancia)
Get-Stat -Entity (Get-VMHost $esxi) -Stat $metric -IntervalMins $intervalo 
#| where{$_.instance -eq $instancia}
