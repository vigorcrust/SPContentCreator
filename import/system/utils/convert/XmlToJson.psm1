Add-Type -Assembly System.ServiceModel.Web
Add-Type -Assembly System.Runtime.Serialization

function Convert-XmlToJson
{
    param(
        [Xml]$Xml
    )
    $memStream = new-object System.IO.MemoryStream
    $jsonWriter = [System.Runtime.Serialization.Json.JsonReaderWriterFactory]::CreateJsonWriter($memStream)
    try
    {
        $Xml.Save($jsonWriter)
        $bytes = $memStream.ToArray()
        [System.Text.Encoding]::UTF8.GetString($bytes,0,$bytes.Length)
    }
    finally
    {
        $jsonWriter.Close()
    }
}