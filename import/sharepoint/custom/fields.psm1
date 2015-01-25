function fields{
    param($complexObject)

    $spWeb = Get-SPWeb $complexObject.WorkingUrl
    $ct = $spWeb.ContentTypes[$complexObject.Detailed.Parent.name]

    if(!$complexObject.wildcardfields -and $complexObject.wildcardfields -ne ""){
        $wildCardFields = $spWeb.Fields | where {$_.Title -like $complexObject.wildcardfields}
        foreach ($field in $wildCardFields) {
            $link = New-Object Microsoft.SharePoint.SPFieldLink $field
            $createdCT.FieldLinks.Add($link)    
        }
    }
    if(!$complexObject.matchfield -and $complexObject.matchfield -ne ""){
        $wildCardFields = $spWeb.Fields | where {$_.Title -eq $complexObject.matchfield}
        foreach ($field in $matchfield) {
            $link = New-Object Microsoft.SharePoint.SPFieldLink $field
            $createdCT.FieldLinks.Add($link)    
        }
    }

    $ct.Update()
    

}