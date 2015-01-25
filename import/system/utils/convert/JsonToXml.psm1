Add-Type -Assembly System.ServiceModel.Web
Add-Type -Assembly System.Runtime.Serialization

function Convert-JsonToXml
{
    param(
        [String]$Json
    )
    $bytes = [byte[]][char[]]$Json
    $quotas = [System.Xml.XmlDictionaryReaderQuotas]::Max
    $jsonReader = [System.Runtime.Serialization.Json.JsonReaderWriterFactory]::CreateJsonReader($bytes,$quotas)
    try
    {
        $xml = new-object System.Xml.XmlDocument
        $xml.Load($jsonReader)
        $xml
    }
    finally
    {
        $jsonReader.Close()
    }
}