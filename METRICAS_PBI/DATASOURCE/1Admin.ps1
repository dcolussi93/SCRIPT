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
$f_fin= (Get-Date -Format "yyyy-MM-dd")+"T23:01:00"
$events = Get-PowerBIActivityEvent -StartDateTime $f_inicio -EndDateTime $f_fin
$events = ConvertFrom-Json $events
<#
$ev =  @()
$events = Get-PowerBIActivityEvent -StartDateTime "2023-01-08T00:01:00" -EndDateTime "2023-01-08T23:01:00"
$events = ConvertFrom-Json $events
$ev += $events
$events = Get-PowerBIActivityEvent -StartDateTime "2023-01-09T00:01:00" -EndDateTime "2023-01-09T23:59:00"
$events = ConvertFrom-Json $events
$ev += $events
$events = Get-PowerBIActivityEvent -StartDateTime "2023-01-10T00:01:00" -EndDateTime "2023-01-10T23:59:00"
$events = ConvertFrom-Json $events
$ev += $events
$events = Get-PowerBIActivityEvent -StartDateTime "2023-01-11T00:01:00" -EndDateTime "2023-01-11T23:59:00"
$events = ConvertFrom-Json $events
$ev += $events
$events = Get-PowerBIActivityEvent -StartDateTime "2023-01-12T00:01:00" -EndDateTime "2023-01-12T23:59:00"
$events = ConvertFrom-Json $events
$ev += $events
$events = Get-PowerBIActivityEvent -StartDateTime "2023-01-13T00:01:00" -EndDateTime "2023-01-13T23:59:00"
$events = ConvertFrom-Json $events
$ev += $events

$events = $ev
#>

# Expcluir eventos del tipo ExportActivityEvents
$event_filter =  @()
$event_nofilter =  @()

foreach($e in $events){
    if( ($e.Operation -ne "ExportActivityEvents") -and ($e.Operation -notlike "Get*") ) {
        $event_filter += $e
    }else{
        $event_nofilter+=$e
    }
}
# Guardar en archivo Json
$file = $prefijo+"PowerBIActivityEvent.json"
( $event_filter | ConvertTo-Json -Depth 4 )>$file

$file = $prefijo+"PowerBIActivityEvent_exclude.json"
( $event_nofilter | ConvertTo-Json -Depth 4 )>$file