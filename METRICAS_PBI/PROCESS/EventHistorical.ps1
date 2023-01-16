#Seccion Microsoft MicrosoftPowerBIMgmt.Admin

# Archivo de configuracion
$config = Get-Content -Path .\config.json -Raw | ConvertFrom-Json

$eventosFiles = ( Get-ChildItem -Path .\DATAEXPORT\EVENTS\ ) | Select-Object -Property Name

$result_ev = @()
foreach($evFile in $eventosFiles){  
    $file = ".\DATAEXPORT\EVENTS\"+$evFile.name
    write-host $evFile
    $result = @{
        "data"= Get-Content -Path $file -Raw | ConvertFrom-Json ;
        "file" = $evFile.name
    }
    $result_ev += $result
}

( $result_ev | ConvertTo-Json -Depth 8 )>".\DATAEXPORT\fc_PowerBIEvents.json"


