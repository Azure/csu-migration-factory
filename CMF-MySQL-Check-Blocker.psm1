###az login --tenant TenantName
###az account set --subscription SubsName
###az account show
### Linux :- pwsh CMF-MySQL-Check-Blocker.ps1 -ResourceGroup <resource-group>  -ServerName <server-name>
### Windows :- powershell.exe .\CMF-MySQL-Check-Blocker.ps1 -ResourceGroup <resource-group>  -ServerName <server-name>

function MySQL-Check-Blocker
{
  
param (
    [string]$ResourceGroup,
    [string]$ServerName
)

if (-not $ResourceGroup -or -not $ServerName) {
    Write-Host "Usage: .\CMF-MySQL-Check-Blocker.ps1 -ResourceGroup <resource-group> -ServerName <server-name>"
    exit 1
}
$Subscription=az account show --query id --output tsv
if($Subscription -eq $null)
{
Write-host "Invalid Resource group or Server name or check subscription context using 'Get-AzContext' " -ForegroundColor red
EXIT
}

$ErrorActionPreference = "Stop"
try {
   $ServerData=az mysql server show --ids "/subscriptions/$Subscription/resourceGroups/$ResourceGroup/providers/Microsoft.DBforMySQL/servers/$ServerName" | ConvertFrom-Json
    if ($? -eq $false) {
        # throw $_.Exception.Message
        throw 'Invalid parameters supplied.'
    }
    
}
catch {
   WRITE-HOST "Invalid Resource IDs:/subscriptions/$Subscription/resourceGroups/$ResourceGroup/providers/Microsoft.DBforMySQL/servers/$ServerName" -ForegroundColor red
   exit
  #throw $_.Exception.Message
}


    

# Commands for Azure (Assuming Azure CLI is installed)
Write-Host "`n********************************************************************************************************************"
Write-Host "Private endpoint connections list for server [$ServerName] in resource group [$ResourceGroup]."  -ForegroundColor BLUE
Write-Host "********************************************************************************************************************"
$PvtEndoint=az network private-endpoint-connection list --type Microsoft.DBforMySQL/servers -g $ResourceGroup -n $ServerName  --only-show-errors
$pvtCount1=$PvtEndoint |ConvertFrom-Json
$pvtCount=$pvtCount1.count
if($pvtCount -eq 0)
{
Write-Host "No private endpoint for this server" -ForegroundColor GREEN
}
else
{
Write-Host "Number of private endpoint on [$ServerName]=$pvtCount" -ForegroundColor RED
az network private-endpoint-connection list --type Microsoft.DBforMySQL/servers -g $ResourceGroup -n $ServerName --only-show-errors

}

Write-Host "`n********************************************************************************************************************"
Write-Host "MySQL server CMK list for server [$ServerName] in resource group [$ResourceGroup]." -ForegroundColor BLUE
Write-Host "********************************************************************************************************************"
$CMK=az mysql server key list -g $ResourceGroup -s $ServerName

if($CMK -eq '[]')
{
Write-Host "No CMK associated with MySQL server [$ServerName]" -ForegroundColor Green
}
else
{
Write-Host "Data encrypted with customer-managed keys(CMK) for Azure Database for MySQL Server [$ServerName]" -ForegroundColor RED
$CMK

}

Write-Host "`n********************************************************************************************************************"
Write-Host "Active Directory admins list for server] [$ServerName] in resource group [$ResourceGroup]." -ForegroundColor BLUE
Write-Host "********************************************************************************************************************"
$ActDirectory=az mysql server ad-admin list -g $ResourceGroup -s $ServerName
if($ActDirectory -eq '[]')
{
Write-Host "No Microsoft Entra admin associated with MySQL server [$ServerName]" -ForegroundColor Green
}
else
{
Write-Host "Entra admin associated with MySQL server [$ServerName]" -ForegroundColor RED
$ActDirectory

}

Write-Host "`n********************************************************************************************************************"
Write-Host "VNet rules list for server [$ServerName] in resource group [$ResourceGroup]."  -ForegroundColor BLUE
Write-Host "********************************************************************************************************************"

$userVisibleState=$ServerData.userVisibleState
if ($userVisibleState -eq 'Stopped')
{
Write-Host "MySQL server [$ServerName] is in $userVisibleState state, VNET info can not be captured in stopped state!" -ForegroundColor Yellow
}
else
{
$vNet=az mysql server vnet-rule list --resource-group $ResourceGroup --server-name $ServerName |ConvertFrom-Json

$vNet=$vNet.count
if($vNet -eq 0)
{
Write-Host "No VNET rules on mysql server [$ServerName]" -ForegroundColor GREEN
}
else
{
Write-Host "Number of VNET rules on [$ServerName]=$vNet" -ForegroundColor RED
az mysql server vnet-rule list --resource-group $ResourceGroup --server-name $ServerName 

}
}


Write-Host "`n********************************************************************************************************************"
Write-Host "Replicas list for server [$ServerName] in resource group [$ResourceGroup]."  -ForegroundColor BLUE
Write-Host "********************************************************************************************************************"
$Replica=az mysql server replica list -g $ResourceGroup -s $ServerName
if($Replica -eq '[]')
{
Write-Host "No Replica associated with MySQL server [$ServerName]" -ForegroundColor Green
}
else
{
Write-Host "Replica associated with MySQL server [$ServerName]" -ForegroundColor RED
write-host $Replica

}


Write-Host "`n********************************************************************************************************************"
Write-Host "Checking for Double Encryption on [$ServerName] in resource group [$ResourceGroup]."  -ForegroundColor BLUE
Write-Host "********************************************************************************************************************"
 $DoubleEncryption=$ServerData.infrastructureEncryption 
 If ($DoubleEncryption -eq "Enabled")
 {
  Write-Host "Infrastructure double encryption is [$DoubleEncryption] on MySQL server [$ServerName]" -ForegroundColor RED
 }
 else
 {
 Write-Host "Infrastructure double encryption is [$DoubleEncryption] on MySQL server [$ServerName]" -ForegroundColor Green
 }
 Write-Host "********************************************************************************************************************`n`n`n"


}
#CMF-MySQL-Check-Blocker -ResourceGroup  -ServerName