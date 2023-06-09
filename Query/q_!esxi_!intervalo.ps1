# Obtienen datos más específicos, combinando el indicador y un intervalo determinado.
 param ($esxi, $num_inter)
 if ($num_inter -eq 1) {$intervalo = "Past Day"}
 if ($num_inter -eq 2) {$intervalo = "Past Week"}
 if ($num_inter -eq 3) {$intervalo = "Past Month"}
 if ($num_inter -eq 4) {$intervalo = "Past Year"}
 Get-StatType -Entity (Get-VMHost $esxi) -Interval $intervalo
