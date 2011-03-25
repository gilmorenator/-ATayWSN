<?php
ini_set("display_errors", 1);
error_reporting(E_ALL); 

foreach($_GET as $variable => $value )
{
    


   if($variable == "station")
	{
   	$station= $value;
	}

}

require('dbconnect.php');
 
  $query = 'SELECT * FROM data where station='.$station.' ORDER BY date DESC';
  $result = mysql_query($query) or die('<p>Error executing query</p>');
  $num_results = mysql_num_rows($result);
  $row = mysql_fetch_array($result);
 
 echo "<html>";
	echo "<head>";
	echo "	<title>panorama</title>";
	echo "	<script language='JavaScript' src='panorama.js' type='text/javascript'></script>";
	echo "</head>";
	echo "<body bgcolor=#eeeeee>";
	echo "	<div id='panorama' style='margin:25px;'><img src='pic.jpg' style='width:400px;height:100px;' /></div>";
	echo "</body>";
echo "</html>";
?>
