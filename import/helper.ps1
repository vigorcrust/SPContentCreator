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
        [String]$Namespace = "system"
    )

    $namespacePath = $(Join-Path $script:importFolderPath $($Namespace.Replace(".","\")))
    
    if ($(Test-Path $namespacePath)){
        Write-Host ("Import Modules from Namespace: {0}" -f $Namespace)

        $files = Get-ChildItem $namespacePath -Recurse -Filter *.psm1

        foreach ($scriptPath in $files.FullName){
            "import $scriptPath"
            Import-Module $scriptPath -Force
        }
    }else{
        Write-Host ("Namespace '{0}' could not be loaded" -f $Namespace) -ForegroundColor Red
    }
}

function Invoke-Function{
    param(
        [String]$FunctionToCall,
        $ObjectToPass
    )
    $getFunction = get-command $FunctionToCall -CommandType Function
    $sb = $getFunction.ScriptBlock
    Invoke-Command -ScriptBlock $sb -ArgumentList $ObjectToPass
}