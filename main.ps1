param(
	[String]$ConfigFile = "$(split-path -parent $MyInvocation.MyCommand.Definition)\config\structure.json"
)

. "$(split-path -parent $MyInvocation.MyCommand.Definition)\import\helper.ps1"
if ($script:apperror){exit}

# Import nesessary Modules
import system.utils.convert
import system.xml

# Main App starts here

function processNode{
    param(
        $ComplexObject   #$complexObject.Key $complexObject.Value $complexObject.Node
    )
    "$($complexObject.Key) - $($complexObject.Value)"
}

# $incrementalAttributes = "url"

# Import Json file and convert to xml
$configAsXml = Convert-JsonToXml -Json $(Get-Content -Path $ConfigFile -Raw)
Invoke-XmlRecursive -XmlDocOrElement $configAsXml.FirstChild -FunctionToCall processNode