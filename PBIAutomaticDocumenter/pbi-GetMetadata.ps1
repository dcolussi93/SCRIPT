## Needed modules
## Install-Module -Name MicrosoftPowerBIMgmt
## Install-Module -Name DataGateway ~~ not in use ~~ 

param ( # Script params
    [parameter(Mandatory = $false )] [String] $tenantId, 
    [parameter(Mandatory = $false )] [Boolean] $servicePrincipalFlag, 
    [parameter(Mandatory = $false )] [String] $userName, 
    [parameter(Mandatory = $false )] [SecureString] $password , 
    [parameter(Mandatory = $false )] [String] $path = "$($PSScriptRoot)/temp/output",
    [parameter(Mandatory = $false )] [Boolean] $workspacesListFlag = $true,
    [parameter(Mandatory = $false )] [Boolean] $usersAccessFlag = $true,
    [parameter(Mandatory = $false )] [Boolean] $relListFlag = $true,
    [parameter(Mandatory = $false )] [Boolean] $dimListFlag = $true,
    [parameter(Mandatory = $false )] [Boolean] $debugMode = $false,
    #[string]$connections = "$($PSScriptRoot)/connection.json"
    [parameter(Mandatory = $false )] [String] $StorageAcc,
    [parameter(Mandatory = $false )] [String] $StoragePath,
    [parameter(Mandatory = $false )] [String] $StorageKey
)

$ErrorActionPreference = 'Stop'


Function LogWrite{
# Writes string output to console and log file.
    param(
            [Parameter(Mandatory)]
            [string]$LogFileName,

            [Parameter(Mandatory)]
            [string]$LogString,

            [Parameter()]
            [string]$LogColor = "DarkGray"
        )
    try{     
        Add-content $LogFileName -value "[$(get-date -format dd/MM/yyyy-HH:mm:ss)] $($LogString)" -ErrorAction Stop
        Write-Host -f $LogColor $LogString
    }
    catch{
        Write-Host -f Red $_.Exception
        throw "Error creating log."
    }
}

function pbiAuth { # Authenticate against PBI API
    param(
        [Parameter(Mandatory = $true )] [string]        $tenantId,
        [Parameter(Mandatory = $false )] [Boolean]       $servicePrincipalFlag,
        [Parameter(Mandatory = $true )] [string]        $userName,
        [Parameter(Mandatory = $true )] [SecureString]  $password
    )

    $credential = New-Object System.Management.Automation.PSCredential($userName, $password)

    if ( $servicePrincipalFlag ) {
        Connect-PowerBIServiceAccount -Tenant $tenantId -Credential $credential -ServicePrincipal 
    }
    else {
        Connect-PowerBIServiceAccount
    }
}

function getWorkspaces { # Get all accessible workspaces in Tenant
    param(
        [Parameter(Mandatory = $false )] [boolean] $debugMode = $false
    )
    
    if ($debugMode -eq $true ) { $first = 1 } else { $first = 100 } 

    # try-catch to allow non-admin accounts to run the same script
    # for admin accounts all workspaces will be retrieved
    # for non-admin account only workspaces where 
    
    try {
        $workspaces = Get-PowerBIWorkspace  -Include All -Scope Organization -Skip 0 -First $first -ErrorAction Stop
        $scope = "Organization"
        LogWrite -LogFileName $LogFile -LogString "Account has Power BI admin rights..."
        LogWrite -LogFileName $LogFile -LogString "Retreiving all workspaces..."

        
    }
    catch {
        
        if ($_.FullyQualifiedErrorId -eq "Operation returned an invalid status code 'TooManyRequests',Microsoft.PowerBI.Commands.Workspaces.GetPowerBIWorkspace") {
            Write-Host   
            LogWrite -LogFileName $LogFile -LogColor Red -LogString $_.FullyQualifiedErrorId
            break
        }
        else {
            Write-Host $_.FullyQualifiedErrorId
            LogWrite -LogFileName $LogFile -LogColor Red -LogString "Account has no Power BI admin rights..."
            LogWrite -LogFileName $LogFile -LogColor Red -LogString "Retreiving the workspaces that this account has access to..."
            $workspaces = Get-PowerBIWorkspace -Scope Individual -First $first
            $scope = "Individual"
        }        
    }
      

    $i = 100
    
    # Iterate every 100 workspaces since there's a limit. 
    While ( ([System.Math]::Ceiling($workspaces.count / 100)) -le ( $workspaces.count / 100 ) -and $debugMode -eq $false )
    {
        try {
        Write-Host "Retrieving workspaces by skipping $($i)..."
        $workspaces += Get-PowerBIWorkspace -Scope $scope -Include All -Skip $i
        $i = $workspaces.count
        }
        catch {
            Write-Host "Breaking cause error..."
            break
        }
    }    

    Write-Host "Total workspaces retrieved: $($workspaces.count)"

    
    return $workspaces, $scope
}

