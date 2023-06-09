#################################################################################################
# Script que crea el archivo de respuesta para la instalación desatendida de un servidor esxi.
# Autor: William Téllez (CATS-Windows)
# Última modificación: 24/05/2013
#################################################################################################
write-host
write-host "LEER ANTES DE SEGUIR"
write-host
write-host "Recuerde que el script tiene como premisa que existe una conexión de red definido en la letra Y a la siguiente ruta."
write-host
write-host " \\fscantv03\hostingwindows\Documentacion_Plataformas\Equipo02\VMWare\Operaciones\PowerCLI"
write-host
read-host "Pulse cualquier tecla para continuar"
################################### Definición de constantes #####################################
$ip_esxi_cnt = "10.1.192."
$mask_esxi_cnt = "255.255.255.0"
$gw_esxi_cnt = "10.1.192.1"
$dns1_cnt = "161.196.64.52"
$dns2_cnt = "161.196.64.53"	
$dom_cnt = "cantv.com.ve"
$ip_vmotion_cnt = ""
$mask_vmotion_cnt = ""

$ip_esxi_cha = ""
$mask_esxi_cha = "255.255.252.0"
$gw_esxi_cha = "10.120.8.1"
$dns1_cha = "200.44.32.12"
$dns2_cha = "200.44.32.13"	
$dom_cha = "ecom.cantv.net"

$num = 1
$date = get-date

################################### Principal ####################################################
New-Item y:\des\creacion\ks.txt -type file -force
cls
write-host
Add-Content y:\des\creacion\ks.txt "# --------------------------------------------------------------------------------------------------------------"
Add-Content y:\des\creacion\ks.txt "#  Archivo de respuesta para la instalación de un servidor ESXi de manera desatendida." 
Add-Content y:\des\creacion\ks.txt "#  Autor = Trabajo en conjunto entre Afina y Cantv." 
Add-Content y:\des\creacion\ks.txt "#  Comentarios y documentación = William Téllez." 
Add-Content y:\des\creacion\ks.txt "#  Fecha última modificación: $date" 
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "#  -------------------------------------------------------------------------------------------------------------" 
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "#  ----------------------------------------  COMANDOS PARA LA INSTALACIÓN  -------------------------------------" 
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Acepta la licencia VMware End User License Agreement" 
Add-Content y:\des\creacion\ks.txt "vmaccepteula" 
Add-Content y:\des\creacion\ks.txt " " 
$num++
Add-Content y:\des\creacion\ks.txt "# $num. Define el password para el usuario root para el esxi." 
$password = Read-host "Introduzca el password que se definirá para el root del servidor (enter para password por defecto: Cantv)"
write-host
Add-Content y:\des\creacion\ks.txt "rootpw $password" 
Add-Content y:\des\creacion\ks.txt " " 
$num++
Add-Content y:\des\creacion\ks.txt "# $num. Instalala sobre el primer disco local disponible, en nuestro caso sobre el virtual disk 0." 
Add-Content y:\des\creacion\ks.txt "install --firstdisk --overwritevmfs" 
Add-Content y:\des\creacion\ks.txt " " 
$num++
$dc = read-host "Introduzca el data center en el cual será instalado (cnt / cha)"
write-host
Add-Content y:\des\creacion\ks.txt "# $num. Define los parámetros de red:" 
Add-Content y:\des\creacion\ks.txt "#   $num.1. (--bootproto=static) define que la configuración será estática." 
Add-Content y:\des\creacion\ks.txt "#   $num.2. (--hostname=esxicnt10) define el nombre del host, este parámetro será construido con anterioridad." 
Add-Content y:\des\creacion\ks.txt "#   $num.3. (--device=vmnic0) el nombre de la nic en la cual configurará los parámetros de red. ya fueron pasados por parámetros y no estoy claro de que debe ser colocados de nuevo." 
Add-Content y:\des\creacion\ks.txt "#   $num.4. (--ip=10.1.192.110) define la dirección ip que tendrá el servidor esxi." 
Add-Content y:\des\creacion\ks.txt "#   $num.5. (--netmask=255.255.255.0) define la máscara del servidor." 
Add-Content y:\des\creacion\ks.txt "#   $num.6. (--gateway=10.1.192.1) define el gateway del servidor." 
Add-Content y:\des\creacion\ks.txt "#   $num.7. (--nameserver=161.196.64.52,161.196.64.53) configura los dns." 
Add-Content y:\des\creacion\ks.txt "#   $num.8. (--vlanid=200) define la vlan." 
Add-Content y:\des\creacion\ks.txt "#   $num.9. (--addvmportgroup=0) indica que la configuración anterior será asociada a un port group dentro del switch virtual que estará asociado a la vmnic0" 

