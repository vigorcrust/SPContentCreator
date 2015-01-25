function Invoke-XmlRecursive{
    param(
        $XmlDocOrElement,
        [String]$FunctionToCall,
        $IncrementalAttributes,
        $PersistentData = $(New-Object PSObject)
    )
	foreach ($node in $XmlDocOrElement.ChildNodes){
        if($node.NodeType -ne "Text"){
            $nodeName = $node.LocalName
            if ($node.type -ne "object"){
                $nodeValue = $node.'#text'
            }
            $object = New-Object PSObject                                       
            $object | Add-Member NoteProperty Key $nodeName
            $object | Add-Member NoteProperty Value $nodeValue
            $object | Add-Member NoteProperty Node $node

            if ($IncrementalAttributes -contains $nodeName){
                Write-Host "Found $nodeName" -ForegroundColor Red
                $PersistentData | Add-Member Noteproperty "i_$($nodeName)" $($PersistentData."i_$nodeName" + $nodeValue) -Force
            }
            
            $object | Add-Member NoteProperty Persistent $PersistentData

            $parentAttributes = $XmlDocOrElement.SelectNodes("./*[not(*)]")
            $parentAttributeObject = New-Object PSObject
            foreach ($attribute in $parentAttributes){
                $parentAttributeObject | Add-Member Noteproperty $attribute.LocalName $attribute.'#text'
            }
            $object | Add-Member Noteproperty Parent $parentAttributeObject

            Invoke-Function -FunctionToCall $FunctionToCall -ObjectToPass $object
        }

		Invoke-XmlRecursive -xmlDoc $node -functionToCall $FunctionToCall -IncrementalAttributes $IncrementalAttributes -PersistentData $PersistentData
	}
}