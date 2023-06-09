write-host "1.- Mover máquinas a partir de un annotation's
2.- Mover máquinas a partir de un contenedor de forma masiva
3.- Mover máquinas a partir de un contenedor de forma individual"
$opc = Read-host "Introduzca una opción: "

if($opc -eq 1)
{
	$annotation = Read-host "Introduzca el valor del Annotation´s para establecerlo como patron de busqueda"
	$rpA = Read-host "Nombre del Resource Pool ( ANoPRD / APRD | ONoPRD / OPRD | Otros )"

	$mqsA = Get-VM | Get-Annotation | where {$_.Value -eq $annotation}
	$CmqsA = ($mqsA).Count 
	for($t=0; $t -lt $CmqsA; $t++)
	{
		Move-VM -VM $mqsA[$t].annotatedEntity.name -Destination $rpA
	}
}

if($opc -eq 2)
{
	$repM = Read-host "Introduzca el nombre del contenedor del cual desea MOVER TODAS SUS MAQUINAS"
	$rpM = Read-host "Nombre del Resource Pool ( ANoPRD / APRD | ONoPRD / OPRD | Otros )"
	Get-vm -Location $repM | Move-VM -Destination $rpM
}

if($opc -eq 3)
{
	$repI = Read-host "Introduzca el nombre del contenedor del cual desea mover las maquinas INDIVIDUALMENTE"
	$mqs = Get-VM -Location $repI
	$crepI = ($mqs).Count
	if(!$annot[0].value) { $Iambiente = "Vacio"} else { $Iambiente = $annot[0].value } 
	if(!$annot[1].value) { $Ifuncion = "Vacio"} else { $Ifuncion = $annot[1].value } 
	if(!$annot[3].value) { $Irepositorio = "Vacio"} else { $Irepositorio = $annot[3].value } 
	for($i=0; $i -lt $crepI;$i++)
	{
		$annot = Get-VM -name $mqs[$i].Name | Get-Annotation
		$rp = Read-Host "Nombre del Resource Pool en el que desea incluir la Maquina: "$mqs[$i].Name", Ambiente: "$Iambiente", Funcion: "$Ifuncion", Repositorio: "$Irepositorio" ( ANoPRD / APRD | ONoPRD / OPRD | Otros )"
		write-host "Movimiento de la maquina" $mqs[$i].Name "al destino" $rp
        Move-VM -VM $mqs[$i].Name -Destination $rp
	}
}