function getWorkspacesData { 
    param(
        [Parameter(Mandatory = $true ) ] [array] $workspaces,
        [Parameter(Mandatory = $true ) ] [String] $scope,
        [Parameter(Mandatory = $false )] [boolean] $debugMode = $false
    )
    
    $ws = 0

    foreach ($workspace in $workspaces) {
        $workspaceId = $workspace.Id
        $workspaceDashboardsData =  $workspace.Dashboards
        $workspaceReportsData =  $workspace.Reports
        $workspaceDatasetsData =  $workspace.Datasets

        #$workspaceDashboards = Get-PowerBIDashboard -WorkspaceId $workspaceId -Scope $scope
        #$workspaceReports = Get-PowerBIReport -WorkspaceId $workspaceId -Scope $scope
        #$workspaceDatasets = Get-PowerBIDataset -WorkspaceId $workspaceId -Scope $scope
        
        #Write-Host "Workspace Name: $($workspace.Name) - WorkspaceId: $($workspaceId) - Dataset count: $($workspaceDatasetsData.Count) - Report count: $($workspaceReportsData.Count)"
        
        #Write-Host "Workspace Name: $($workspace.Name) - WorkspaceId: $($workspaceId)"
        # Get datasources for each dataset
        <# $workspaceDatasources = @()
        foreach ($datasetId in $workspaceDatasets.Id) {
            try {
                $datasetDatasources = Get-PowerBIDatasource -DatasetId $datasetId -Scope $scope -ErrorAction Stop
                
                $i = 0
                foreach ($datasetDatasource in $datasetDatasources) {
                    $datasetDatasources[$i] | Add-Member -MemberType NoteProperty -Name 'DatasetId' -Value $datasetId 
                    $datasetDatasources[$i] | Add-Member -MemberType NoteProperty -Name 'Server' -Value $datasetDatasources[$i].ConnectionDetails.Server 
                    $datasetDatasources[$i] | Add-Member -MemberType NoteProperty -Name 'Database' -Value $datasetDatasources[$i].ConnectionDetails.Database 
                    $datasetDatasources[$i] | Add-Member -MemberType NoteProperty -Name 'Url' -Value $datasetDatasources[$i].ConnectionDetails.Url
                    $i += 1
                }

                $workspaceDatasources += $datasetDatasources
            }
            catch {
                Write-Host "Datasources for $($datasetId) are not accessible for current user."
            }
        } #>

        
        # Add custom properties
        if ($workspaceDatasetsData.Count -gt 0) {
            $workspaceDatasetsData | Add-Member -MemberType NoteProperty -Name 'WorkspaceId' -Value $workspaceId
        }
        if ($workspaceDashboardsData.Count -gt 0) {        
            $workspaceDashboardsData | Add-Member -MemberType NoteProperty -Name 'WorkspaceId' -Value $workspaceId 
        }
        if ($workspaceReportsData.Count -gt 0) {
            $workspaceReportsData | Add-Member -MemberType NoteProperty -Name 'WorkspaceId' -Value $workspaceId
        }
        # Add to full array
        $dashboardsData += $workspaceDashboardsData
        $reportsData += $workspaceReportsData
        $datasetsData += $workspaceDatasetsData

        $ws += 1
    }
   
    return $datasetsData, $reportsData, $dashboardsData
}

