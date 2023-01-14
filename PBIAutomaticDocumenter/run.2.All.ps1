
$debugMode = $false
$path = "/Users/agustinsackmann/Repos/BIA/Clientes/TEN/tdp-infra-as-code/powerbi/PBIAutomaticDocumenter/output/"
[string]$connections = "$($PSScriptRoot)\connection.json"
$details = Get-Content $connections | ConvertFrom-Json

#### TO RUN WITH ServicePrincipal from connections file #####
$tenantId = $details.tenantId
$servicePrincipalFlag  = $true
$appId = $details.SvcAcc
$appsecretValue = $details.SvcPass
$secure_String_Pwd = ConvertTo-SecureString $AppsecretValue -AsPlainText -Force
$StorageAcc     = $details.StorageAcc
$StoragePath    = $details.StoragePath
$StorageKey     = $details.StorageKey
#### TO RUN WITH ServicePrincipal from connections file #####

#### TO RUN WITH ServicePrincipal #####
#$tenantId = "2ded5d7e-fbb1-4835-83cb-40787153c2a0"
#$appId = "3f672924-878a-4a80-bd3b-cd26b3f38961"
#$AppsecretValue = ""
#$Secure_String_Pwd = ConvertTo-SecureString $AppsecretValue -AsPlainText -Force
#$servicePrincipalFlag  = $true
#$StorageAcc     = ""
#$StoragePath    = ""
#$StorageKey     = ""
#### TO RUN WITH ServicePrincipal #####

#### TO RUN WITH AD USER, REMOVE COMMENT FROM NEXT LINE #####
#$servicePrincipalFlag  = $false
#### TO RUN WITH AD USER #####


### 1 -  Only Workspaces and Users permissions - CASO NICO NEIFFERT
#& "$PSScriptRoot\pbi-GetMetadata.ps1" -tenantId $tenantId -userName $appId -password $Secure_String_Pwd  -path $path -debugMode $debugMode -servicePrincipalFlag $servicePrincipalFlag -workspacesListFlag $true -usersAccessFlag $true -dimListFlag $false -relListFlag $false   -StorageAcc $StorageAcc -StoragePath $StoragePath  -StorageKey $StorageKey  


### 2 - Workspaces, Users permissions, Reports, Datasets, Dashboards - CASO ADOLFO
& "$PSScriptRoot\pbi-GetMetadata.ps1" -tenantId $tenantId -userName $appId -password $Secure_String_Pwd  -path $path -debugMode $debugMode -servicePrincipalFlag $servicePrincipalFlag -workspacesListFlag $true -dimListFlag $true -relListFlag $true -usersAccessFlag $true   -StorageAcc $StorageAcc -StoragePath $StoragePath  -StorageKey $StorageKey  

### 3 - Workspaces, Users permissions, Reports, Datasets, Dashboards, - Parametrized
#$workspacesListFlag = $true
#$usersAccessFlag = $true
#$relListFlag= $true
#$dimListFlag = $true
#& "$PSScriptRoot\pbi-GetMetadata.ps1" -tenantId $tenantId -userName $appId -password $Secure_String_Pwd  -path $path -debugMode $debugMode -servicePrincipalFlag $servicePrincipalFlag -workspacesListFlag $workspacesListFlag -dimListFlag $dimListFlag -relListFlag $relListFlag -usersAccessFlag $usersAccessFlag   -StorageAcc $StorageAcc -StoragePath $StoragePath  -StorageKey $StorageKey  