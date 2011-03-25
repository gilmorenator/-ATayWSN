<?php
ini_set("display_errors", 1);
error_reporting(E_ALL); 
$debug=0;

foreach($_GET as $variable => $value )
{
    
   if($variable == "dir1")
	{
   	$direction= $value;
	}
	   if($variable == "dir2")
	{
   	$direction2= $value;
	}
		
if ($debug == 1) {echo "<p>".$variable." ".$value."</p>";};
}


$url = "http://".$_SERVER['REMOTE_ADDR']."/cgi-bin/camctrl.cgi?move=".$direction;
file_get_contents($url);
sleep(1); 


?>