<?php
ini_set("display_errors", 1);
error_reporting(E_ALL); 

header("Content-Type: application/xml; charset=ISO-8859-1"); 
//ok now to output the data as an rss feed!
?><?xml version="1.0" ?><?php







$updates=0;

foreach($_GET as $variable => $value )
{
    


   if($variable == "station")
	{
   	$station= $value;
	}
	if($variable == "updates")
	{
   	$updates= $value;
	}
	

}

require('dbconnect.php');
  

 
echo '<station>';






  $query = 'SELECT *,DATE_FORMAT(date,"%h:%i %p %d %b %Y") as disp_date FROM data where station='.$station.' ORDER BY date DESC';
  $result = mysql_query($query) or die('<p>Error executing query</p>');


$num_results = mysql_num_rows($result);
  
if($updates==0)
	{
   for ($i=0; $i < $num_results; $i++)
  {
	
    $row = mysql_fetch_array($result);
	
	if ($i ==0)
	{
	$lastupdate = $row['date'];
	
	}
	
	echo '<entry>';
	echo '<datetime>'.$row['disp_date'].'</datetime>';
	echo '<picture>http://localhost/ws/uploads/'.$row['picture'].'.gif</picture>';
	echo '<picture_left>http://localhost/ws/uploads/'.$row['picture'].'_left.gif</picture_left>';
	echo '<picture_right>http://localhost/ws/uploads/'.$row['picture'].'_right.gif</picture_right>';
	echo '<picture_farleft>http://localhost/ws/uploads/'.$row['picture'].'_farleft.gif</picture_farleft>';
	echo '<picture_farright>http://localhost/ws/uploads/'.$row['picture'].'_farright.gif</picture_farright>';
	echo '<wind_direction>'.$row['wind'].'</wind_direction>';
	echo '<quadrant>'.$row['quadrant'].'</quadrant>';
	echo '<wind_speed>'.round((($row['w_speed']/100)/2700),2).'</wind_speed>';
	echo '<temperature>'.($row['temp']/100).'</temperature>';
	echo '<rainfall>'.round(($row['rain']/86400),2).'</rainfall>';
	echo '<voltage>'.($row['voltage']/100) .'</voltage>';
	echo '</entry>';
	
  }

}
else //ok they specified how many entries they want  
{

for ($i=0; $i < $num_results; $i++)
  {
	if($i<$updates)
	{
    $row = mysql_fetch_array($result);
	
	 if ($i ==0)
	{
	$lastupdate = $row['date'];
	
	}
	
	echo '<entry>';
	echo '<datetime>'.$row['disp_date'].'</datetime>';
	echo '<picture>http://localhost/ws/uploads/'.$row['picture'].'.gif</picture>';
	echo '<picture_left>http://localhost/ws/uploads/'.$row['picture'].'_left.gif</picture_left>';
	echo '<picture_right>http://localhost/ws/uploads/'.$row['picture'].'_right.gif</picture_right>';
	echo '<picture_farleft>http://localhost/ws/uploads/'.$row['picture'].'_farleft.gif</picture_farleft>';
	echo '<picture_farright>http://localhost/ws/uploads/'.$row['picture'].'_farright.gif</picture_farright>';
	echo '<wind_direction>'.$row['wind'].'</wind_direction>';
	echo '<quadrant>'.$row['quadrant'].'</quadrant>';
	echo '<wind_speed>'.round((($row['w_speed']/100)/2700),2).'</wind_speed>';
	echo '<temperature>'.($row['temp']/100).'</temperature>';
	echo '<rainfall>'.round(($row['rain']/86400),2).'</rainfall>';
	echo '<voltage>'.($row['voltage']/100) .'</voltage>';
	echo '</entry>';
	}
  }



}
echo '</station>';


 
 
 

?>
