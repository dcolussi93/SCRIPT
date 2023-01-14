#Seccion Microsoft MicrosoftPowerBIMgmt.Data

# Archivo de configuracion
$config = Get-Content -Path .\config.json -Raw | ConvertFrom-Json
$prefijo = $config.export+"/"+$config.prefijo

write-host "(*) Data:"

$x =  Get-PowerBIDataset -Scope Organization
$file = $prefijo+"PowerBIDataset.json"
( $x | ConvertTo-Json -Depth 4 )>$file

$x =  Get-PowerBIDataflow -Scope Organization 
$file = $prefijo+"PowerBIDataflow.json"
( $x | ConvertTo-Json -Depth 4 )>$file

$x =  Get-PowerBIDataset | ? AddRowsApiEnabled -eq $true | Get-PowerBITable
$file = $prefijo+"PowerBITable.json"
( $x | ConvertTo-Json -Depth 4 )>$file
