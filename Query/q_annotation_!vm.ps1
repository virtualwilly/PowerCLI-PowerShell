param($vm)
Get-VM -name $vm | `
  ForEach-Object {
    $VM = $_.Name
    $_ | Get-Annotation | `
    ForEach-Object {
      $Report = "" | Select VM,Name,value
      $Report.VM = $VM
      $Report.Name = $_.Name
      $Report.value = $_.Value
      $Report
    }
  }