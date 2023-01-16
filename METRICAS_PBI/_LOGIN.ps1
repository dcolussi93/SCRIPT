#Instalar el modulo si no está instalado.
<#t
ry{
    Get-InstalledModule -Name "MicrosoftPowerBIMgmt"
}
catch {
    Install-Module -Name MicrosoftPowerBIMgmt -force
}
#>

#Conectarse si no está conectado.
try {
    $x = Get-PowerBIWorkspace
}
catch {
    $x = Connect-PowerBIServiceAccount
}

