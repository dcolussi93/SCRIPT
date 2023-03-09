
$qry = Get-DataGatewayCluster -Scope Organization

$file = "./DATAEXPORT/md_DataGatewayCluster.json"
( $qry | ConvertTo-Json -Depth 6 )>$file

$qry = Get-DataGatewayDatasource
$file = "./DATAEXPORT/md_DataGatewayDatasource.json"
( $qry| ConvertTo-Json -Depth 6 )>$file