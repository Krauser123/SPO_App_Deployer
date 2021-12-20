# In this Script we add the app and also we update all apps instances in sub sites
# This version is more suitable for deployments through Pipelines
# You need Node v8.17

#Vars
$tenant = "myDemoTenantName"
$username= "myName@myTenant.onmicrosoft.com"
$password = "myPassword"
$packagePath = "myLocalFolder/sharepoint/solution/myPackage.sppkg"
$siteCollectionURL = "https://myDemoTenantName.sharepoint.com/sites/mySite"

#Install PnP Cli Microsoft365
install -g @pnp/cli-microsoft365@latest

#Login in your tenant (without user interaction)
m365 login --authType password --userName $username --password $password

#If is the first time we need to add the package first #(We add ErrorAction because the command fails if the app already are installed)
m365 spo app add -p $packagePath -s tenant -u https://$tenant.sharepoint.com/ --overwrite -ErrorAction SilentlyContinue

#Get app properties
$getAppInfo = m365 spo app get --name $packageName -o json | ConvertFrom-Json

#Get subsites
$subWebs = m365 spo web list --webUrl $siteCollectionURL -o json | ConvertFrom-Json

foreach ($subWeb in $subWebs) {  
    [array]$simplifiedWebs += [pscustomobject][ordered]@{
        Type = "web"
        Title = $subWeb.Title
        Url = $subWeb.Url
        Id = $subWeb.Id
    }
}

Write-Host "Subsites found " $simplifiedWebs.Count

#Update in parent
m365 spo app upgrade --siteUrl $siteCollectionURL --id $getAppInfo.ID

#Iterate over subWebs
foreach ($web in $simplifiedWebs) {
    
    Write-Host "Get apps for web" $web.Url
    $appsInSite = m365 spo app instance list --siteUrl $web.Url -o json | ConvertFrom-Json

    #Iterate over apps in web
    foreach ($appInSite in $appsInSite) {
        #If the apps appears in this web
        if($appInSite.Title -eq $getAppInfo.Title){
            #Update App
            Write-Host "Updating " $getAppInfo.Title " in: " $web.Url
            m365 spo app upgrade --siteUrl $web.Url --id $getAppInfo.ID
        }
    }
}
