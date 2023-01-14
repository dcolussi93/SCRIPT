#Seccion Microsoft MicrosoftPowerBIMgmt.Profile
write-host "(*) Profiles:"

# Archivo de configuracion
$config = Get-Content -Path .\config.json -Raw | ConvertFrom-Json
$prefijo = $config.export+"/"+$config.prefijo

$x =  Get-PowerBIAccessToken
$file = $prefijo+"PowerBIAccessToken.json"
( $x | ConvertTo-Json -Depth 4 )>$file