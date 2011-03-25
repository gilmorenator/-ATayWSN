/***************************************************************************************
Copyright (C) 2008 Andreas Berger
This script is made by and copyrighted to Andreas Berger - andreas_berger@bretteleben.de
It may be used for free as long as this msg is intact!
****************************************************************************************
Version 20081005
***************************************************************************************/
//*****parameters to set*****
divid="panorama"; //the id of the div container that will hold the panorama
impad='http://abertayweather.co.nr/panoramic.php?s=4'; //the path to your panorama-pic
imwid=1760 //the width of your pic
imhei=288; //the height of your pic
panwid=352; //the width of the shown area
panhei=288; //the height of the shown area
//if it differs from the image-height, the image gets scaled in length and height
speed=40; //timeout between moves; set it lower to increase speed
move=5; // movement at one step in pixel
//*****nothing more to do, have fun :)
tim=0;noscroll=true;
imw=imwid*panhei/imhei;imh=panhei;imstart=panwid/2-imw*1.5;
jumpa=panwid/2-imw*2.5;jumpwida=imw-move;
jumpb=panwid/2-imw/2;jumpwidb=imw+move;
conwid=15;panhei+=30;contop=(imh*1)+(10*1);
conlefa=panwid/2-conwid;conlefb=panwid/2;
function sr(){
	if(!noscroll){
	now=parseFloat(document.getElementById("pano").style.left);
  if (now<=jumpa){now+=jumpwida;} else{now-=move;}
  document.getElementById("pano").style.left=now+"px";
	tim=setTimeout("sr()",speed);}}

function sl(){
	if(!noscroll){
	now=parseFloat(document.getElementById("pano").style.left);
  if (now>=jumpb){now-=jumpwidb;} else{now+=move;}
  document.getElementById("pano").style.left=now+"px";
	tim=setTimeout("sl()",speed);}}

function stop(){clearTimeout(tim); noscroll=true}

function shownow() {
	document.getElementById(divid).style.height=panhei+"px";
	document.getElementById(divid).innerHTML=tp;}

tp="<div id='panorama2'>";
tp=tp+"<div id='pano' style='position:absolute; left:"+imstart+"px; top:0px; width:"+imw*3+"px; height:"+imh+"px; z-index:2; visibility:visible;'>";
tp=tp+"<img src='"+impad+"' width="+imw+"px height="+imh+"px><img src='"+impad+"' width="+imw+"px height="+imh+"px><img src='"+impad+"' width="+imw+"px height="+imh+"px>";
tp=tp+"</div>";
tp=tp+"<div id='left'><a href='javascript://' onmouseover='noscroll=false; sl()' onmouseout='stop()'>&lt;</a></div>";
tp=tp+"<div id='right'><a href='javascript://' onmouseover='noscroll=false; sr()' onmouseout='stop()'>&gt;</a></div>";
tp=tp+"<</div>";

document.write("<style>");
document.write("#panorama2 {position:absolute;width:"+panwid+"px; height:"+panhei+"px; clip:rect(0px,"+panwid+"px,"+panhei+"px,0px); overflow:hidden;}");
document.write("#left {position:absolute; left:"+conlefa+"px; top:"+contop+"px; width:"+conwid+"px; z-index:1; text-align:right;}");
document.write("#right {position:absolute; left:"+conlefb+"px; top:"+contop+"px; width:"+conwid+"px; z-index:1; text-align:left;}");
document.write("#right a, #left a {text-decoration:none;}");
document.write("</style>");

onload=shownow;