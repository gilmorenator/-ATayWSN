<?php
$db = mysql_connect("localhost", "basestation", "UFGvVQeG4h3FA9XX"); 
	if (!$db)
	{
		echo 'Error connecting to database server - Please check connection string';
		exit;
	}

	mysql_select_db('weather_data', $db) or die('<p>database connection error</p>');
?>
