#Logearse
Invoke-Expression ".\_login.ps1"

write-host "GENERACION REPORTES DE USO POWER BI SERVICES:"

#Crear directorio
New-Item -ItemType Directory -Force "./DATAEXPORT"
New-Item -ItemType Directory -Force "./DATAEXPORT/EVENTS"

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
    Invoke-Expression "./DATASOURCE/$script"
}

#Procesamiento INFO
$scriptsList = @(
    'EventHistorical.ps1'
)
write-host "(*) PROCESAMIENTO"
foreach( $script in $scriptsList) {
    write-host "(*) $script"
    Invoke-Expression "./PROCESS/$script"
}

write-host "FIN SCRIPT"