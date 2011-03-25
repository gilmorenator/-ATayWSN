<?php


$debug = 1;
	
	
	foreach($_GET as $variable => $value )
	{
    
		if($variable == "debug")
		{
			$debug= $value;
		}
		if ($debug == 1) {echo "<p>".$variable." ".$value."</p>";};
	}

?>
