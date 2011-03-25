<?php
ini_set("display_errors", 1);
error_reporting(E_ALL); 

//for debugging stuff
require('allow_debug.php');

//now get the querystrings
foreach($_GET as $variable => $value )
{
    
	if($variable == "s")
	{
	   	$station= $value;
	}	
}

//file_get_contents("http://kas.inx-gaming.co.uk/camera/delete_all.php?s=".$station);//deltete all the files from the temporary location
		
?>