#configuración de red para el data center de CNT
if ($dc -eq "cnt" -or $dc -eq "CNT")
{
	[int]$esxi = Read-host "Introduzca el número de ESXI que se instalará (1,2,3..n)"
	write-host
	if ([int]$esxi -lt 10)
	{
		$numesxi = "10$esxi"		
	}
	if ([int]$esxi -ge 10)
	{
		$numesxi = "1$esxi"		
	}
	Add-Content y:\des\creacion\ks.txt "network --bootproto=static --hostname=esxi$dc$numesxi --device=vmnic0 --ip=$ip_esxi_cnt$numesxi --netmask=$mask_esxi_cnt --gateway=$gw_esxi_cnt --nameserver=$dns1_cnt,$dns2_cnt --vlanid=200 --addvmportgroup=0" 
}

#configuración de red para el data center de Chacao.
if ($dc -eq "cha" -or $dc -eq "CHA")
{
	[int]$esxi = Read-host "Introduzca el número de ESXI que se instalará (1,2,3..n)"
	write-host
	$numesxi = $esxi
	Add-Content y:\des\creacion\ks.txt "network --bootproto=static --hostname=esxi$dc$numesxi --device=vmnic0 --ip=$ip_esxi_cha --netmask=$mask_esxi_cha --gateway=$gw_esxi_cha --nameserver=$dns1_cha,$dns2_cha --vlanid=200 --addvmportgroup=0"
}

Add-Content y:\des\creacion\ks.txt " " 
$num++
Add-Content y:\des\creacion\ks.txt "# $num. reinicia el servidor luego de que la instalación fue completada." 
Add-Content y:\des\creacion\ks.txt "reboot"  
Add-Content y:\des\creacion\ks.txt "# --------------------------------------------- FIN DE LA INSTALACIÓN -----------------------------------------------------------------------" 
Add-Content y:\des\creacion\ks.txt "# --------------------------------------------- INICIO DE LA CONFIGURACIÓN POST INSTALACIÓN  -------------------------------------------------" 
Add-Content y:\des\creacion\ks.txt " " 
$num++
Add-Content y:\des\creacion\ks.txt "# $num. ???????????????????" 
Add-Content y:\des\creacion\ks.txt "%firstboot --interpreter=busybox" 
Add-Content y:\des\creacion\ks.txt " " 
$num++
Add-Content y:\des\creacion\ks.txt "# $num. definición de la licencia vmware." 
write-host "La licencia que tenemos actualmente registrada es la siguiente: 7M03N-08150-08K4J-002U6-39XP0"
$Pre1 = Read-host "Si desea registrar la misma licencia pulse la letra (S/s), si desea incluir una nueva pulse la letra (N/n)"
write-host
if ($Pre1 -eq "s" -or $Pre1 -eq "S")
{
$lic = "7M03N-08150-08K4J-002U6-39XP0"
}