function splitWorkspaces { # Split workspace related info (users, reports, datasets, dashboards)
    param(
        [Parameter(Mandatory = $true)] [array] $workspaces 
    )
    $users = @()
    $reports = @()
    $dashboards = @()
    $datasets = @()
    
    foreach ($workspace in $workspaces) {
        
        $users += foreach ($user in $workspace.Users){
            [pscustomobject]@{
                WorkspaceId = $workspace.Id
                UserPrincipalName = $user.UserPrincipalName
                AccessRight = $user.AccessRight
                Identifier = $user.Identifier
                PrincipalType = $user.PrincipalType
            }
        }

        $reports += foreach ($report in $workspace.Reports){
            [pscustomobject]@{
                WorkspaceId = $workspace.Id
                ReportId = $report.Id
            }
        }
        

        $dashboards += foreach ($dashboard in $workspace.Dashboards){
            [pscustomobject]@{
                WorkspaceId = $workspace.Id
                DashboardId = $dashboard.Id
            }
        }

        $datasets += foreach ($dataset in $workspace.Datasets){
            [pscustomobject]@{
                WorkspaceId = $workspace.Id
                DatasetId = $dataset.Id
            }
        }
    }

    return $users, $reports, $dashboards, $datasets
}

function getActivity { # Get all events in a timeframe.
    param(
        [Parameter(Mandatory = $true )]  [String] $startDate,
        [Parameter(Mandatory = $true )]  [String] $endDate,
        [Parameter(Mandatory = $true )]  [String] $path
    )

    # 
    LogWrite -LogFileName $LogFile -LogString "Getting activity events between $($startDate) and $($endDate)..."

    $startDateTime = [Datetime]::ParseExact($startDate , 'yyyy-MM-dd', $null)
    $endDateTime = [Datetime]::ParseExact($endDate , 'yyyy-MM-dd', $null)

    While ( $startDateTime -le $endDateTime ){
        LogWrite -LogFileName $LogFile -LogString "Getting activity events of $($startDateTime)..."

        $from = "$($startDateTime.ToString('yyyy-MM-dd') )T00:00:00"
        $to = "$($startDateTime.ToString('yyyy-MM-dd') )T23:59:59"
        $events += Get-PowerBIActivityEvent -StartDateTime $from -EndDateTime $to 
        exportArray -path "$($path)events\" -fileName "$($startDateTime.ToString('yyyyMMdd'))" -array $events -format "json"

        $startDateTime = $startDateTime.AddDays(1)
    }

    return $events
}

function exportArray { # Export array to any format
    param(
        [Parameter(Mandatory = $true )]  [String] $path,
        [Parameter(Mandatory = $true )]  [String] $fileName,
        [Parameter(Mandatory = $true )]  [Array ] $array,
        [Parameter(Mandatory = $false )] [Boolean] $debugMode = $false,
        [Parameter(Mandatory = $false )] [String] $format = "csv",
        [pscustomobject]$details
    )
    
    $storageacc = $details.StorageAcc
    $storagepath = $details.StoragePath
    $storagekey = $details.StorageKey
    $ctx = New-AzStorageContext -StorageAccountName $storageacc -StorageAccountKey $storagekey
    $container = Get-AzStorageContainer -Name $storagepath -Context $ctx -ErrorAction Ignore
    if (-not $container)
    {
        LogWrite -LogFileName $LogFile -LogString "Container Not Found. Creating..."
        New-AzStorageContainer -Context $ctx -Name $storagepath
    }

    LogWrite -LogFileName $LogFile -LogString "Exporting output to file $($fileName).$($format) path: $($path)..."
    if ($format -eq "json") {
        $array | Out-File -FilePath "$($path)\$($fileName).$($format)"
    }
    else {
        $array | Export-Csv -Path "$($path)\$($fileName).$($format)" -NoTypeInfo -Delimiter ";" -Encoding "UTF8"
    }

    LogWrite -LogFileName $LogFile -LogString  "Uploading file $($path)$($fileName).$($format) to exportpbimetadata/$($fileName).$($format)"
    $sa_file = Get-AzDataLakeGen2Item -FileSystem $storagepath -Context $ctx -Path "exportpbimetadata/$($fileName).$($format)" -ErrorAction Ignore
    if (-not $sa_file)
    {
        LogWrite -LogFileName $LogFile -LogString "File Not Found. Creating..."
        New-AzDataLakeGen2Item -Context $ctx -FileSystem $storagepath -Path "exportpbimetadata/$($fileName).$($format)" -Source "$($path)$($fileName).$($format)" -Force
    }
    else {
        LogWrite -LogFileName $LogFile -LogString "File Found. ReWrite..."
        New-AzDataLakeGen2Item -Context $ctx -FileSystem $storagepath -Path "exportpbimetadata/$($fileName).$($format)" -Source "$($path)$($fileName).$($format)" -Force
    }

}

$Date = get-date -format yyyyMMdd_HHmmss

