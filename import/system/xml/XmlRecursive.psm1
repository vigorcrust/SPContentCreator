function Invoke-XmlRecursive{
    param(
        $XmlDocOrElement,
        [String]$FunctionToCall,
        $IncrementalAttributes,
        $PersistentData = $(New-Object PSObject),
        $Level = -1
    )
    $Level++
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
            $object | Add-Member NoteProperty Level $Level

            # Create empty array with 100 levels, may need to be increased
            $ar = ,"" * 100
            
            if ($IncrementalAttributes -contains $nodeName){
                if(!$PersistentData."i_$nodeName"){
                    $ar[$Level] = $nodeValue
                }else{
                    $ar = $PersistentData."i_$nodeName"
                    $ar[$Level] = $nodeValue
                }

                $PersistentData | Add-Member Noteproperty "i_$($nodeName)" $ar -Force
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

		Invoke-XmlRecursive -xmlDoc $node -functionToCall $FunctionToCall -IncrementalAttributes $IncrementalAttributes -PersistentData $PersistentData -Level $Level
	}
}