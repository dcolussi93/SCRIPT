#Seccion Microsoft MicrosoftPowerBIMgmt.Reports
$config = Get-Content -Path .\config.json -Raw | ConvertFrom-Json
$prefijo = $config.export+"/"+$config.prefijo

# REPORTES -----------

write-host "(*) Reports:"

$x =Get-PowerBIDashboard -Scope Organization 
$file = $prefijo+"PowerBIDashboard.json"
( $x | ConvertTo-Json -Depth 4 )>$file

$x = Get-PowerBIImport -Scope Organization
$file = $prefijo+"PowerBIImport.json"
( $x | ConvertTo-Json -Depth 4 )>$file

$x = Get-PowerBIReport -Scope Organization
$file = $prefijo+"PowerBIReport.json"
( $x | ConvertTo-Json -Depth 4 )>$file