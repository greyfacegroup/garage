#Add - PSSnapin Microsoft.SharePoint.PowerShell - ErrorAction SilentlyContinue  
#Load SharePoint CSOM Assemblies  
Add - Type - Path "C:\Program Files\SharePoint Online Management Shell\Microsoft.Online.SharePoint.PowerShell\Microsoft.SharePoint.Client.dll"  
Add - Type - Path "C:\Program Files\SharePoint Online Management Shell\Microsoft.Online.SharePoint.PowerShell\Microsoft.SharePoint.Client.Runtime.dll"  
Add - Type - Path "C:\Program Files\SharePoint Online Management Shell\Microsoft.Online.SharePoint.PowerShell\Microsoft.Online.SharePoint.Client.Tenant.dll"  
Import - Module Microsoft.Online.SharePoint.Powershell - DisableNameChecking  
#Import - Module‘ C: \Program Files\ SharePoint Online Management Shell\ Microsoft.Online.SharePoint.PowerShell’ - DisableNameChecking  
#Config Parameters  
$ReportOutput = "D:\Output\SPOListInfo_$(get-date -f yyyy-MM-dd).csv"  
#Get All Site collections from the Tenant - Including Modern Team sites and communication sites  
Function Get-SPOSites($AdminSiteURL, $Cred) {  
    #Setup credentials to connect  
    $Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)  
    #Array to store Result  
    $ResultSet = @()  
    #Setup the context  
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($AdminSiteURL)  
    $Ctx.Credentials = $Credentials  
    #Get the tenant object  
    $Tenant = New-Object Microsoft.Online.SharePoint.TenantAdministration.Tenant($ctx)  
    #Get All Site Collections  
    $SiteCollections = $Tenant.GetSitePropertiesFromSharePoint(0, $true)  
    $Ctx.Load($SiteCollections)  
    $Ctx.ExecuteQuery()  
    #Iterate through Each site collection  
    ForEach($Site in $SiteCollections) {  
        Write-Host "Processing Site Collection :"  
        $Site.URL -f Yellow
        $ctx = New-Object Microsoft.SharePoint.Client.ClientContext($Site.Url)  
        $Ctx.Credentials = $credentials  
        $rootweb = $Ctx.Web  
        $childWebs = $rootweb.Webs  
        $Ctx.Load($rootweb)  
        $Ctx.Load($childWebs)  
        #Check the Feature Status  
        $SiteFeatureId = "E3540C7D-6BEA-403C-A224-1A12EAFEE4C4"  
        $FeatureStatus = $rootweb.Features.GetById($SiteFeatureId)  
        $FeatureStatus.Retrieve("DefinitionId")  
        $Ctx.Load($FeatureStatus)  
        $Ctx.ExecuteQuery()  
        $lists = $rootweb.Lists  
        $Ctx.Load($lists)  
        $Ctx.ExecuteQuery()  
        foreach($list in $lists) {  
            #Get site collection details  
            $Result = new - object PSObject  
            $Result | add-member -membertype NoteProperty -name "Title" -Value $Site.Title  
            $Result | add-member -membertype NoteProperty -name "Url" -Value $Site.Url  
            #$Result | add-member -membertype NoteProperty -name "SiteExperience" -Value $Site.Features["E3540C7D-6BEA-403C-A224-1A12EAFEE4C4"] # - eq $null) {  
            "Classic"  
        } else {  
            "Modern"  
        }  
        if ($FeatureStatus.DefinitionId - ne $null) {  
            $Result | add-member -membertype NoteProperty -name "Site Experience" -Value 'Modern'  
        } else {  
            $Result | add-member -membertype NoteProperty -name "Site Experience" -Value 'Classic'  
        }  
        $Result | add-member -membertype NoteProperty -name "List Title" -Value $list.Title  
        $Result | add-member -membertype NoteProperty -name "List ItemCount" -Value $list.ItemCount  
        $Result | add-member -membertype NoteProperty -name "List Experience" -Value $list.ListExperienceOptions  
        $Result | add-member -membertype NoteProperty -name "List BaseTemplateID" -Value $list.BaseTemplate  
        $Result | add-member -membertype NoteProperty -name "List Created" -Value $list.Created  
        $Result | add-member -membertype NoteProperty -name "List BaseType" -Value $list.BaseType  
        $Result | add-member -membertype NoteProperty -name "List Hidden" -Value $list.Hidden  
        $Result | add-member -membertype NoteProperty -name "List Id" -Value $list.Id  
        $Result | add-member -membertype NoteProperty -name "List LastItemModifiedDate" -Value $list.LastItemModifiedDate  
        $Result | add-member -membertype NoteProperty -name "List ParentWebUrl" -Value $list.ParentWebUrl  
        $Result | add-member -membertype NoteProperty -name "List Description" -Value $list.Description  
        $ResultSet += $Result  
    }  
    #$ctx = New - Object Microsoft.SharePoint.Client.ClientContext($Site.Url)  
    #$ctx.Credentials = $Credentials  
    #$Web = $ctx.Web  
    #$ctx.Load($web)  
    # $ctx.Load($web.Webs)  
    # $ctx.executeQuery()  
    # $Site = $Ctx.Web  
    # $Ctx.Load($Site)  
    # $Ctx.Load($Site.Webs)  
    # $Ctx.executeQuery()  
    foreach($web in $childWebs) {  
        #$web = $Ctx.Web  
        Write - Host "Processing subsite :"  
        $web.URL - f Green  
        #Check the Feature Status  
        $WebFeatureId = "52E14B6F-B1BB-4969-B89B-C4FAA56745EF"  
        $FeatureStatus = $web.Features.GetById($WebFeatureId)  
        $FeatureStatus.Retrieve("DefinitionId")  
        $Ctx.Load($FeatureStatus)  
        $Ctx.ExecuteQuery()  
        $lists = $web.Lists  
        $ctx.Load($lists)  
        $ctx.ExecuteQuery()  
        foreach($list in $lists) {  
            #Get site collection details  
            $Result = new - object PSObject  
            $Result | add-member -membertype NoteProperty -name "Title" -Value $web.Title  
            $Result | add-member -membertype NoteProperty -name "Url" -Value $web.Url  
            #$Result | add-member -membertype NoteProperty -name "SiteExperience" -Value $web.Features["52E14B6F-B1BB-4969-B89B-C4FAA56745EF"] # - eq $null) {  
            "Classic"  
        } else {  
            "Modern"  
        }  
        #if((Get-SPFeature -Identity {  
            52E14 B6F-B1BB-4969-B89B-C4FAA56745EF  
        } -ErrorAction SilentlyContinue -Web) -ne $null) {  
            if ($FeatureStatus.DefinitionId -ne $null) {  
                $Result | add-member -membertype NoteProperty -name "Site Experience" -Value 'Modern'  
            } else {  
                $Result | add-member -membertype NoteProperty -name "Site Experience" -Value 'Classic'  
            }  
            $Result | add-member -membertype NoteProperty -name "List Title" -Value $list.Title  
            $Result | add-member -membertype NoteProperty -name "List ItemCount" -Value $list.ItemCount  
            $Result | add-member -membertype NoteProperty -name "List Experience" -Value $list.ListExperienceOptions  
            $Result | add-member -membertype NoteProperty -name "List BaseTemplateID" -Value $list.BaseTemplate  
            $Result | add-member -membertype NoteProperty -name "List Created" -Value $list.Created  
            $Result | add-member -membertype NoteProperty -name "List BaseType" -Value $list.BaseType  
            $Result | add-member -membertype NoteProperty -name "List Hidden" -Value $list.Hidden  
            $Result | add-member -membertype NoteProperty -name "List Id" -Value $list.Id  
            $Result | add-member -membertype NoteProperty -name "List LastItemModifiedDate" -Value $list.LastItemModifiedDate  
            $Result | add-member -membertype NoteProperty -name "List ParentWebUrl" -Value $list.ParentWebUrl  
            $Result | add-member -membertype NoteProperty -name "List Description" -Value $list.Description  
            $ResultSet += $Result  
        }  
    }  
}  
#Export Result to csv file  
$ResultSet | Export-Csv $ReportOutput -notypeinformation  
}  
#Set Parameters  
$AdminSiteUrl = "https://raedas-admin.sharepoint.com"  
$Cred = Get-Credential  
#sharepoint online powershell list all sites  
Get-SPOSites -AdminSiteURL $AdminSiteUrl -Cred $Cred