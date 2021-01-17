#                  #
# SCRIPT FUNCTIONS #
#                  #

function Show-Menu
{
    Write-Output '================ SPO APP Deployer ================'
    Write-Output 'Use this script carefully - Check URL and user twice.' -f red
    Write-Output 'Three time if you are trying to done something in PRODUCTION environments' -f red
    Write-Output '========================================================'
    
    Write-Output '1: Press '1' to deploy 'YOUR_PACKAGE_FRIENDLY_NAME1'.'
    Write-Output '2: Press '2' to deploy 'YOUR_PACKAGE_FRIENDLY_NAME2.''
    Write-Output '3: Press '3' to deploy 'YOUR_PACKAGE_FRIENDLY_NAME3'.'
    Write-Output '4: Press '4' to deploy all apps.'
    Write-Output 'Q: Press 'Q' to quit.'
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
Clear-Output
$tennantUrl = Read-Output 'URL of tennant to connect'
Write-Output 'You re trying to connect to ' -f yellow -NoNewline
Write-Output -f red $tennantUrl 
Connect-PnPOnline -Url $tennantUrl -Credentials (Get-Credential)

do
 {
    Show-Menu
     $selection = Read-Output 'Please select a option'
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
