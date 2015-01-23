# variable definition
$importFolderPath = $(split-path -parent $MyInvocation.MyCommand.Definition)
$error = $false

# try to import bootstrapper.
# failes if PS version is in bootstrapper not supported.
try{
	. $(Join-Path $importFolderPath "..\config\bootstrapper.ps1")
}catch{
	"Error in {0} at line: {1}, offset: {2}.`n{3}" -f $_.InvocationInfo.ScriptName, $_.InvocationInfo.ScriptLineNumber, $_.InvocationInfo.OffsetInLine, $_
	$error = $true
}