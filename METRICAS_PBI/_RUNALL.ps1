$config = Get-Content -Path .\config.json -Raw | ConvertFrom-Json
$datasource = $config.datasource

#Logearse
Invoke-Expression ".\_login.ps1"

write-host "GENERACION REPORTES DE USO POWER BI SERVICES:"

#Crear directorio
New-Item -ItemType Directory -Force $config.export

#Buscar Datasources de log
$scriptsList = @(
    '1Admin.ps1',
    '2Capacities.ps1',
    '3Data.ps1',
    '4Profile.ps1',
    '5Reports.ps1',
    '6Workspaces.ps1'
)
foreach( $script in $scriptsList) {
    write-host "(*) $script"
    Invoke-Expression "$datasource/$script"
}

write-host "FIN SCRIPT"