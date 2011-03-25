<?php
ini_set("display_errors", 1);
error_reporting(E_ALL); 
/*
VALUES ('0',  '0',  '34',  'ene',  '12',  '3',  '7',  'http://www.nps.gov/biho/images/BI-Clouds-Weather.jpg',  '2010-01-26 21:37:52')
*/

//for debugging stuff
require('allow_debug.php');

//ok we are gonna get the following inpuits from the arduino via the query string
/*

* station - s
* wind - w
* w_speed - ws
* temp - t
* rain - r
* voltage = v

*/
$weather_station = $_SERVER['REMOTE_ADDR']; //capture the webservers address so we can go back down and get a picture

//now get the querystrings
foreach($_GET as $variable => $value )
{
    
   if($variable == "s")
	{
   	$station= $value;
	}
	else  if($variable == "w")
	{
   	$wind= $value;
	}
	else if($variable == "ws")
	{
   	$w_speed= $value;
	}
	else  if($variable == "t")
	{
   	$temperature= $value;
	}
	else if($variable == "r")
	{
   	$rain= $value;
	}
	else if($variable == "ttl")
	{
   	$ttl= $value;
	}
	else if($variable == "v")
	{
   	$voltage= $value;
	}
	
if ($debug == 1) {echo "<p>".$variable." ".$value."</p>";};
}

//ok we have the values now to process them.
/*
for quadrant:
349 - 11 = north,
12 - 33 = north north east, 
34-56 = east, 
57 - 78 = east north east,  
79-101 = east, 
102 - 123 = east south east, 
124 -146 south east 
147 - 168 = south south east
169 - 191 = south
192 - 213 = south south west
214 - 236 = south west
237 - 258 = west south west
259 - 281 = west
282 - 303 = west north west
304 - 326 = north west
327 - 348 = north north west 

so tajke the coords and get teh quadrant.
*/


if ($wind >= 349 || $wind <= 11)//note: this should be an "or" operator. all subsequent ones should be an "and operator"
{
$quadrant = "n";
}
else if ($wind >= 12 && $wind <= 33)
{
$quadrant = "nne";
}
else if ($wind >= 34 && $wind <= 56)
{
$quadrant = "ne";
}
else if ($wind >= 57 && $wind <= 78)
{
$quadrant = "ene";
}
else if ($wind >= 79 && $wind <= 101)
{
$quadrant = "e";
}
else if ($wind >= 102 && $wind <= 123)
{
$quadrant = "ese";
}
else if ($wind >= 124 && $wind <= 146)
{
$quadrant = "se";
}
else if ($wind >= 147 && $wind <= 168)
{
$quadrant = "sse";
}
else if ($wind >= 169 && $wind <= 191)
{
$quadrant = "s";
}
else if ($wind >= 192 && $wind <= 213)
{
$quadrant = "ssw";
}
else if ($wind >= 214 && $wind <= 236)
{
$quadrant = "sw";
}
else if ($wind >= 237 && $wind <= 258)
{
$quadrant = "wsw";
}
else if ($wind >= 259 && $wind <= 281)
{
$quadrant = "w";
}
else if ($wind >= 282 && $wind <= 303)
{
$quadrant = "wnw";
}
else if ($wind >= 304 && $wind <= 326)
{
$quadrant = "nw";
}
else if ($wind >= 327 && $wind <= 348)
{
$quadrant = "nnw";
}


$time_now=time();
$pic_filename = $station.'_'.$time_now;


$handle = file_get_contents("http://kas.inx-gaming.co.uk/camera/listfiles.php?s=".$station."&p=0", "r");

if($handle == "cloud")
{
$picture = imagecreatefromjpeg("http://www.themaclawyer.com/uploads/image/clouds.jpg");
}
else
{
$picture = imagecreatefromjpeg("http://kas.inx-gaming.co.uk/camera/".$station."/".$handle); 
}


$filename = '/home/UAD/0804093/public_html/weather/uploads/'.$pic_filename.'.gif';//replace this with a randomly genreated string for the filename!
$result = imagegif($picture, $filename, 100);
$pic_size = filesize($filename);
if($result === FALSE) return false; // Error condition


