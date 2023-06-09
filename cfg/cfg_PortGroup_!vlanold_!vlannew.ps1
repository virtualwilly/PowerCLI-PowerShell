param ($nold, $nnew)
#$list = Get-VM |Get-NetworkAdapter |Where {$_.NetworkName -eq $nold }
Get-VM |Get-NetworkAdapter |Where {$_.NetworkName -eq $nold } | Set-NetworkAdapter -NetworkName $nnew -Confirm:$false
Get-VM |Get-NetworkAdapter |Where {$_.NetworkName -eq $nnew } |Set-NetworkAdapter -Connected $false -Confirm:$false
Get-VM |Get-NetworkAdapter |Where {$_.NetworkName -eq $nnew } |Set-NetworkAdapter -Connected $true -Confirm:$false