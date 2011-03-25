<?php
ini_set("display_errors", 1);
error_reporting(E_ALL); 


foreach($_GET as $variable => $value )
	{
    
		if($variable == "s")
		{
			$station= $value;
		}
		else if($variable == "p")
		{
			$picture= $value;
		}
		
	}



$arr = array();
	$i=0;

if ($handle = opendir($station)) {
    while (false !== ($file = readdir($handle))) {
        if ($file != "." && $file != ".." && $file !="" && $file != "system.log") {
            
			$i++;
			$arr[]=$file;
			
		}


 }

     closedir($handle);
	 if($picture < $i && $i > 0)
	 {
	 sort($arr);
	 echo $arr[$picture];
	 }
	 else
	 {
	 echo "cloud";
	 }
	 }
?>