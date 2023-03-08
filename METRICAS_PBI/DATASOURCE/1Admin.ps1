#Seccion Microsoft MicrosoftPowerBIMgmt.Admin

write-host "(*) Admin:"

<#
$x = Get-PowerBIWorkspace -Scope Organization | Get-PowerBIWorkspaceEncryptionStatus
$file = "./DATAEXPORT/md_PowerBIWorkspaceEncryptionStatus.json"
( $x | ConvertTo-Json -Depth 4 )>$file
#>

# Exportar Eventos
$f_inicio = (Get-Date -Format "yyyy-MM-dd")+"T00:30:00"
$f_fin= (Get-Date -Format "yyyy-MM-dd")+"T23:59:00"
$fech = (Get-Date -Format "yyyyMMdd")

#$f_inicio = "2023-02-27T00:30:00"
#$f_fin= "2023-02-27T23:59:00"
#$fech = "20230227"

$events = Get-PowerBIActivityEvent -StartDateTime $f_inicio -EndDateTime $f_fin
$events = ConvertFrom-Json $events

# Expcluir eventos del tipo ExportActivityEvents y GetAdmin etc.
$event_filter =  @()
$event_nofilter =  @()

foreach($e in $events){
    if( ($e.Operation -ne "ExportActivityEvents") -and ($e.Operation -notlike "Get*") -and ($e.WorkSpaceName -notlike "Personal*") ) {
        $event_filter += $e
    }else{
        $event_nofilter+=$e
    }
}
# Guardar en archivo Json Eventos
$file = "./DATAEXPORT/md_PowerBIActivityEvent.json"
( $event_filter | ConvertTo-Json -Depth 6 )>$file

#Guardar Historico Diario Carpeta Ejecucion
$file = "./DATAEXPORT/EVENTS/"+$fech+"_PowerBIActivityEvent.json"
( $event_filter | ConvertTo-Json -Depth 6 )>$file

# Eventos Ignorados
$file = "./DATAEXPORT/md_PowerBIActivityEvent_exclude.json"
( $event_nofilter | ConvertTo-Json -Depth 6 )>$file
