param(
	$ConfigFile = "$(split-path -parent $MyInvocation.MyCommand.Definition)\config\structure.json"
)

. "$(split-path -parent $MyInvocation.MyCommand.Definition)\import\helper.ps1"
if ($script:apperror){exit}

# Import nesessary Modules
import system.utils.convert

# Main App starts here

# Import Json file and convert to xml
$configAsXml = Convert-JsonToXml -json $(Get-Content -Path $ConfigFile -Raw)
