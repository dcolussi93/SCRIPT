#Seccion Microsoft MicrosoftPowerBIMgmt.Workspaces
# Archivo de configuracion
$config = Get-Content -Path .\config.json -Raw | ConvertFrom-Json
$prefijo = $config.export+"/"+$config.prefijo

write-host "(*) Workspaces:"

$x = Get-PowerBIWorkspace -Scope Organization -Include All
$file = $prefijo+"PowerBIWorkspace.json"
( $x | ConvertTo-Json -Depth 4 )>$file
