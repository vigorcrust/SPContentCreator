function website{
    param($complexObject)
    if($Global:WhatIf){
        
    }
    echo "Creating website with url: $($complexObject.WorkingUrl + $complexObject.url) and perform $($complexObject.action)."
    echo "Some have a names:$($complexObject.name)"    
}