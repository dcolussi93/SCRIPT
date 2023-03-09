#Crear Carpetas
New-Item -ItemType Directory -Force "./DATAEXPORT"

$x = Login-DataGatewayServiceAccount

$scriptsList = @(
    'script1.ps1'
)
foreach( $script in $scriptsList) {
    write-host "(*) $script"
    Invoke-Expression "./DATASOURCE/$script"
}

