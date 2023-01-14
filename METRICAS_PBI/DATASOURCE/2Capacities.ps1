#Seccion Microsoft MicrosoftPowerBIMgmt.Capacities
$config = Get-Content -Path .\config.json -Raw | ConvertFrom-Json
$prefijo = $config.export+"/"+$config.prefijo

write-host "(*) Capacities"

$x = Get-PowerBICapacity -Scope Organization -ShowEncryptionKey
$file = $prefijo+"PowerBICapacity.json"
( $x | ConvertTo-Json -Depth 4 )>$file