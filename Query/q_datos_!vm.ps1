param($vm)
$queryvm = Get-View -ViewType VirtualMachine -Filter @{"Name" = $vm}
$hostView = Get-View -ID $queryvm.Runtime.Host
$queryvm
$hostView.Summary.Runtime

