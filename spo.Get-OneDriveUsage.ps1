<#
.SYNOPSIS
Generates a report on OneDrive storage usage for all users in SharePoint Online.

.DESCRIPTION
This script connects to SharePoint Online, retrieves all personal site collections (OneDrive), 
and generates a report showing the owner, URL, assigned quota, used storage, and percentage of usage.

.EXAMPLE
.\spo.Get-OneDriveUsage.ps1
# Outputs the report to a CSV file and displays the table in the console.
#>

# Ensure required module is installed
Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force

# Connect to SharePoint Online Admin Center
$AdminURL = "https://yourtenant-admin.sharepoint.com"
Connect-SPOService -Url $AdminURL

# Retrieve OneDrive storage usage information
$Result = @()

$OneDrives = Get-SPOSite -IncludePersonalSite $True -Limit All -Filter "Url -like '-my.sharepoint.com/personal/'"
foreach ($OneDrive in $OneDrives) {
    $Result += [PSCustomObject]@{
        Email       = $OneDrive.Owner
        URL         = $OneDrive.URL
        QuotaGB     = [Math]::Round($OneDrive.StorageQuota / 1024, 3)
        UsedGB      = [Math]::Round($OneDrive.StorageUsageCurrent / 1024, 3)
        PercentUsed = [Math]::Round(($OneDrive.StorageUsageCurrent / $OneDrive.StorageQuota * 100), 3)
    }
}

# Display the report as a table
$Result | Format-Table Email, URL, UsedGB, QuotaGB, PercentUsed -AutoSize

# Export the report to CSV
$ExportPath = "C:\Reports\OneDrive

# Disconnect from SharePoint Online session
Disconnect-SPOService
