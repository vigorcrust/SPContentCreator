. "$(split-path -parent $MyInvocation.MyCommand.Definition)\import\helper.ps1"
if ($script:apperror){exit}

import system.utils.convert

Convert-JsonToXml