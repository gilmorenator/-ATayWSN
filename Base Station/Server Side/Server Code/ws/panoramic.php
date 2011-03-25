<?php 
ini_set("display_errors", 1);
error_reporting(E_ALL); 
header ("Content-type: image/png"); 

foreach($_GET as $variable => $value )
{
    


   if($variable == "s")
	{
   	$station= $value;
	}

}

require('dbconnect.php');

$query = 'SELECT * FROM data where station='.$station.' ORDER BY date DESC';
  $result = mysql_query($query) or die('<p>Error executing query</p>');


$num_results = mysql_num_rows($result);
  

  
	
    $row = mysql_fetch_array($result);
	
	//echo $row;
	

$src = array ("http://localhost/ws/uploads/".$row['picture']."_farleft.gif","http://localhost/ws/uploads/".$row['picture']."_left.gif","http://localhost/ws/uploads/".$row['picture'].".gif", "http://localhost/ws/uploads/".$row['picture']."_right.gif","http://localhost/ws/uploads/".$row['picture']."_farright.gif");    
$imgBuf = array (); 
foreach ($src as $link) 
{ 
   switch(substr ($link,strrpos ($link,".")+1)) 
   { 
       case 'png': 
           $iTmp = imagecreatefrompng($link); 
           break; 
       case 'gif': 
           $iTmp = imagecreatefromgif($link); 
           break;                
       case 'jpeg':            
       case 'jpg': 
           $iTmp = imagecreatefromjpeg($link); 
           break;                
   } 
   array_push ($imgBuf,$iTmp); 
} 
$iOut = imagecreatetruecolor ("1760","288") ; 
imagecopy ($iOut,$imgBuf[0],0,0,0,0,imagesx($imgBuf[0]),imagesy($imgBuf[0])); 
imagedestroy ($imgBuf[0]); 
imagecopy ($iOut,$imgBuf[1],352,0,0,0,imagesx($imgBuf[1]),imagesy($imgBuf[1])); 
imagedestroy ($imgBuf[1]); 
imagecopy ($iOut,$imgBuf[2],704,0,0,0,imagesx($imgBuf[2]),imagesy($imgBuf[2])); 
imagedestroy ($imgBuf[2]); 
imagecopy ($iOut,$imgBuf[3],1056,0,0,0,imagesx($imgBuf[3]),imagesy($imgBuf[3])); 
imagedestroy ($imgBuf[3]); 
imagecopy ($iOut,$imgBuf[4],1408,0,0,0,imagesx($imgBuf[4]),imagesy($imgBuf[4])); 
imagedestroy ($imgBuf[4]); 
imagepng($iOut); 
?>
