############################################################
# script que define afinidad a nivel de storage.
# Autor: William Téllez
# Modificación del código generado previamente por:
# SAPIEN Technologies PrimalForms (Community Edition) v1.0.3.0
# fecha inicio: 19/02/2013
# fecha última versión: 20/02/2013
############################################################

param ($vc)

function GeneraForma ($vc)
{
	#region Import the Assemblies
	[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
	[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
	#endregion

	# Generación de los objetos que tendrá la forma
	# forma
	$form1 = New-Object System.Windows.Forms.Form
	# botones
	$button1 = New-Object System.Windows.Forms.Button
	$button2 = New-Object System.Windows.Forms.Button
	$button3 = New-Object System.Windows.Forms.Button
	$button4 = New-Object System.Windows.Forms.Button
	$button5 = New-Object System.Windows.Forms.Button
	$button6 = New-Object System.Windows.Forms.Button
	# etiquetas.
	$label1 = New-Object System.Windows.Forms.Label
	#$label2 = New-Object System.Windows.Forms.Label
	$label3 = New-Object System.Windows.Forms.Label
	$label4 = New-Object System.Windows.Forms.Label
	#$label5 = New-Object System.Windows.Forms.Label
	# caja de listas.
	$checkedListBox1 = New-Object System.Windows.Forms.CheckedListBox
	#$checkedListBox2 = New-Object System.Windows.Forms.CheckedListBox
	$checkedListBox3 = New-Object System.Windows.Forms.CheckedListBox
	#$checkedListBox4 = New-Object System.Windows.Forms.CheckedListBox
	
	# Caja de texto
	$textBox1 = New-Object System.Windows.Forms.TextBox
	# etiqueta que tiene un link hacia una página web
	$linkLabel1 = New-Object System.Windows.Forms.LinkLabel
	# inicializador de la ventana de la forma.
	$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
	
	
	Set-ExecutionPolicy Unrestricted
	$user = Read-Host "Introduzca el nombre del usuario"
	$pass = Read-Host "Introduzca la Contraseña" -assecurestring
	$decode = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))
	Connect-VIServer -Server $vc -User $user -Password $decode

	#################################################################################################
	######################## Bloques que definen cada objeto creado. ################################
	#################################################################################################
	
	##################################################################################################
	# Definición del manejador del evento cuando se hace clicn en 
	# el botón 1 que hace login al servidor vcenter y obtiene de una
	# vez todos las vm´s
	$handler_button1_Click= 
	{
		if ((Get-PSSnapin "VMware.VimAutomation.Core" -ErrorAction SilentlyContinue) -eq $null) 
			{
			Add-PSSnapin "VMware.VimAutomation.Core"
			} 

		#Connect to vCenter
		# conexión al vcenter server.
		#Connect-VIServer $textBox1.Text 
		
		#[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
		#[System.Windows.Forms.MessageBox]::Show("Necesitamos que introduzca sus credenciales en la consola de power cli")
		
		#Set-ExecutionPolicy Unrestricted
		#$user = Read-Host "Introduzca el nombre del usuario"
		#$pass = Read-Host "Introduzca la Contraseña" -assecurestring
		#$decode = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))
		#Connect-VIServer -Server $textBox1.Text -User $user -Password $decode

		# Get VM's
		# Obtiene todas las vm´s del vcenter server.
		Get-VM | % { [void]$checkedListBox1.items.add($_.Name) }

		#Get VMHost (ESX Servers)
		# renombrado por wt. Get-VMHost | % { [void]$checkedListBox2.items.add($_.Name) }


		$OnLoadForm_StateCorrection=
		{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$form1.WindowState = $InitialFormWindowState
		}
	}

	#  fin del manejador del evento click.
	#####################################################################################################
	

	#################################################################################################
	# manejo del evento click del botón #2, llamado <afinidad> el cual la define.

	$button2_OnClick= 
	{
		foreach($vm in $checkedListBox3.CheckedItems)
		{				
			$valor = "11"				
			Get-Vm -name $vm | Set-CustomField -Name DRStorage -Value $valor
		}
			# Mensaje de que la acción fue establecida.
			[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
			[System.Windows.Forms.MessageBox]::Show("La regla de afinidad de las vm´s seleccionadas fueron establecidas para estar en data store separados")

		$checkedListBox3.Items.Clear()
		$checkedListBox4.Items.Clear()

		[bool]$selected = $false
		for ($i = 0; $i -lt $checkedListBox1.Items.Count; $i++) { 
			$checkedListBox1.SetItemChecked( $i, $selected ) 
		} 

		[bool]$selected = $false
		for ($i = 0; $i -lt $checkedListBox2.Items.Count; $i++) { 
			$checkedListBox2.SetItemChecked( $i, $selected ) 
		} 	
	}

	# fin evento click del botón #2 de afinidad.
	##################################################################################################
	

	#################################################################################################
	# Manejo del evento click del botón #3,  que toma las vm´s marcadas y las pasa a la caja de texto
	# siguiente para que el usuario revise y defina la afinidad.
	
	$button3_OnClick= 
	{
	
		# Busca en todo las vm´s aquellas que el usuario haya marcado
		# y los agrega a la caja de lista # 3
		foreach($vmname in $checkedListBox1.CheckedItems)
		{
			$checkedListBox3.Items.Add($vmname)
		}
		
		# no se necesita
		#foreach($vmhostname in $checkedListBox2.CheckedItems)
		#{
		#	$checkedListBox4.Items.Add($vmhostname)
		#}
		
		# 
		
		# Una vez traspasada las vm´s a la caja de lista marcable #3
		# las marca ya que por defecto vienen desmarcadas.
		[bool]$selected = $true
		for ($i = 0; $i -lt $checkedListBox3.Items.Count; $i++) 
		{ 
			$checkedListBox3.SetItemChecked( $i, $selected ) 
		} 

		# no se necesita.
		#[bool]$selected = $true
		#for ($i = 0; $i -lt $checkedListBox4.Items.Count; $i++) { 
		#	$checkedListBox4.SetItemChecked( $i, $selected ) 
		#} 
	}
	
	# fin del manejo del evento click del botón # 3
	##################################################################################################
	
	##################################################################################################
	# Definición del manejador del evento cuando se hace click al botón #4 de terminar

	$button4_OnClick= 
	{	
		# Incluir la validación si está conectado al vcenter para que la desconexión no de un error.
		
		#Disconnect from vCenter server
		# Se desconecta del vcenter
		Disconnect-VIServer -Confirm:$false
		
		
		#Close Form
		# cierra la forma.
		$form1.close()
	}

	# fin manejador de evento de click del botón Terminar
	###################################################################################################
	
	#################################################################################################
	# manejo del evento click del botón #2, llamado <afinidad> el cual la define.

	$button5_OnClick= 
	{
		foreach($vm in $checkedListBox3.CheckedItems)
		{				
			$valor = "10"				
			Get-Vm -name $vm | Set-CustomField -Name DRStorage -Value $valor
		}
			# Mensaje de que la acción fue establecida.
			[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
			[System.Windows.Forms.MessageBox]::Show("La regla de afinidad de las vm´s seleccionadas fueron establecidas para estar juntas en un mismo data store")

		$checkedListBox3.Items.Clear()
		$checkedListBox4.Items.Clear()

		[bool]$selected = $false
		for ($i = 0; $i -lt $checkedListBox1.Items.Count; $i++) { 
			$checkedListBox1.SetItemChecked( $i, $selected ) 
		} 

		[bool]$selected = $false
		for ($i = 0; $i -lt $checkedListBox2.Items.Count; $i++) { 
			$checkedListBox2.SetItemChecked( $i, $selected ) 
		} 	
	}

	# fin evento click del botón #5 de afinidad.
	##################################################################################################
	
	#################################################################################################
	# manejo del evento click del botón #2, llamado <afinidad> el cual la define.

	$button6_OnClick= 
	{
		foreach($vm in $checkedListBox3.CheckedItems)
		{				
			$valor = ""
			Get-Vm -name $vm | Set-CustomField -Name DRStorage -Value $valor
		}
			# Mensaje de que la acción fue establecida.
			[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
			[System.Windows.Forms.MessageBox]::Show("La regla de afinidad fue eliminada exitosamente")

		$checkedListBox3.Items.Clear()
		$checkedListBox4.Items.Clear()

		[bool]$selected = $false
		for ($i = 0; $i -lt $checkedListBox1.Items.Count; $i++) { 
			$checkedListBox1.SetItemChecked( $i, $selected ) 
		} 

		[bool]$selected = $false
		for ($i = 0; $i -lt $checkedListBox2.Items.Count; $i++) { 
			$checkedListBox2.SetItemChecked( $i, $selected ) 
		} 	
	}

	# fin evento click del botón #5 de afinidad.
	##################################################################################################

	

	#############################################################
	# Configuración de la forma

	$form1.Text = 'Storage DRS afinity'
	$form1.Name = 'form1'
	$form1.DataBindings.DefaultDataSourceUpdateMode = 0
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 507
	$System_Drawing_Size.Height = 595
	$form1.ClientSize = $System_Drawing_Size

	############################################################

	#####################################################################
	# Botón #1 que hace el login al servidor que se introdujo en la caja
	# de texto #1 y que usa como parámetro.

	$button1.TabIndex = 0
	$button1.Name = 'button1'
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 75
	$System_Drawing_Size.Height = 23
	$button1.Size = $System_Drawing_Size
	$button1.UseVisualStyleBackColor = $True

	$button1.Text = 'Login'

	$System_Drawing_Point = New-Object System.Drawing.Point
	$System_Drawing_Point.X = 264
	$System_Drawing_Point.Y = 12
	$button1.Location = $System_Drawing_Point
	$button1.DataBindings.DefaultDataSourceUpdateMode = 0
	$button1.add_Click($handler_button1_Click)

	$form1.Controls.Add($button1)

	# fin del botón #1
	########################################################################

	#################################################################
	# botón #2 la cual hace que se defina la regla de afinidad 
	# de separación entre las vm´s seleccionadas.

	$button2.TabIndex = 7
	$button2.Name = 'button2'
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 150
	$System_Drawing_Size.Height = 23
	$button2.Size = $System_Drawing_Size
	$button2.UseVisualStyleBackColor = $True

	$button2.Text = 'Regla: vm separadas'

	$System_Drawing_Point = New-Object System.Drawing.Point
	$System_Drawing_Point.X = 300 #13
	$System_Drawing_Point.Y = 250 #554
	$button2.Location = $System_Drawing_Point
	$button2.DataBindings.DefaultDataSourceUpdateMode = 0
	$button2.add_Click($button2_OnClick)

	$form1.Controls.Add($button2)

	# fin del botón # 2, establece la afinidad.
	################################################################
	
	#############################################################
	# Botón #3 que selecciona las vms marcadas en el listado de
	# todas la vm´s para establecer afinidad a nivel de storage.

	$button3.TabIndex = 9
	$button3.Name = 'button3'
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 150
	$System_Drawing_Size.Height = 23
	$button3.Size = $System_Drawing_Size
	$button3.UseVisualStyleBackColor = $True

	$button3.Text = 'Seleccionar'

	$System_Drawing_Point = New-Object System.Drawing.Point
	$System_Drawing_Point.X = 300 #200
	$System_Drawing_Point.Y = 200 #554

	$button3.Location = $System_Drawing_Point
	$button3.DataBindings.DefaultDataSourceUpdateMode = 0
	$button3.add_Click($button3_OnClick)

	$form1.Controls.Add($button3)

	# fin botón # 3.
	###############################################################
	
	############################################################
	# Configuración del botón número 4 <Terminar>

	$button4.TabIndex = 19
	$button4.Name = 'button4'
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 150
	$System_Drawing_Size.Height = 23
	$button4.Size = $System_Drawing_Size
	$button4.UseVisualStyleBackColor = $True

	$button4.Text = 'Terminar'

	$System_Drawing_Point = New-Object System.Drawing.Point
	$System_Drawing_Point.X = 300 #418
	$System_Drawing_Point.Y = 400 #554
	$button4.Location = $System_Drawing_Point
	$button4.DataBindings.DefaultDataSourceUpdateMode = 0
	$button4.add_Click($button4_OnClick)

	$form1.Controls.Add($button4)

	# fin de la configuración del botón 4 <Terminar>
	#########################################################
	
	#################################################################
	# botón #5 la cual hace que se defina la afinidad entre las vm´s
	# seleccionadas.
	# falta programar este botón mejor.

	$button5.TabIndex = 29
	$button5.Name = 'button5'
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 150
	$System_Drawing_Size.Height = 23
	$button5.Size = $System_Drawing_Size
	$button5.UseVisualStyleBackColor = $True

	$button5.Text = 'Regla: vm juntas'

	$System_Drawing_Point = New-Object System.Drawing.Point
	$System_Drawing_Point.X = 300 #12
	$System_Drawing_Point.Y = 300 #525
	$button5.Location = $System_Drawing_Point
	$button5.DataBindings.DefaultDataSourceUpdateMode = 0
	$button5.add_Click($button5_OnClick)

	$form1.Controls.Add($button5)

	# fin del botón # 5, establece la afinidad.
	################################################################
	
	#################################################################
	# botón #6 la cual elimina la afinidad entre las vm´s.
	
	$button6.TabIndex = 30
	$button6.Name = 'button6'
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 150
	$System_Drawing_Size.Height = 23
	$button6.Size = $System_Drawing_Size
	$button6.UseVisualStyleBackColor = $True

	$button6.Text = 'Eliminar Afinidad'

	$System_Drawing_Point = New-Object System.Drawing.Point
	$System_Drawing_Point.X = 300
	$System_Drawing_Point.Y = 350
	$button6.Location = $System_Drawing_Point
	$button6.DataBindings.DefaultDataSourceUpdateMode = 0
	$button6.add_Click($button6_OnClick)

	$form1.Controls.Add($button6)

	# fin del botón # 6, eliminar la afinidad.
	################################################################
	
	#################################################################
	# Etiqueta #1 que indica al usuario que coloque el vcenter server

	$label1.TabIndex = 2
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 87
	$System_Drawing_Size.Height = 23
	$label1.Size = $System_Drawing_Size
	$label1.Text = 'vCenter Server:'

	$System_Drawing_Point = New-Object System.Drawing.Point
	$System_Drawing_Point.X = 13
	$System_Drawing_Point.Y = 12
	$label1.Location = $System_Drawing_Point
	$label1.DataBindings.DefaultDataSourceUpdateMode = 0
	$label1.Name = 'label1'

	$form1.Controls.Add($label1)

	# fin etiqueta # 1
	####################################################################
	
	################################################################
	# Etiqueta #2 que muestra el texto de <ESX disponibles>
	# Suprimiremos esta equiteta ya que no la necesitaremos.

	#$label2.TabIndex = 4
	#$System_Drawing_Size = New-Object System.Drawing.Size
	#$System_Drawing_Size.Width = 88
	#$System_Drawing_Size.Height = 351
	#$label2.Size = $System_Drawing_Size
	#$label2.Text = 'Destination:'

	#$System_Drawing_Point = New-Object System.Drawing.Point
	#$System_Drawing_Point.X = 324
	#$System_Drawing_Point.Y = 59
	#$label2.Location = $System_Drawing_Point
	#$label2.DataBindings.DefaultDataSourceUpdateMode = 0
	#$label2.Name = 'label2'

	#$form1.Controls.Add($label2)

	# fin etiqueta # 2
	###############################################################
	
	################################################################
	# Etiqueta #3 que muestra el texto de <ESX seleccionadas>

	$label3.TabIndex = 6
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 100
	$System_Drawing_Size.Height = 23
	$label3.Size = $System_Drawing_Size
	$label3.Text = 'Seleccionar VM''s'

	$System_Drawing_Point = New-Object System.Drawing.Point
	$System_Drawing_Point.X = 73
	$System_Drawing_Point.Y = 59
	$label3.Location = $System_Drawing_Point
	$label3.DataBindings.DefaultDataSourceUpdateMode = 0
	$label3.Name = 'label3'

	$form1.Controls.Add($label3)

	# fin etiqueta # 3
	#################################################################
	
	#############################################################
	# Etiqueta #4 que muestra el texto de <ESX seleccionadas>

	$label4.TabIndex = 11
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 150
	$System_Drawing_Size.Height = 23
	$label4.Size = $System_Drawing_Size
	$label4.Text = 'VMs seleccionadas'

	$System_Drawing_Point = New-Object System.Drawing.Point
	$System_Drawing_Point.X = 324
	$System_Drawing_Point.Y = 59
	$label4.Location = $System_Drawing_Point
	$label4.DataBindings.DefaultDataSourceUpdateMode = 0
	$label4.Name = 'label4'

	$form1.Controls.Add($label4)

	# fin etiqueta # 4
	#################################################################
	
	#############################################################
	# Etiqueta #5 que muestra el texto de <ESX seleccionadas>
	# Suprimiremos esta equiteta ya que no la necesitaremos.

	#$label5.TabIndex = 13
	#$System_Drawing_Size = New-Object System.Drawing.Size
	#$System_Drawing_Size.Width = 100
	#$System_Drawing_Size.Height = 23
	#$label5.Size = $System_Drawing_Size
	#$label5.Text = 'Selected ESX Host'

	#$System_Drawing_Point = New-Object System.Drawing.Point
	#$System_Drawing_Point.X = 324
	#$System_Drawing_Point.Y = 398
	#$label5.Location = $System_Drawing_Point
	#$label5.DataBindings.DefaultDataSourceUpdateMode = 0
	#$label5.Name = 'label5'

	#$form1.Controls.Add($label5)

	# fin etiqueta # 5
	################################################################
	
	##################################################################
	# Caja de listado #1 que muestra las vm´s disponibles para 
	# habilitar la afinidad.

	$checkedListBox1.FormattingEnabled = $True
	$checkedListBox1.CheckOnClick = $True
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 232
	$System_Drawing_Size.Height = 500
	$checkedListBox1.Size = $System_Drawing_Size
	$checkedListBox1.DataBindings.DefaultDataSourceUpdateMode = 0
	$checkedListBox1.Name = 'checkedListBox1'
	$System_Drawing_Point = New-Object System.Drawing.Point
	$System_Drawing_Point.X = 12
	$System_Drawing_Point.Y = 85
	$checkedListBox1.Location = $System_Drawing_Point
	$checkedListBox1.MultiColumn = $false
	$checkedListBox1.TabIndex = 5
	$checkedListBox1.Sorted = $True

	$form1.Controls.Add($checkedListBox1)

	# fin caja de listado # 1
	##################################################################
	
	###############################################################
	# Caja de listado que muestra las esx / esxi disponible.
	# Suprimiremos esta equiteta ya que no la necesitaremos.

	#$checkedListBox2.FormattingEnabled = $True
	#$checkedListBox2.CheckOnClick = $True
	#$System_Drawing_Size = New-Object System.Drawing.Size
	#$System_Drawing_Size.Width = 232
	#$System_Drawing_Size.Height = 304
	#$checkedListBox2.Size = $System_Drawing_Size
	#$checkedListBox2.DataBindings.DefaultDataSourceUpdateMode = 0
	#$checkedListBox2.Name = 'checkedListBox2'
	#$System_Drawing_Point = New-Object System.Drawing.Point
	#$System_Drawing_Point.X = 261
	#$System_Drawing_Point.Y = 85
	#$checkedListBox2.Location = $System_Drawing_Point
	#$checkedListBox2.Sorted = $True
	#$checkedListBox2.TabIndex = 8

	#$form1.Controls.Add($checkedListBox2)

	# fin listado #2.
	#################################################################
	
	#################################################################
	# Caja de lista marcable #3 que muestra las vm´s seleccionadas.
	# Incluir la validación de que nada más sean dos las vm´s.

	$checkedListBox3.FormattingEnabled = $True
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 232
	$System_Drawing_Size.Height = 94
	$checkedListBox3.Size = $System_Drawing_Size
	$checkedListBox3.DataBindings.DefaultDataSourceUpdateMode = 0
	$checkedListBox3.Name = 'checkedListBox3'
	$System_Drawing_Point = New-Object System.Drawing.Point	
	
	$System_Drawing_Point.X = 261
	$System_Drawing_Point.Y = 85
	$checkedListBox3.Location = $System_Drawing_Point
	$checkedListBox3.Sorted = $True
	$checkedListBox3.TabIndex = 15

	$form1.Controls.Add($checkedListBox3)

	# fin etiqueta # 3, vm´s seleccionadas.
	###############################################################
	
	#################################################################
	# Caja de lista marcable número 4 que muestra los esx seleccionados.
	# Suprimiremos esta equiteta ya que no la necesitaremos.
	#$checkedListBox4.FormattingEnabled = $True
	#$System_Drawing_Size = New-Object System.Drawing.Size
	#$System_Drawing_Size.Width = 232
	#$System_Drawing_Size.Height = 94
	#$checkedListBox4.Size = $System_Drawing_Size
	#$checkedListBox4.DataBindings.DefaultDataSourceUpdateMode = 0
	#$checkedListBox4.Name = 'checkedListBox4'
	#$System_Drawing_Point = New-Object System.Drawing.Point
	#$System_Drawing_Point.X = 261
	#$System_Drawing_Point.Y = 413
	#$checkedListBox4.Location = $System_Drawing_Point
	#$checkedListBox4.Sorted = $True
	#$checkedListBox4.TabIndex = 16

	#$form1.Controls.Add($checkedListBox4)

	# fin caja de lista marcable # 4, esx seleccionadas.
	#############################################################

	#################################################################
	# Configuración de la etiqueta de link #1 que muestra el autor.
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 84
	$System_Drawing_Size.Height = 23
	$linkLabel1.Size = $System_Drawing_Size
	$linkLabel1.TabIndex = 17
	$linkLabel1.Text = 'CSTS-Windows'
	$System_Drawing_Point = New-Object System.Drawing.Point
	$System_Drawing_Point.X = 411
	$System_Drawing_Point.Y = 15
	$linkLabel1.Location = $System_Drawing_Point
	$linkLabel1.TabStop = $True
	$linkLabel1.DataBindings.DefaultDataSourceUpdateMode = 0
	$linkLabel1.Name = 'linkLabel1'

	$form1.Controls.Add($linkLabel1)

	# fin de la etiqueta de link #1, autor.
	#################################################################



	###################################################################
	# caja de texto #1 que permite que el usuario introduzca el nombre
	# del servidor de vcenter.

	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Width = 152
	$System_Drawing_Size.Height = 20
	$textBox1.Size = $System_Drawing_Size
	$textBox1.DataBindings.DefaultDataSourceUpdateMode = 0
	$textBox1.Name = 'textBox1'
	$System_Drawing_Point = New-Object System.Drawing.Point
	$System_Drawing_Point.X = 106
	$System_Drawing_Point.Y = 12
	$textBox1.Location = $System_Drawing_Point
	$textBox1.TabIndex = 1

	$form1.Controls.Add($textBox1)

	# fin caja de texto #1
	#####################################################################




	# Salva el estado inicial de la forma creada con sus botones, 
	# textos, cajas, etc.
	$InitialFormWindowState = $form1.WindowState

	# Inicia el evento OnLoad
	$form1.add_Load($OnLoadForm_StateCorrection)


	# Muestra la forma ya construida
	$form1.ShowDialog()| Out-Null

} # Fin de la función.

# Se llama a la función para que genere la forma completa.
GeneraForma ($vc)