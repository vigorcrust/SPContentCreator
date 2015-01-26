param(
	[String]$ConfigFile = "$(split-path -parent $MyInvocation.MyCommand.Definition)\config\structure.json",
    [Switch]$WhatIf = $true
)

if ($WhatIf.IsPresent){$Global:WhatIf = $true}

. "$(split-path -parent $MyInvocation.MyCommand.Definition)\import\helper.ps1"
if ($script:apperror){exit}

# For development purposes
cls

# Import nesessary Modules
import system.utils.convert
import system.xml
import sharepoint.custom

# Variable declaration
$incrementalAttributes = "url" # Creates a "i_url" in $ComplexObject.Persistent

# Import Json file and convert to xml
$configAsXml = Convert-JsonToXml -Json $(Get-Content -Path $ConfigFile -Raw)
# Cleanup type unneeded type attributes - it is not needed but may come in handy
Select-Xml -Xml $configAsXml -XPath "//*/@type" | Select-Object -ExpandProperty Node | ForEach-Object { $_.OwnerElement.RemoveAttributeNode($_) | Out-Null}

# Main App starts here
 function processNode{
    param(
        $ComplexObject  #$complexObject.Key 
                        #$complexObject.Value 
                        #$complexObject.Node 
                        #$complexObject.Parent 
                        #$ComplexObject.Persistent
                        #$ComplexObject.Level
    )

    $attributes = $ComplexObject.Node.SelectNodes("./*[not(*)]")

    if ($attributes.count -ne 0){
        if($Global:WhatIf){
            Write-Host "Call Method: $($ComplexObject.Key)" -ForegroundColor Green
        }
        $object = New-Object PSObject
        foreach ($att in $attributes){
            $object | Add-Member Noteproperty $att.LocalName $att.'#text'
        }
        for($i=0; $i -le $ComplexObject.Level; $i++){
            if ($ComplexObject.Persistent.i_url.count -gt 0){
                if ($ComplexObject.Persistent.i_url[$i] -ne ""){
                    $url += $ComplexObject.Persistent.i_url[$i]
                }
            }
        }
        $object | Add-Member Noteproperty WorkingUrl $url
        $object | Add-Member NoteProperty Detailed $ComplexObject
        
        Invoke-Function -functionToCall $complexObject.Key -objectToPass $object
    }
}

# Invoke the recursive parse function
Invoke-XmlRecursive -XmlDocOrElement $configAsXml -FunctionToCall processNode -IncrementalAttributes $incrementalAttributes