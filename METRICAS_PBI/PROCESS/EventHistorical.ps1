#Seccion Microsoft MicrosoftPowerBIMgmt.Admin

# Archivo de configuracion
$config = Get-Content -Path .\config.json -Raw | ConvertFrom-Json

$eventosFiles = ( Get-ChildItem -Path .\DATAEXPORT\EVENTS\ ) | Select-Object -Property Name

$result_ev = @()
foreach($evFile in $eventosFiles){  
    
    $file = ".\DATAEXPORT\EVENTS\"+$evFile.name
    write-host $evFile
    
    $result = @{}
    $result.data = @()
    $result.data += Get-Content -Path $file -Raw | ConvertFrom-Json ;
    $result.file = $evFile.name
    # Append del objeto resultado: Archivo + Data
    $result_ev += $result
}

# guardar el consolidado en archivo
( $result_ev | ConvertTo-Json -Depth 8 )>".\DATAEXPORT\fc_PowerBIEvents.json"