if ($Pre1 -eq "n" -or $Pre1 -eq "N")
{
$lic = Read-host "Introduzca la licencia a configurar:"
write-host
}
Add-Content y:\des\creacion\ks.txt "vim-cmd vimsvc/license --set $lic" 
Add-Content y:\des\creacion\ks.txt " " 
$num++
Add-Content y:\des\creacion\ks.txt "# $num. Deshabilita el protocolo IPv6 para las interfaces del vmkernel." 
Add-Content y:\des\creacion\ks.txt "esxcli system module parameters set -m tcpip3 -p ipv6=0" 
Add-Content y:\des\creacion\ks.txt " " 
$num++
Add-Content y:\des\creacion\ks.txt "# $num. Configura el nombre completo del host." 
if ($dc -eq "cnt" -or $dc -eq "CNT")
	{
	Add-Content y:\des\creacion\ks.txt "esxcli system hostname set –fqdn=esxi$dc$numesxi.$dom_cnt" 
	}
if ($dc -eq "cha" -or $dc -eq "CHA")
	{
	Add-Content y:\des\creacion\ks.txt "esxcli system hostname set –fqdn=esxi$dc$numesxi.$dom_cha" 
	}
Add-Content y:\des\creacion\ks.txt " " 
$num++
Add-Content y:\des\creacion\ks.txt "# $num. Configura el dominio del servidor." 
if ($dc -eq "cnt" -or $dc -eq "CNT")
	{
	Add-Content y:\des\creacion\ks.txt "esxcli network ip dns search add –domain=$dom_cnt" 
	}
if ($dc -eq "cha" -or $dc -eq "CHA")
	{
	Add-Content y:\des\creacion\ks.txt "esxcli network ip dns search add –domain=$dom_cha" 
	}
