#Seccion Microsoft MicrosoftPowerBIMgmt.Admin

# Archivo de configuracion
$config = Get-Content -Path .\config.json -Raw | ConvertFrom-Json

# Acceder al historico
$prefijo = $config.export+"/"+$config.prefijo
$file = $prefijo+"PowerBIActivityEvent.json"
$hist = Get-Content -Path $file -Raw | ConvertFrom-Json

$file_acu = $config.export+"/fc_PowerBIEvents.json"
$hist_acu = Get-Content -Path $file_acu -Raw | ConvertFrom-Json

$return =@()
$res = @{}
$res.fecha = (Get-Date -Format "yyyy-MM-d")
$res.data = @()
$res.data += $hist

$return += $res
$hist_acu += $res
#$hist_acu = ($hist_acu | Sort-Object -Unique)
( $hist_acu | ConvertTo-Json -Depth 4 )>".\DATAEXPORT\fc_PowerBIEvents.json"
