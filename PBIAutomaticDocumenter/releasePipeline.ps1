# Write your PowerShell commands here.

Write-Host "Exporting PBI Metadata to ADLS"

$debugMode = $false
$path = "$(System.DefaultWorkingDirectory)"
#### TO RUN WITH ServicePrincipal #####
$tenantId = "$(tenantId)"
$appId = "$(appId)"
$AppsecretValue = "$(AppsecretValue)"
$Secure_String_Pwd = ConvertTo-SecureString $AppsecretValue -AsPlainText -Force
$servicePrincipalFlag  = $true
$StorageAcc     = "$(StorageAcc)"
$StoragePath    = "$(StoragePath)"
$StorageKey     = "$(StorageKey)"
#### TO RUN WITH ServicePrincipal #####

$workspacesListFlag = $true
$usersAccessFlag = $true
$relListFlag= $true
$dimListFlag = $true

Write-Host "Installing modules..."
try{
    Install-Module Az.Storage  -Force -AllowClobber
    Install-Module Az.Accounts -Force -AllowClobber
    Install-Module MicrosoftPowerBIMgmt -Force -AllowClobber
}
catch{
    Write-Host "Error: Could not install modules:"$_.Exception
    throw "Error installing modules."
}


& $(System.DefaultWorkingDirectory)"/_BIA - Data Platform/src/PBIAutomaticDocumenter/pbi-GetMetadata.ps1" -tenantId $tenantId -userName $appId -password $Secure_String_Pwd  -path $path -debugMode $debugMode -servicePrincipalFlag $servicePrincipalFlag -workspacesListFlag $workspacesListFlag -dimListFlag $dimListFlag -relListFlag $relListFlag -usersAccessFlag $usersAccessFlag -StorageAcc $StorageAcc -StoragePath $StoragePath  -StorageKey $StorageKey   