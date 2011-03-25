<?php
ini_set("display_errors", 1);
error_reporting(E_ALL); 

header("Content-Type: application/xml; charset=ISO-8859-1"); 
//ok now to output the data as an rss feed!
?><?xml version="1.0" ?><?php

echo "<all_stations>";
require('dbconnect.php');
  $start = date("Y-m-d G:i:s");

  $query = "SELECT *,DATE_FORMAT(ttl,'%h:%i %p %d %b %Y') as disp_ttl FROM station";
  $result = mysql_query($query) or die('<p>Error executing query</p>');
$num_results = mysql_num_rows($result);
  

   for ($i=0; $i < $num_results; $i++)
  {
	
    $row = mysql_fetch_array($result);

		echo '<station>';
	echo '<station_number>'.$row['station_no'].'</station_number>';
	echo '<station_name>'.$row['station_name'].'</station_name>';
echo '<station_location>'.$row['station_location'].'</station_location>';
echo '<next_update>'.$row['disp_ttl'].'</next_update>';

$end = $row['ttl'];
											  

							  $query2 = 'SELECT * FROM `station` WHERE DATE_ADD(now(),INTERVAL 5 MINUTE) > ttl AND station_no='.$row['station_no'];
							  $result2 = mysql_query($query2) or die('<p>Error executing query</p>');
							  $num_results2 = mysql_num_rows($result2);
							  
							  
							  $query3 = 'SELECT * FROM `station` WHERE DATE_SUB(now(),INTERVAL 1 MINUTE) > ttl AND station_no='.$row['station_no'];
							  $result3 = mysql_query($query3) or die('<p>Error executing query</p>');
							  $num_results3 = mysql_num_rows($result3);
							  

							if($num_results3 > 0)
							{
							echo "<status>overdue</status>";
							
							if( $diff=@get_time_difference($end, $start) )
											{
											  echo "<ttl>".$diff['days']." days, ".$diff['hours']." hours, ".$diff['minutes']." minutes</ttl>";
											}
											else
											{
											  echo "<ttl>calculating</ttl>";
											}
							
																		
							 } 
							 else if($num_results2 > 0)
							 {
							 	echo "<status>updating soon</status>";
								
								if( $diff=@get_time_difference($start, $end) )
											{
											  echo "<ttl>".$diff['days']." days, ".$diff['hours']." hours, ".$diff['minutes']." minutes</ttl>";
											}
											else
											{
											  echo "<ttl>calculating</ttl>";
											}
								
							 } else
							 {
							 echo "<status>ok</status>";
							 
											if( $diff=@get_time_difference($start, $end) )
											{
											  echo "<ttl>".$diff['days']." days, ".$diff['hours']." hours, ".$diff['minutes']." minutes</ttl>";
											}
											else
											{
											  echo "<ttl>calculating</ttl>";
											}
							 
							 }

	
	
	
	
	 $query4 = 'SELECT * FROM data where station='.$row['station_no'].' ORDER BY date DESC';
  $result4 = mysql_query($query4) or die('<p>Error executing query</p>');


$num_results4 = mysql_num_rows($result4);
  
   for ($i2=0; $i2 < $num_results4; $i2++)
  {
	
    $row4 = mysql_fetch_array($result4);
	
	if ($i2 ==0)
	{
	echo "<last_update>".$row4['date']."</last_update>";
	}
  }
	
	
	
	echo '</station>';
	
  }
  echo "</all_stations>";
  
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
