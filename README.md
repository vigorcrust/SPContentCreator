# SPContentCreator
PowerShell script to create structures, set configurations and add contents to a SharePoint farm.

## Folder Structure
- config: 	holding bootstrapper and additional config files
- data:		holding data for uploading files to SharePoint
- import:	main import folder for scripts holding different functions
	- system:	basic scripts
		-utils:	utility and tool like scripts
		-error:	error handling and printing

## How does it work.
### Configure the Structure
The configuration is written in JSON.

## The Code
### Import
You can import Script-Modules with a helper function "import", which imports them and all functions defined within the namespace will be imported.
Example:

import system.utils

This imports all ".psm1" files from ".\import\system\utils\*" recursivly into the script and all functionctions will be available		
