<#
ver. 1.0

.SYNOPSIS
Script that lists every file in selected location of OneDrive/SharePoint Online site and then exports the results to SharePoint_Listing.csv file

.PARAMETER
$SiteURL= " Provide direct link for OneDrive/SharePoint site for files to be listed " 
$ListName= "Documents"

.EXAMPLE
.\SharePointListing.ps1 -SiteURL "https://companyxyz.sharepoint.com/personal/user_lastname_companyxyz_com/" -ListName "Documents"

#>

param(
    [Parameter(Mandatory)]
    [string]$SiteURL,
    [Parameter(Mandatory)]
    [string]$ListName
)

#There might be a need for install-module by seperate line
Install-Module SharePointPnPPowerShellOnline -Scope CurrentUser -Force
Import-Module SharePointPnPPowerShellOnline

#Connect to PnP Online
Connect-PnPOnline -Url $SiteURL -UseWebLogin

#Get All Files from the document library - In batches of 500
$ListItems = Get-PnPListItem -List $ListName -PageSize 500 | Where-Object {$_["FileLeafRef"] -like "*.*"}

#Loop through all documents
$DocumentsData=@()

ForEach($Item in $ListItems){
    #Collect Documents Data
    $DocumentsData += New-Object PSObject -Property @{
        FileName = $Item.FieldValues['FileLeafRef']
        FileURL = $Item.FieldValues['FileRef']
    }
}

$path = "C:\ScriptsLogs\"
    If(!(test-path -PathType container $path))
    {
        New-Item -ItemType Directory -Path $path
}
$DocumentsData | Export-Csv -Path C:\ScriptsLogs\SharePoint_Listing.csv