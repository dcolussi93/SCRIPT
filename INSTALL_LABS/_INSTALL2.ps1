## DEFINICION DE RUTAS DE APLICACIONES....
write-host "`n`nEjecutando Script en server $env:COMPUTERNAME"

#ARCHIVO DE CONFIGURACION
$config=Get-Content -Path .\_config.json -Raw | ConvertFrom-Json

#Ruta de Origen
$carpeta = $config.localFolder
#$installers =  @("PBIDesktopSetup_x64.exe","SSMS-Setup-ENU.exe")
$installers = $config.installer.name
$destino_temp = $config.destino_temp

## DEFINICION DE LABS DONDE SE VA A INSTALAR ...
#Consultar Lista de equipos/Labs en los que se va a instalar.
#$labs = @(Get-ADComputer -Filter 'Name -like "LABTNSARWBI*"' | Select -Expand Name)

$labs = @('LABTNSARWBI42','LABTNSARWBI100')
#Si está definida la configuracion manual, tomar los equipos de ahí y pisar.
if($config.labs_custom){
    $labs = $config.labs  
}
write-host "(*) SE INTENTA EJECUTAR EN: $labs"

#Testear conexion a los Labs.
$labDisponibles = @()
foreach ($lab in $labs ) {
    if((Test-Connection $lab -Count 1 -Quiet)){
        $labDisponibles += $lab
    }
}
write-host "(*) Labs Disponibles: $labDisponibles"

#PROCESO DE INSTALACION

#Iterar Sobre Los Labs
foreach ( $lab in $labDisponibles ) {
    
    #iterar Sobre los softwares a instalar
    foreach ($exe in $installers) {
        
        write-host "`n$lab"  
        write-host "(*) Instalacion $lab software: $exe"    

        $origen_pathcompleto = "$carpeta\$exe"
        
        #Carpeta de Instalacion en el Lab
        $carpetaLab = "\\$lab\$destino_temp"
        $carpetaLabCompleta = "$carpetaLab\$exe"
        
        #Creacion carpeta Temp si no existe
        if ( !(Test-Path -path $carpetaLab ) ) {
            New-Item $carpetaLab -Type Directory
            write-host "(*) Creando Carpeta Temp  $origen_pathcompleto a $carpetaLab"
        }
        
        #Copiar Instalador y ejecutar la instalacion.
        write-host "(*) Copiando $origen_pathcompleto a $carpetaLab"
        Copy-Item -Path $((Get-Item -Path $origen_pathcompleto).FullName) -Destination $carpetaLab -Force 
                        
        #Proceso para Instalar
        write-host "(*) Instalando $carpetaLabCompleta en $lab"
        $arg = $config.arg_install
        write-host "(*) Argumentos: $arg en $lab"
        Invoke-Command -ComputerName $lab {Start-Process -FilePath $using:carpetaLabCompleta -Wait -ArgumentList $using:arg }
        
    }
    write-host "(*) INSTALACION COMPLETA $installers en $lab"
    
    #Restart Lab al finalizar Instalaciones: Consultar si hay que reiniciar el lab
    if ($env:COMPUTERNAME -ne $lab) {
        write-host "(*) Restart $lab que NO es $env:COMPUTERNAME"
        $pathvargs = [Scriptblock]::Create($config.arg_restart)
        if($config.restart_lab){
            Invoke-Command -ComputerName $lab -ScriptBlock $pathvargs
        }    
    }

}
write-host "`n`nFIN PROCESO."

##Restart Este Server.
#$pathvargs = {restart-computer -force}
#if ($env:COMPUTERNAME -ne $lab) {

#Restart Server 
if ($config.restart_server){
    write-host "(*) Restart $env:COMPUTERNAME"
    $pathvargs = [Scriptblock]::Create($config.arg_restart)
    Invoke-Command -ComputerName $env:COMPUTERNAME -ScriptBlock $pathvargs
}