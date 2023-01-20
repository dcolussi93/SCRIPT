#Seccion Microsoft MicrosoftPowerBIMgmt.Reports

# REPORTES -----------

write-host "(*) Reports:"

$x =Get-PowerBIDashboard -Scope Organization 
$file = "./DATAEXPORT/md_PowerBIDashboard.json"
( $x | ConvertTo-Json -Depth 5 )>$file

<#
$x = Get-PowerBIImport -Scope Organization
$file = "./DATAEXPORT/md_PowerBIImport.json"
( $x | ConvertTo-Json -Depth 5 )>$file
#>

$x = Get-PowerBIReport -Scope Organization
$file = "./DATAEXPORT/md_PowerBIReport.json"
( $x | ConvertTo-Json -Depth 5 )>$file