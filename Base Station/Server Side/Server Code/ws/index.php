<html>
<head>
	<title>Base Station Page</title>
</head>
<body align="center">
<div align="center">
<img src="University_of_Abertay_Dundee,computer_security.jpg" />
<h1>University of Abertay Dundee Base Station</h1>
<?php
echo "<p>The time is: ".date("Y-m-d G:i:s")."</p><br />";
$start = date("Y-m-d G:i:s");
require('dbconnect.php');
  

  $query = 'SELECT *,DATE_FORMAT(ttl,"%h:%i %p %d %b %Y") as disp_ttl FROM station';
  $result = mysql_query($query) or die('<p>Error executing query</p>');


$num_results = mysql_num_rows($result);
  

   for ($i=0; $i < $num_results; $i++)
  {
	
    $row = mysql_fetch_array($result);
	echo "Station name: ".$row['station_name']."<br />located: ".$row['station_location']."<br />next update: ".$row['disp_ttl']."<br />";
	echo "Status: ";
	$end = $row['ttl'];
											  

							  $query2 = 'SELECT * FROM `station` WHERE DATE_ADD(now(),INTERVAL 5 MINUTE) > ttl AND station_no='.$row['station_no'];
							  $result2 = mysql_query($query2) or die('<p>Error executing query</p>');
							  $num_results2 = mysql_num_rows($result2);
							  
							  
							  $query3 = 'SELECT * FROM `station` WHERE DATE_SUB(now(),INTERVAL 1 MINUTE) > ttl AND station_no='.$row['station_no'];
							  $result3 = mysql_query($query3) or die('<p>Error executing query</p>');
							  $num_results3 = mysql_num_rows($result3);
							  

							if($num_results3 > 0)
							{
							echo "<FONT COLOR='#ff0000'>Station is overdue</FONT>";
							
							if( $diff=@get_time_difference($end, $start) )
											{
											  echo "<br />Station is overdue by: ".$diff['days']." days, ".$diff['hours']." hours, ".$diff['minutes']." minutes.";
											}
											else
											{
											  echo "Hours: Error";
											}
							
																		
							 } 
							 else if($num_results2 > 0)
							 {
							 	echo "<FONT COLOR='#0000ff'>Station is preparing to update</FONT>";
								
								if( $diff=@get_time_difference($start, $end) )
											{
											  echo "<br />Time till next update: ".$diff['days']." days, ".$diff['hours']." hours, ".$diff['minutes']." minutes.";
											}
											else
											{
											  echo "Hours: Error";
											}
								
							 } else
							 {
							 echo "<FONT COLOR='#00ff00'>Station is ok</FONT>";
							 
											if( $diff=@get_time_difference($start, $end) )
											{
											  echo "<br />Time till next update: ".$diff['days']." days, ".$diff['hours']." hours, ".$diff['minutes']." minutes.";
											}
											else
											{
											  echo "Hours: Error";
											}
							 
							 }

	echo "<br />Comment: ".$row['comment']."<br />";			
	echo "<a href='http://localhost/ws/weather_xml.php?station=".$row['station_no']."'>View raw feed</a><br />";
	echo "<a href='http://localhost/ws/view.php?station=".$row['station_no']."'>View formatted feed</a><br />";			
	
	echo "<br /><br />";
  }
  
  function get_time_difference( $start, $end )
{
    $uts['start']      =    strtotime( $start );
    $uts['end']        =    strtotime( $end );
    if( $uts['start']!==-1 && $uts['end']!==-1 )
    {
        if( $uts['end'] >= $uts['start'] )
        {
            $diff    =    $uts['end'] - $uts['start'];
            if( $days=intval((floor($diff/86400))) )
                $diff = $diff % 86400;
            if( $hours=intval((floor($diff/3600))) )
                $diff = $diff % 3600;
            if( $minutes=intval((floor($diff/60))) )
                $diff = $diff % 60;
            $diff    =    intval( $diff );            
            return( array('days'=>$days, 'hours'=>$hours, 'minutes'=>$minutes, 'seconds'=>$diff) );
        }
        else
        {
            trigger_error( "Ending date/time is earlier than the start date/time", E_USER_WARNING );
        }
    }
    else
    {
        trigger_error( "Invalid date/time data detected", E_USER_WARNING );
    }
    return( false );
}
  
  
?>
</div>
</body>
</html>
