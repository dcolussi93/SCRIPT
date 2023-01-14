$config = Get-Content -Path .\config.json -Raw | ConvertFrom-Json

#Instalar el modulo si no está instalado.
try{
    Get-InstalledModule -Name "MicrosoftPowerBIMgmt"
}
catch {
    Install-Module -Name MicrosoftPowerBIMgmt -force
}

#Forzar el logeo
if($config.force_login) {
    Connect-PowerBIServiceAccount
}

#Conectarse si no está conectado.
try {
    $x = Get-PowerBIWorkspace
}
catch {
    $x = Connect-PowerBIServiceAccount
}

