## SCRIPT PARA DESCARGAR LAS ULTIMAS APLICACIONES.....
$config=Get-Content -Path .\_config.json -Raw | ConvertFrom-Json
# ConvertFrom-Json is only available by default in PSv3 and up 
$carpeta = $config.localFolder
mkdir $carpeta -Force

#PROCESO DE DESCARGA DE INSTALADORES
foreach($exe in $config.installer){
    $source = $exe.link
    $name = $exe.name
    $destination = "$carpeta\$name"
    Write-Host "* Descargando $source en $carpeta"
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls,Tls11,Tls12'
    Invoke-WebRequest -Uri $source -OutFile $destination -UseBasicParsing
    Write-Host "OK"
}
