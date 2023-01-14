# Introduction

This utility will help download the desired information from a Power BI Tenant automatically.
This solution involves a PowerShell script that:
- Connects to a Power BI Tenant.
- Collects metadata executing cmdlets from the PowerShell MicrosoftPowerBIMgmt module.
- Saves results to csv files.


# Pre Requisites

In order to get the most out of this script, users should count with:
- A Service Principal within a Security Group with permissions to use the Power BI Admin API or the account must be a Power BI Tenant Administrator (or a Microsoft 365 administrator).
- PowerShell 7 or later.
- MicrosoftPowerBIMgmt module should be installed. Open a PowerShell file in Visual Studio Code or run Windows      PowerShell as administrator and execute the following line of code: 
    `Install-Module -Name MicrosoftPowerBIMgmt`

> Note: Non-admin users may execute this code as well, but may not be able to access objects which they don't have explicit permissions to.


# Executing the PBI Tenant Documenter

The solution contains 2 PowerShell scripts (run.ps1, pbi-GetMetadata.ps1)


## run.ps1

Users will execute the whole solution from this script.
Users must specify the following needed parameters:
- $debugMode = $true 'If true the script will run for only the first workspace that it finds. If false, the script will retrieve information for every single workspace the users has access to.
- $path = "C:\Temp" 'This is the path where the users want to save the csv extracts
- $tenantId = "tenantid" 'This is the Tenant ID that can be get from the PBI service URL
- $servicePrincipalFlag  = $true 'If true, it means users are using a service principal.
- $appId = "appid" 'Enter the Appplication ID. Client ID.
- $appsecretValue = "appsecretValue" 'Enter the Secret for the Application ID
- $workspacesListFlag = $true 'If true, the solution will retrieve a list of workspaces with the required details: name, id, description, capacity. It will also export this information into a csv file (DIM_Workspaces.csv) which will be saved in the location specified in the $path\output parameter mentioned above.
- $usersAccessFlag = $true 'If true, the solution will retrieve a list of users with access to each of the workspaces. It will also export this information into a csv file (REL_UserWorkspace.csv) which will be saved in the location specified in the $path\output parameter mentioned above.
- $relListFlag = $true 'If true, the solution will retrieve relationships for Dashboards, Datasets, Reports for each workspaces. It will also export this information into a csv file (REL_DashboadsWorkspace.csv, REL_DatasetsWorkspace.csv, REL_ReportsWorkspace.csv) which will be saved in the location specified in the $path\output parameter mentioned above.
- $dimListFlag = $true 'If true, the solution will retrieve attribute of Dashboards, Datasets, Reports for each workspaces. It will also export this information into a csv file (DIM_Dashboads.csv, DIM_Datasets.csv, DIM_Reports.csv)  which will be saved in the location specified in the $path\output parameter mentioned above.

## pbi-GetMetadata.ps1

This script will be executed by run.ps1.


# Pending
- [x] CSV files to Storage Account
- [x] ReWrite CSV files to Storage Account
- [x] Connect PBIx Report to Storage Account