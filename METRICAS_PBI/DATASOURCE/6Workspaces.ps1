#Seccion Microsoft MicrosoftPowerBIMgmt.Workspaces

write-host "(*) Workspaces:"

$wspaces = Get-PowerBIWorkspace -Scope Organization -Include All -all
#$wspaces = ConvertFrom-Json $wspaces
# Expcluir los workspaces personales son aprox 3047 de 3200 los personales.
$wsfilter =  @()
foreach($ws in $wspaces){
    if( ($ws.Name -notlike "Personal*") -and  ($ws.Name -notlike "My workspace*") ) {
        $wsfilter += $ws
    }
}

$file = "./DATAEXPORT/md_PowerBIWorkspace.json"
( $wsfilter | ConvertTo-Json -Depth 6 )>$file