Add-Content y:\des\creacion\ks.txt " " 
$num++
Add-Content y:\des\creacion\ks.txt "# $num. Configura los dns, VALIDAR POR QUE HAY QUE DEFINIRLOS NUEVAMENTE." 
Add-Content y:\des\creacion\ks.txt "esxcli network ip dns server add –server=161.196.64.52" 
Add-Content y:\des\creacion\ks.txt "esxcli network ip dns server add –server=161.196.64.53" 
Add-Content y:\des\creacion\ks.txt " " 
$num++
Add-Content y:\des\creacion\ks.txt "# $num. Habilita el servicio de Update Manager. (en caso de necesitarse en el futuro)" 
Add-Content y:\des\creacion\ks.txt "#esxcli network firewall ruleset set –ruleset-id=`”updateManager`” –enabled yes" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Habilita el servicio de iSCSI. (en caso de necesitarse en el futuro)" 
Add-Content y:\des\creacion\ks.txt "#esxcli network firewall ruleset set –ruleset-id=`”iSCSI`” –enabled yes" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Habilita el servicio de ntp para sincronización del tiempo." 
Add-Content y:\des\creacion\ks.txt "esxcli network firewall ruleset set –ruleset-id=`”ntpClient`” –enabled yes" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Suprime el warning que da el esxi que tiene el ssh habilitado. (en caso de necesitarse en el futuro)" 
Add-Content y:\des\creacion\ks.txt "#esxcli system settings advanced set -o /UserVars/SuppressShellWarning -i 1" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt " # $num. Configura los parámetros NTP (tienen efecto después de reiniciar)" 
Add-Content y:\des\creacion\ks.txt "# ??investigar por que restrict default kod nomodify notrap noquerynopeer??" 
Add-Content y:\des\creacion\ks.txt "Add-Content y:\des\creacion\ks.txt restrict default kod nomodify notrap noquerynopeer > /etc/ntp.conf" 
Add-Content y:\des\creacion\ks.txt "Add-Content y:\des\creacion\ks.txt restrict 127.0.0.1 >> /etc/ntp.conf" 
Add-Content y:\des\creacion\ks.txt "Add-Content y:\des\creacion\ks.txt server 200.44.32.89>> /etc/ntp.conf" 
Add-Content y:\des\creacion\ks.txt "server 200.44.32.178 >> /etc/ntp.conf" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. investigar que hace la siguiente línea: driftfile /etc/ntp.drift" 
Add-Content y:\des\creacion\ks.txt "Add-Content y:\des\creacion\ks.txt driftfile /etc/ntp.drift >> /etc/ntp.conf" 
Add-Content y:\des\creacion\ks.txt "/sbin/chkconfig ntpd on" 
Add-Content y:\des\creacion\ks.txt "sleep 10" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Crea un nuevo vSwitch llamado vSwitch0" 
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard add -–vswitch-name=vSwitch0" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Crea un primer port group asociado a la vlan 204 en el vSwitch0" 
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard portgroup add -–portgroup-name=VLAN204 -–vswitch-name=vSwitch0" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Se asocia el port group creado el id 204." 
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard portgroup set --portgroup-name=VLAN204 --vlan-id=204" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Asocia el id 200 a el port group que se crea por defecto llamado Management Network." 
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard portgroup set --portgroup-name=Management Network --vlan-id=200" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Crea un nuevo y segundo vSwitch llamado vSwitch1" 
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard add --vswitch-name=vSwitch1" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Asocia el segundo vSwitch a la nic física llamada vmnic1." 
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard uplink add --uplink-name=vmnic1 --vswitch-name=vSwitch1" 
Add-Content y:\des\creacion\ks.txt "# Crea todos los port group necesarios para la operación sobre el vSwitch1, este listado debe" 
Add-Content y:\des\creacion\ks.txt "#  ser actualizado de manera automática para evitar que se desactualice." 
$Contenido = Get-Content y:\des\creacion\vlan.cfg
$archivo = "Y:\des\creacion\ks.txt"
foreach ($linea in $Contenido)
	{  
	   $linea | Add-Content $archivo
	}
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Se crea un tercer vswitch  llamado vSwitch2"  
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard add --vswitch-name=vSwitch2"  
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Asocia el tercer vSwitch a la nic física llamada vmnic2."  
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard uplink add --uplink-name=vmnic2 --vswitch-name=vSwitch2"  
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Crea un cuarto vSwitch a la nic física llamado vSwitch3" 
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard add --vswitch-name=vSwitch3" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Asocia el cuarto vSwitch a la nic física llamada vmnic3" 
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard uplink add --uplink-name=vmnic3 --vswitch-name=vSwitch3" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Crea un nuevo portgroup para vmotion en el vSwitch3" 
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard portgroup add --portgroup-name=VMotion --vswitch-name=vSwitch3"  
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Define el vlan id para el portgroup de vmotion." 
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard portgroup set --portgroup-name=VMotion --vlan-id=206"  
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num.  Define que el portgroup tendrá una configuración ip para su funcionamiento." 
Add-Content y:\des\creacion\ks.txt "esxcli network ip interface add --interface-name=vmk1 --portgroup-name=VMotion" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Define la configuración de red al portgroup de vmotion." 
Add-Content y:\des\creacion\ks.txt "esxcli network ip interface ipv4 set --interface-name=vmk1 --ipv4=10.1.193.210 --netmask=255.255.255.128 --type=static" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Habilita vMotion sobre el recien creado portgroup tipo vmkernel." 
Add-Content y:\des\creacion\ks.txt "vim-cmd hostsvc/vmotion/vnic_set VMotion" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Crea un quinto vSwitch que se utilizará para servidores que necesiten estar aislados." 
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard add --vswitch-name=vSwitch4" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Crea un portgroup en el vSwitch creado en el paso anterior y se asocian" 
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard portgroup add --portgroup-name=SinRed --vswitch-name=vSwitch4" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Se define un id a la vlan creada y se asocia al portgroup." 
Add-Content y:\des\creacion\ks.txt "esxcli network vswitch standard portgroup set --portgroup-name=SinRed --vlan-id=1010" 
$num++
Add-Content y:\des\creacion\ks.txt " " 
Add-Content y:\des\creacion\ks.txt "# $num. Renicia el equipo para que complete la configuración." 
Add-Content y:\des\creacion\ks.txt "sleep 30" 
Add-Content y:\des\creacion\ks.txt "reboot" 
write-host "El archivo resultante ks.cfg será copiado en la ruta donde se tiene configurado la carpeta compartida del ftp server."
[char]$resp = read-host "Por defecto la ruta es e:\ftp_server, pulse la tecla <C> para cambiarla o cualquier otra para aceptarla"
if ([char]$resp -eq "C" -or [char]$resp -eq "c")
	{
	$ruta = read-host "Introduzca la nueva ruta en la cual desea que se copie el archivo ks.cfg?"
	}
