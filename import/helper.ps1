# variable definition
$script:importFolderPath = $(split-path -parent $MyInvocation.MyCommand.Definition)
$script:apperror = $false

# try to import bootstrapper.
# failes if PS version is in bootstrapper not supported.
try{
	. $(Join-Path $script:importFolderPath "..\config\bootstrapper.ps1")
}catch{
	Write-Host "Error in {0} at line: {1}, offset: {2}.`n{3}" -f $_.InvocationInfo.ScriptName, $_.InvocationInfo.ScriptLineNumber, $_.InvocationInfo.OffsetInLine, $_
	$script:apperror = $true
}

# print header with all the informations
"{0} {1}`n{3} - {2}`n" -f $ApplicationName,$Version,$Copyright,$Licence

# helper functions
function import {
    param(
        $Namespace = "system"
    )

    $namespacePath = $(Join-Path $script:importFolderPath $($Namespace.Replace(".","\")))
    
    if ($(Test-Path $namespacePath)){
        Write-Host ("Import Libraries from Namespace: {0}" -f $Namespace)

        $files = Get-ChildItem $namespacePath -Recurse -Filter *.ps1

        foreach ($scriptPath in $files.FullName){
            "import $scriptPath"
            . "$scriptPath"
        }
    }else{
        Write-Host ("Namespace '{0}' could not be loaded" -f $Namespace) -ForegroundColor Red
    }
}