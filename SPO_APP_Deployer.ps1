#                  #
# SCRIPT FUNCTIONS #
#                  #

function Show-Menu
{
    #Clear-Host
    Write-Host '================ SPO APP Deployer ================'
    Write-Host 'Use this script carefully - Check URL and user twice.' -f red
    Write-Host 'Three time if you are trying to done something in PRODUCTION environments' -f red
    Write-Host '========================================================'
    
    Write-Host '1: Press '1' to deploy 'YOUR_PACKAGE_FRIENDLY_NAME1'.'
    Write-Host '2: Press '2' to deploy 'YOUR_PACKAGE_FRIENDLY_NAME2.''
    Write-Host '3: Press '3' to deploy 'YOUR_PACKAGE_FRIENDLY_NAME3'.'
    Write-Host '4: Press '4' to deploy all apps.'
    Write-Host 'Q: Press 'Q' to quit.'
}

function StandardDeploy
{
    param (
        [string]$FullPath = '',
        [string]$PackgName = ''
    )

    #Move
    Set-Location -Path $FullPath
    
    #Clean
    gulp clean

    #Build
    gulp bundle --ship

    #Build Package
    gulp package-solution --ship
    
    Add-PnPApp -Path $PackgName -Publish -Overwrite
}


#              #
# SCRIPT START #
#              #

#First ask per credentials
Clear-Host
$tennantUrl = Read-Host 'URL of tennant to connect'
Write-Host 'You re trying to connect to ' -f yellow -NoNewline
Write-Host -f red $tennantUrl 
Connect-PnPOnline -Url $tennantUrl -Credentials (Get-Credential)

do
 {
    Show-Menu
     $selection = Read-Host 'Please select a option'
     switch ($selection)
     {
         '1' {
             StandardDeploy -FullPath 'URL_To_Main_Folder_Of_Your_App_Project' -PackgName 'sharepoint\solution\YOUR_PACKAGE_NAME.sppkg'
         }
         '2' {
            StandardDeploy -FullPath 'URL_To_Main_Folder_Of_Your_App_Project2' -PackgName 'sharepoint\solution\YOUR_PACKAGE_NAME2.sppkg'
         }
         '3' {
			      StandardDeploy -FullPath 'URL_To_Main_Folder_Of_Your_App_Project3' -PackgName 'sharepoint\solution\YOUR_PACKAGE_NAME3.sppkg'
         }
         '4' {
            StandardDeploy -FullPath 'URL_To_Main_Folder_Of_Your_App_Project1' -PackgName 'sharepoint\solution\YOUR_PACKAGE_NAME1.sppkg'
            StandardDeploy -FullPath 'URL_To_Main_Folder_Of_Your_App_Project2' -PackgName 'sharepoint\solution\YOUR_PACKAGE_NAME2.sppkg'
            StandardDeploy -FullPath 'URL_To_Main_Folder_Of_Your_App_Project3' -PackgName 'sharepoint\solution\YOUR_PACKAGE_NAME3.sppkg'
         }
     }
     pause
 }
 until ($selection -eq 'q')