else
	{
	$ruta = "e:\ftp_server"
	}
$arch = $ruta + "\ks.cfg"
Remove-Item $ruta\ks.old
Remove-Item y:\des\creacion\ks.cfg
Rename-Item  y:\des\creacion\ks.txt ks.cfg
Rename-Item $arch ks.old
Copy-Item Y:\des\creacion\ks.cfg $ruta
cls
write-host "EL ARCHIVO DE INSTALACIÓN DESATENDIDA KS.CFG FUE CREADO SATISFACTORIAMENTE EN LA RUTA $ruta PARA SER UTILIZADO"
write-host
write-host "A continuación describiremos el procedimiento para generar un servidor ESXi de manera desatendida,"
write-host
write-host "a medida que vaya ejecutando los pasos pulse <Enter> para continuar con el siguiente, si desea salir pulse < Control C >."
write-host
$proc = read-host "Si tiene un nivel avanzado y desea saltarse el procedimiento para obtener de una vez el comando a ingresar pulse la tecla <E>, de lo contrario pulse cualquier otra letra"
write-host
if ($proc -ne "e" -or $proc -ne "E")
	{
	$i=1
	read-host "$i. Asegurarse de que el servidor físico a instalar no tenga vm´s ya que será formateado todo se perderá"
	write-host
	$i++
	read-host "$i. Ingrese al UCS Manager con su usuario y password"
	write-host
	$i++
	read-host "$i. Levante un KVM Console en el servidor que va a instalar"
	write-host
	$i++
	read-host "$i. Desde el KVM Console, seleccione desde el tab <KVM Console> y luego el sub-tab <virtual Media> para agregar el archivo .iso"
	write-host
	$i++
	read-host  "$i. Desde la session Virtual Media, agrege la imagen del instalador presionando <Add Image> "
	write-host
	$i++
	read-host "$i. Desde la session Virtual Media y una vez agregada la imagen el archivo .iso, marque el campo <Mapped>."
	write-host
	$i++
	read-host "$i. Desde el KVM Console, encienda el servidor seleccionando <Boot Server>, esté PENDIENTE cuando salga en la pantalla Press <F2> to enter setup, <F6> Boot Menu, <F12> Network Boot y pulsar la tecla <F6> para seleccionar el dispositivo de arranque"
	write-host
	$i++
	read-host "$i. Desde la ventana que solicita seleccionar el dispositivo de arranque <Please select boot device> seleccione Cisco Virtual CD/DVD"
	write-host
	$i++
	read-host "$i. Desde el menu de arranque del ESXi seleccione: <Esxi-[versión]-standard Instaler> y esté PENDIENTE que luego de pulsar <Enter> rápidamente aparecerá en la esquina inferior derecha el mensaje <SHIFT+O: Edit boot options>, cuando aparezca pulse Shift + la letra O"
	write-host
	$i++
	read-host "$i. Luego de pulsar Shift+O en la esquina inferior izquierda aparecerá un prompt con la palabra >runweasel, borrela hasta llegar al principio del prompt > "
	write-host
	$i++
	read-host "$i. Antes de proceder a escribir el comando de instalación, asegúrese de levantar el servidor ftp en su máquina, lo puede hacer instalando FileZilla Server"
	write-host
	$i++
	read-host "$i. Sería recomendable que hiciera una prueba de conectividad desde el command prompt haciendo un ftp hacia el servidor ftp y validándose."
	write-host
	$i++
	read-host "$i. Entendemos que el servidor ftp tiene configurado una carpeta o folder en la ruta e:\ftp_server o la ruta que se introdujo en la parte anterior a esta."
	write-host
	$i++
	read-host "$i. Verifique que tenga creado un usuario llamado <vmware>, <sin password> y que tenga habilitado el parámetro <Enable account>"
	write-host
	$i++
	read-host "$i. Mucha ATENCIÓN con el siguiente string de caracteres, de la exactitud depende que la instalación se ejecute sin dificultades"
	write-host
	$i++
	read-host "$i. Empiece escribiendo lo siguiente: > ks=ftp://vmware@                                                                       "
	write-host
	$i++
	$ipftp = read-host "$i. A continuación escriba la dirección ip donde está instalado el sofware FileZilla Server para ir construyendo el comando y seguidamente pulse <Enter>"
	write-host
	$i++
	read-host "$i. Luego de tener la dirección ip donde se encuentra FileZilla server, agregamos el nombre del archivo que creó este script y que ya se encuentra en la ruta $ruta con los parámetros necesarios para la instalación y configuración, pulse <Enter> para que vea como va quedando el comando"
	write-host
	$i++
	read-host "$i. > ks=ftp://vmware@$ipftp/ks.cfg                                                                                     "
	write-host
	$i++
	read-host "$i. Luego de un espacio, le daremos la ip de un servidor dns de la siguiente forma nameserver=nn.nn.nn.nn, <Enter> para ver como va el comando"
	write-host
	$i++
	read-host "$i. > ks=ftp://vmware@$ipftp/ks.cfg nameserver=161.196.64.52                                                              "
	write-host
	$i++
	read-host "$i. Luego de otro espacio, definiremos la configuración ip del ESXi, quedando el comando como sigue según los datos que fueron recibidos del script"
	write-host
	$i++
	if ($dc -eq "cnt" -or $dc -eq "CNT")
		{
		read-host "$i. > ks=ftp://vmware@$ipftp/ks.cfg nameserver=$dns1_cnt ip=$ip_esxi_cnt$numesxi netmask=$mask_esxi_cnt gateway=$gw_esxi_cnt                   "	
		}
	else
		{
		read-host "$i. > ks=ftp://vmware@$ipftp/ks.cfg nameserver=$dns1_cha ip=$ip_esxi_cha$numesxi netmask=$mask_esxi_cha gateway=$gw_esxi_cha                   "	
		}
	write-host
	$i++
	read-host "$i. Por último y luego de otro espacio agregar al comando que definirá en que nic física tendrá la configuración de red y que vlan, los últimos parámetros son: netdevice=vmnic0 vlanid=200 y al final el comando querdará como sigue"
	write-host
	cls
	write-host "> ks=ftp://vmware@$ipftp/ks.cfg nameserver=$dns1_cnt ip=$ip_esxi_cnt$numesxi netmask=$mask_esxi_cnt gateway=$gw_esxi_cnt netdevice=vmnic0 vlanid=200                                                                        "
	write-host
	$i++
	write-host "$i. Revise bien que lo que escribió que esté igual al comando arriba, después de revisar pulse <Enter> y en minutos tendrá el servidor instalado y configurado."
	write-host
	}
else
	{
	cls
	write-host
	write-host "> ks=ftp://vmware@[ipftpserver]/ks.cfg nameserver=[ip_dns] ip=[ip_esxi] netmask=[ip_mask] gateway=[ip_gateway] netdevice=vmnic0 vlanid=200"
	write-host	
	write-host "Ejemplo: "
	write-host "> ks=ftp://vmware@161.196.54.57/ks.cfg nameserver=161.196.64.52 ip=10.1.192.110 netmask=255.255.255.0 gateway=10.1.192.1 netdevice=vmnic0 vlanid=200"
	}	
	