$LogFile = "$($PSScriptRoot)\logs\pbi_GetMetadata_$($Date).log"
LogWrite -LogFileName $LogFile -LogString "Script initialized by user $($env:USERNAME)."

# Use modules:
LogWrite -LogFileName $LogFile -LogString "Importing modules..."
try{
    Import-Module Az.Storage  
    Import-Module Az.Accounts
    Import-Module MicrosoftPowerBIMgmt
}
catch{
    LogWrite -LogFileName $LogFile -LogColor Red -LogString "Error: Could not import modules:"$_.Exception
    throw "Error importing modules."
}

LogWrite -LogFileName $LogFile -LogString "Starting to extract data from Tenant..."
LogWrite -LogFileName $LogFile -LogString "Debug mode is set to $($debugMode) "

<# authenticate using provided params #> 
pbiAuth -userName $userName -password $password -tenantId $tenantId -servicePrincipalFlag $servicePrincipalFlag
$workspaces, $scope = getWorkspaces -debugMode $debugMode
$users, $reports, $dashboards, $datasets = splitWorkspaces -workspaces $workspaces

$connections = @{
    StorageAcc = $StorageAcc
    StoragePath = $StoragePath
    StorageKey = $StorageKey
}
#$details = Get-Content $connections | ConvertFrom-Json
$details = $connections

if ($workspacesListFlag) {
    <# get workspace list #> 
    if ($workspaces.count -gt 0) {
        $w = $workspaces | Select-Object Id,Name,IsReadOnly,IsOnDedicatedCapacity,CapacityId,Description,Type,State,IsOrphaned
        exportArray -path $path -fileName "DIM_Workspaces"  -array $w -details $details
        #Users.count,Reports";"Dashboards";"Datasets";"Dataflows";"Workbooks"
    }
    else {
        LogWrite -LogFileName $LogFile -LogString "Workspaces array empty"
    }
}


if ($usersAccessFlag) {
    if ($users.count -gt 0) {
        exportArray -path $path -fileName "REL_UserWorkspace"  -array $users -details $details
    }
    else {
        LogWrite -LogFileName $LogFile -LogString "Account has NO Power BI admin rights... REL_UserWorkspace array empty"
    }
}


if($relListFlag){
    <# split different attributes for each workspace #> 
    if ($scope -eq "Organization") {
        if ($reports.count -gt 0) {
            exportArray -path $path -fileName "REL_ReportsWorkspace"  -array $reports -details $details
        }
        else {
            LogWrite -LogFileName $LogFile -LogString "Account has NO Power BI admin rights... REL_ReportsWorkspace array empty"
        }

        if ($dashboards.count -gt 0) {
            exportArray -path $path -fileName "REL_DashboardsWorkspace"  -array $dashboards -details $details
        }
        else {
            LogWrite -LogFileName $LogFile -LogString "Account has NO Power BI admin rights... REL_DashboardsWorkspace array empty"
        }

        if ($datasets.count -gt 0) {
            exportArray -path $path -fileName "REL_DatasetsWorkspace"  -array $datasets -details $details
        }
        else {
            LogWrite -LogFileName $LogFile -LogString "Account has NO Power BI admin rights... REL_DatasetsWorkspace array empty"
        }

        
    }
}


if($dimListFlag){
    if ($scope -eq "Organization") {
        $datasetsData, $reportsData, $dashboardsData = getWorkspacesData -workspaces $workspaces -scope $scope -debugMode $debugMode
        if ($dashboardsData.count -gt 0) {
            exportArray -path $path -fileName "DIM_Dashboards"  -array $dashboardsData -details $details
        }
        if ($reportsData.count -gt 0) {
            exportArray -path $path -fileName "DIM_Reports"     -array $reportsData -details $details
        }
        if ($datasetsData.count -gt 0) {
            exportArray -path $path -fileName "DIM_Datasets"    -array $datasetsData -details $details
        }        
    }
}
<# Get workspace data #> 


##exportArray -path $path -fileName "Datasources" -array $datasources

# $events = getActivity -startDate "2021-11-01" -endDate "2021-11-11" -path $path

# $ds = Get-PowerBIDatasource -DatasetId 'aef4ea5d-7093-4d39-89fb-274666cbee6b' -Scope $scope -ErrorAction Stop
# $ds
# $ds.ConnectionDetails

# End Session
Disconnect-PowerBIServiceAccount

LogWrite -LogFileName $LogFile -LogString  "GetMetadata COMPLETE..."