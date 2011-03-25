<?php require('dtdec.php');?>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>weather</title>
  </head>

	<body>
	<p>
	<?php


 $xp = new XsltProcessor();
// create a DOM document and load the XSL stylesheet
  $xsl = new DomDocument;
  $xsl->load('mobile.xsl');
  
  // import the XSL styelsheet into the XSLT process
  $xp->importStylesheet($xsl);
  
   // create a DOM document and load the XML datat
  $xml_doc = new DomDocument;
  
  $xml_doc->load('http://0704672/ws/station_weather_xml.php?updates=1&station=4');

  
   // transform the XML into HTML using the XSL file
  if ($html = $xp->transformToXML($xml_doc)) {
  
  //ok now we are gonna strip all unnecesary text from the results using str_replace 
  $html = str_replace("<?xml version=\"1.0\"?>","",$html);
  echo $html;

  } else {
      trigger_error('XSL transformation failed.', E_USER_ERROR);
  }

?>
</p>
</body>
</html>
