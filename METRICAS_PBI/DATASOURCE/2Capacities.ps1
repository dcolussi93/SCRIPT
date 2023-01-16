#Seccion Microsoft MicrosoftPowerBIMgmt.Capacities
write-host "(*) Capacities"

$x = Get-PowerBICapacity -Scope Organization -ShowEncryptionKey
$file = "./DATAEXPORT/md_PowerBICapacity.json"
( $x | ConvertTo-Json -Depth 4 )>$file