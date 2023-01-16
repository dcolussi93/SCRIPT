#Seccion Microsoft MicrosoftPowerBIMgmt.Data

write-host "(*) Data:"

$x =  Get-PowerBIDataset -Scope Organization
$file = "./DATAEXPORT/md_PowerBIDataset.json"
( $x | ConvertTo-Json -Depth 4 )>$file

$x =  Get-PowerBIDataflow -Scope Organization 
$file = "./DATAEXPORT/md_PowerBIDataflow.json"
( $x | ConvertTo-Json -Depth 4 )>$file

$x =  Get-PowerBIDataset | ? AddRowsApiEnabled -eq $true | Get-PowerBITable
$file = "./DATAEXPORT/md_PowerBITable.json"
( $x | ConvertTo-Json -Depth 4 )>$file
