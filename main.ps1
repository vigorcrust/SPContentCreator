param(
	[String]$ConfigFile = "$(split-path -parent $MyInvocation.MyCommand.Definition)\config\structure.json"
)

. "$(split-path -parent $MyInvocation.MyCommand.Definition)\import\helper.ps1"
if ($script:apperror){exit}

Remove-Module XmlRecursive
cls

# Import nesessary Modules
import system.utils.convert
import system.xml

# Main App starts here
 function processNode{
    param(
        $ComplexObject  #$complexObject.Key 
                        #$complexObject.Value 
                        #$complexObject.Node 
                        #$complexObject.Parent 
                        #$ComplexObject.Persistent
    )

    $attributes = $ComplexObject.Node.SelectNodes("./*[not(*)]")

    if ($attributes.count -ne 0){
        Write-Host "Call Method: $($ComplexObject.Key)" -ForegroundColor Green
        foreach ($att in $attributes){
            "$($att.LocalName) - $($att.'#text')"
        }
        Write-Host "$($ComplexObject.Persistent.i_url)" -ForegroundColor Magenta
    }
}

$incrementalAttributes = "url" # Creates a "i_url" in $ComplexObject.IncrementalAttributes

# Import Json file and convert to xml
$configAsXml = Convert-JsonToXml -Json $(Get-Content -Path $ConfigFile -Raw)
#Invoke-XmlRecursive -XmlDocOrElement $configAsXml.FirstChild -FunctionToCall processNode -IncrementalAttributes $incrementalAttributes

#$configAsXml.OuterXml

#Select-Xml -Xml $configAsXml -XPath "//*/@type" | Select-Object -ExpandProperty Node | ForEach-Object { $_.OwnerElement.RemoveAttributeNode($_) | Out-Null}

$newXml = $configAsXml


function displayLevel($NodeList, $level = -1){
    $level++
    if($NodeList -and $NodeList.Count -gt 0){

    foreach($node in $NodeList){
       if($node.NodeType -ne "Text"){
            if ($node.type -ne "object"){
                $nodeValue = $node.'#text'
            }
            "`t" * $level + "$($node.localname):$nodeValue"
       }
       
       displayLevel -NodeList $node.ChildNodes -level $level
     }
     }else{
        return
     }
}
displayLevel -NodeList $newXml.ChildNodes