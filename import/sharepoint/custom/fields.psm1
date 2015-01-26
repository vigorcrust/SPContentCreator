function fields{
    param($complexObject)

    if($Global:WhatIf){
        "Opening SpWeb: $($complexObject.WorkingUrl)."
        "Getting CT: $($complexObject.Detailed.Parent.name)."
        "Field(s) is of type: $($complexObject.type)"
        "Matching following: $($complexObject.matchfield)" 
    }else{
        $spWeb = Get-SPWeb $complexObject.WorkingUrl
        $ct = $spWeb.ContentTypes[$complexObject.Detailed.Parent.name]
    
        if($complexObject.type -eq "wildcard"){
            $fields = $spWeb.Fields | where {$_.Title -like $complexObject.matchfield}
        }elseif($complexObject.type -eq "match"){
            $fields = $spWeb.Fields | where {$_.Title -eq $complexObject.matchfield}
        }
        foreach ($field in $fields) {
            $link = New-Object Microsoft.SharePoint.SPFieldLink $field
            $createdCT.FieldLinks.Add($link)    
        }
        $ct.Update()
    }
}