<?php

ini_set("display_errors", 1);
error_reporting(E_ALL); 

$station = null;

foreach($_GET as $variable => $value )
	{
    
		if($variable == "s")
		{
			$station= $value;
		}
				
	}

if($station!= null)
{
	
$dir = $station."/";
foreach(glob($dir.'*.*') as $v){
    unlink($v);
}

}
?>