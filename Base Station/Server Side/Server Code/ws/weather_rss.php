<?php
 header("Content-Type: application/xml; charset=ISO-8859-1"); 
//ok now to output the data as an rss feed!


foreach($_GET as $variable => $value )
{
    


   if($variable == "station")
	{
   	$station= $value;
	}
	

}

require('dbconnect.php');
  

  $query = 'SELECT * FROM station where station_no='.$station;
  $result = mysql_query($query) or die('<p>Error executing query</p>');


$num_results = mysql_num_rows($result);
  

   for ($i=0; $i < $num_results; $i++)
  {
	
    $row = mysql_fetch_array($result);
	$station_name = $row['station_name'];
	$station_location = $row['station_location'];
	
	
  }
  
  
  




echo '<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">';
echo ' <channel>';
echo ' <title>the weather at '.$station_name.'</title>';
echo ' <link>http://www.abertay.ac.uk</link>';
echo '<description>This is the weather recorded at '.$station_name.' which is located '.$station_location.'</description>';
echo '<generator>Generated from a database of information gathered automatically from weatherstations developed and maintained by abertay university</generator>';
echo '<pubDate>'.date("Y.m.d H:i:s").'</pubDate>';
echo '<atom:link href="http://uadwww03.uad.ac.uk/~0804093/weather/weather.php" rel="self" type="application/rss+xml" />';

$minutes_remaining = 60 - date(i);

echo '<ttl>'.$minutes_remaining.'</ttl>';

//ok now output the items baby!
require('dbconnect.php');
  

  $query = 'SELECT * FROM weather_data where station='.$station.' ORDER BY date DESC';
  $result = mysql_query($query) or die('<p>Error executing query</p>');


$num_results = mysql_num_rows($result);
  

   for ($i=0; $i < 1; $i++)
  {
	
    $row = mysql_fetch_array($result);
	
	echo '<item>';
	echo '<title>The weather at '.$station_location.'</title>';
	echo '<pubDate>'.$row['date'].'</pubDate>';
	
    echo '<enclosure url="http://uadwww03.uad.ac.uk/~0804093/weather/uploads/'.$row['picture'].'.gif" length="'.$row['pic_size'].'" type="image/gif" />';

	echo '<description>';
	echo 'wind direction: '.$row['wind'].' '.$row['quadrant'].' <br />';
	echo 'wind speed: '.$row['w_speed'].'<br />';
	echo 'temperature: '.($row['temp'] - 30).'<br />';
	echo 'rainfall: '.$row['rain'].'<br />';
	
	echo '</description>';
	echo '</item>';
  }





echo ' </channel>';
echo '</rss>';

 
 
 

?>
