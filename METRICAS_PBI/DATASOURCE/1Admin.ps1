#Seccion Microsoft MicrosoftPowerBIMgmt.Admin

# Archivo de configuracion
$config = Get-Content -Path .\config.json -Raw | ConvertFrom-Json
$prefijo = $config.export+"/"+$config.prefijo

write-host "(*) Admin:"

$x = Get-PowerBIWorkspace -Scope Organization | Get-PowerBIWorkspaceEncryptionStatus
$file = $prefijo+"PowerBIWorkspaceEncryptionStatus.json"
( $x | ConvertTo-Json -Depth 4 )>$file

# Exportar Eventos
$f_inicio = (Get-Date -Format "yyyy-MM-dd")+"T00:01:00"
$f_fin= (Get-Date -Format "yyyy-MM-dd")+"T23:59:00"
$fech = (Get-Date -Format "yyyyMMdd")
<#
$f_inicio = "2023-01-11T00:01:00"
$f_fin= "2023-01-11T23:59:00"
$fech = "20230111"
#>
$events = Get-PowerBIActivityEvent -StartDateTime $f_inicio -EndDateTime $f_fin
$events = ConvertFrom-Json $events

# Expcluir eventos del tipo ExportActivityEvents y GetAdmin etc.
$event_filter =  @()
$event_nofilter =  @()

foreach($e in $events){
    if( ($e.Operation -ne "ExportActivityEvents") -and ($e.Operation -notlike "Get*") ) {
        $event_filter += $e
    }else{
        $event_nofilter+=$e
    }
}
# Guardar en archivo Json Eventos
$file = $prefijo+"PowerBIActivityEvent.json"
( $event_filter | ConvertTo-Json -Depth 4 )>$file

#Guardar Historico Diario Carpeta Ejecucion
$file = $file = $config.export_event+"/"+$fech+"_PowerBIActivityEvent.json"
( $event_filter | ConvertTo-Json -Depth 4 )>$file

# Eventos Ignorados
$file = $prefijo+"PowerBIActivityEvent_exclude.json"
( $event_filter | ConvertTo-Json -Depth 4 )>$file
