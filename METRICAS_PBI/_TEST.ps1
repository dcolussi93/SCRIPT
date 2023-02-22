$applicationId = "035664ed-e0a2-43b2-aba8-c4082cf74a8d";
$pass = "m7_uViVNo7EU.SA5HN-gS5rMYhDZo490QG"
$tenant = "a054342c-6f8c-4378-ad61-a8ad00f2b736"
$securePassword = $pass | ConvertTo-SecureString -AsPlainText -Force
#$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $applicationId, $securePassword
#$x = Connect-PowerBIServiceAccount -ServicePrincipal -Credential $credential -TenantId $tenant

$x = Connect-DataGatewayServiceAccount -ApplicationId $applicationId -ClientSecret $securePassword -Tenant $tenant