function Invoke-XmlRecursive{
    param(
        $XmlDocOrElement,
        [String]$FunctionToCall
    )
	foreach ($node in $XmlDocOrElement.ChildNodes){
        if($node.NodeType -ne "Text"){
            $nodeName = $node.LocalName
            if ($node.type -ne "object"){
                $nodeValue = $node.'#text'
            }
            $object = New-Object PSObject                                       
            $object | add-member Noteproperty Key $nodeName
            $object | add-member Noteproperty Value $nodeValue
            $object | add-member Noteproperty Node $node

            Invoke-Function -FunctionToCall $FunctionToCall -ObjectToPass $object
        }
		Invoke-XmlRecursive -xmlDoc $node -functionToCall $FunctionToCall
	}
}