#Seccion Microsoft MicrosoftPowerBIMgmt.Workspaces

write-host "(*) Workspaces:"

$x = Get-PowerBIWorkspace -Scope Organization -Include All
$file = "./DATAEXPORT/md_PowerBIWorkspace.json"
( $x | ConvertTo-Json -Depth 6 )>$file