$handle = file_get_contents("http://kas.inx-gaming.co.uk/camera/listfiles.php?s=".$station."&p=1", "r");
if($handle == "cloud")
{
$picture = imagecreatefromjpeg("http://www.themaclawyer.com/uploads/image/clouds.jpg");
}
else
{
$picture = imagecreatefromjpeg("http://kas.inx-gaming.co.uk/camera/".$station."/".$handle); 
}


$filename = '/home/UAD/0804093/public_html/weather/uploads/'.$pic_filename.'_left.gif';//replace this with a randomly genreated string for the filename!
$result = imagegif($picture, $filename, 100);
$pic_size = filesize($filename);
if($result === FALSE) return false; // Error condition

$handle = file_get_contents("http://kas.inx-gaming.co.uk/camera/listfiles.php?s=".$station."&p=2", "r");

if($handle == "cloud")
{
$picture = imagecreatefromjpeg("http://www.themaclawyer.com/uploads/image/clouds.jpg");
}
else
{
$picture = imagecreatefromjpeg("http://kas.inx-gaming.co.uk/camera/".$station."/".$handle); 
}


$filename = '/home/UAD/0804093/public_html/weather/uploads/'.$pic_filename.'_farleft.gif';//replace this with a randomly genreated string for the filename!
$result = imagegif($picture, $filename, 100);
$pic_size = filesize($filename);
if($result === FALSE) return false; // Error condition

$handle = file_get_contents("http://kas.inx-gaming.co.uk/camera/listfiles.php?s=".$station."&p=3", "r");
if($handle == "cloud")
{
$picture = imagecreatefromjpeg("http://www.themaclawyer.com/uploads/image/clouds.jpg");
}
else
{
$picture = imagecreatefromjpeg("http://kas.inx-gaming.co.uk/camera/".$station."/".$handle); 
}



$filename = '/home/UAD/0804093/public_html/weather/uploads/'.$pic_filename.'_right.gif';//replace this with a randomly genreated string for the filename!
$result = imagegif($picture, $filename, 100);
$pic_size = filesize($filename);
if($result === FALSE) return false; // Error condition

$handle = file_get_contents("http://kas.inx-gaming.co.uk/camera/listfiles.php?s=".$station."&p=4", "r");
if($handle == "cloud")
{
$picture = imagecreatefromjpeg("http://www.themaclawyer.com/uploads/image/clouds.jpg");
}
else
{
$picture = imagecreatefromjpeg("http://kas.inx-gaming.co.uk/camera/".$station."/".$handle); 
}



$filename = '/home/UAD/0804093/public_html/weather/uploads/'.$pic_filename.'_farright.gif';//replace this with a randomly genreated string for the filename!
$result = imagegif($picture, $filename, 100);
$pic_size = filesize($filename);
if($result === FALSE) return false; // Error condition


file_get_contents("http://kas.inx-gaming.co.uk/camera/delete_all.php?s=".$station);//deltete all the files from the temporary location


$query = "INSERT INTO weather_data VALUES ('".$station."', '".$wind."', '".$quadrant."', '".$w_speed."', '".$temperature."', '".$rain."', '".$pic_filename."', '".date("Y.m.d H:i:s")."', '', '".$pic_size."', '".$voltage."')";

echo $query;

require('dbconnect.php'); //make the db connection
	
	
		$result = mysql_query($query) or die('<p>Error executing query</p>');

		
		
		
		
		
	$query= "UPDATE  `weather_station` SET  `ttl` =  '".date("Y.m.d H:i:s", mktime(date("H"), date("i")+$ttl, date("s"), date("m")  , date("d"), date("Y")))."' WHERE  `weather_station`.`station_no` =".$station." LIMIT 1" ;
		
		
		require('dbconnect.php'); //make the db connection
	
	
		$result = mysql_query($query) or die('<p>Error executing query</p>');
		
		
		
		
		
		
		
			
		
		
		
		
		
		
function move_camera($direction, $wait)
{
$url = "http://".$_SERVER['REMOTE_ADDR']."/cgi-bin/camctrl.cgi?move=".$direction;
file_get_contents($url);
sleep($wait); 
}
		
?>
