#Conectarse si no está conectado.

#TENANT
$applicationId = "035664ed-e0a2-43b2-aba8-c4082cf74a8d";
$pass = "m7_uViVNo7EU.SA5HN-gS5rMYhDZo4__&###.90QG"
$tenant = "a054342c-6f8c-4378-ad61-a8ad00f2b736"
<#
#TENANT PROPIO
$applicationId = "2f18e4e2-bc34-4f44-9509-885cd958ff05";
$pass = "j8v8Q~gSlotptbolrp-a5n2-2LTbgNcQ7GEe2c_."
$tenant = "e494a33a-727a-4039-ad07-e2007fa068bb"
#>
$securePassword = $pass | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $applicationId, $securePassword
$x = Connect-PowerBIServiceAccount -ServicePrincipal -Credential $credential -TenantId $tenant


