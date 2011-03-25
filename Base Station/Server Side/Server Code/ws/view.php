<?php
ini_set("display_errors", 1);
error_reporting(E_ALL); 

 $xp = new XsltProcessor();
// create a DOM document and load the XSL stylesheet
  $xsl = new DomDocument;
  $xsl->load('estate.xsl');
  
  // import the XSL styelsheet into the XSLT process
  $xp->importStylesheet($xsl);
  
  $updates=1;
  foreach($_GET as $variable => $value )
{
    


 	if($variable == "updates")
	{
   	$updates= $value;
	}
	if($variable == "station")
	{
   	$station= $value;
	}
	

}
  
  
   // create a DOM document and load the XML data
  $xml_doc = new DomDocument;
  $xml_doc->load('station_weather_xml.php?station='.$station.'&updates='.$updates);
  
   // transform the XML into HTML using the XSL file
  if ($html = $xp->transformToXML($xml_doc)) {
  
  $html = str_replace("<?xml version=\"1.0\"?>","",$html);
      echo $html;
  } else {
      trigger_error('XSL transformation failed.', E_USER_ERROR);
  } // if 
  
  if($updates==1)
  {
  $updates=0;
  }
  echo "<a href=view.php?station=".$station."&updates=".($updates+5).">View the last ".($updates+5)." updates </a>";
?>
