function contenttype{
    param($complexObject)
    if($Global:WhatIf){
        "Opening SpWeb: $($complexObject.WorkingUrl)."
        "Creating CT: $($complexObject.name)"
        "CT Type: $($complexObject.type)"
        "CT Desc: $($complexObject.desc)"
    }else{
        if ($complexObject.action -eq "create"){
            $contentTypeName = $complexObject.name
            $spWeb = Get-SPWeb $complexObject.WorkingUrl
            $ctTemplate = $sp.AvailableContentTypes[$complexObject.type]
            $ctCollection = $sp.ContentTypes
            $newCtTemplate = New-Object Microsoft.SharePoint.SPContentType -ArgumentList  @($ctTemplate, $ctCollection, $contentTypeName)
            $newCt = $spWeb.ContentTypes.Add($newCtTemplate)
            $newCt.Description = $complexObject.desc
            $newCt.Update()
        }
    }
}