#Seccion Microsoft MicrosoftPowerBIMgmt.Profile
write-host "(*) Profiles:"

$x =  Get-PowerBIAccessToken
$file = "./DATAEXPORT/md_PowerBIAccessToken.json"
( $x | ConvertTo-Json -Depth 4 )>$file