#include <SPI.h> //Added SPI Library for ethernet activity
#include <Ethernet.h> //this library gives us our ethernet connection.

/*
 Uinversity of Abertay Dundee Weather System.
 
 Written by D. Gilmore
 
 Version 3
 
 BUGS:
 
 Ok so it looks like we can only send 5 gets for each connection. so thats:
 home
 6 left
 6 left
 home
 6 right
 6 right
 home
 
 = 6 camera clients!
 
 timer for boot time appears to be 6 milliseconds (6 thousandths of a second)
 
 PIN ASSIGNEMENTS
 
 DIGITAL
 2 = out, camera power
 3 = out, router power
 8 = out, restart connection
 13 = arduino led
 
 ANALOG
 4 = voltage
 3 = direction
 2 = temperature
 1 = rain gague 
 0 = wind speed sensor
 
 pheenet pin assignemt from left to right looking at it from the back
 
 continuity/continuity/input ground/input 12v DC positive
 
 one rain pulse = 0.2mm
 
 STATUS CODES
 
 solid off = arduino is not transmitting
 solid on = arduino is transmitting to camera
 */

//USER VARIABLES -- do not alter anything above this line

String station="4";                    //the station number corresponding to the station this arduino is to be installed on.
unsigned long delaytime = 15;          //the length of each cycle in minutes, basically how often you want updates to be sent!(60 minutes for this station)
unsigned long boottime = 5;           //how long to wait before sending out the data after booting up (45 minutes for this station)
unsigned long powerup = 180000;       //milliseconds to wait for camera and router (180000)

//TIME EXPLANATION
//the station will record sensor inputs over a period boottime minutes long.
//once the boottime has expired the station shall send out its data then wait for the delayletime to expire at which point the station wil restart
//WARNING ensure the delay time is at least 5 minutes longer than the boottime. say ten minutes to be safe.

//converting - the figures for pulse counting sensors sent to the database need to be divided by the boottime in seconds when being displayed!
//             the voltage, temperature and wind speed needs to be divided by 100

/************ Ethernet Settings *********************************************/
//byte ip[] ={ 192, 168, 0, 61 };
//Ethernet Shield IP Adddress
byte ip[] = { 192, 168, 2, 10 };
//Ethernet Shield MAC Address
static uint8_t mac[] = { 0xDE, 0xAD, 0xfc, 0xEF, 0xFE, 0xfD };
//Ethernet Shield Subnet
byte subnet[] = { 255, 255, 255, 0 };
//Router (Gateway) IP Address
//byte gateway[] ={ 192, 168, 0, 254 }; 
byte gateway[] = { 192, 168, 2, 1 };
//Webserver Address
//byte server[] = { 193, 60, 168, 48 };
byte server[] = { 192, 168, 2, 3 };
//Pheenet Webcam
byte webcam[] = { 192, 168, 2, 4 };   //this is the address of the webcam which should be attached on the local network
/****************************************************************************/


/********** Analogue Pins for Analogue Sensors ***********/
//Anomometer
int windcount=0; //counts wind speed
int windpin=0;
boolean windflip=true;
//Rain Gauge
int raincount=0;//counts rainfall
int rainpin=1;
boolean rainflip=true;
//Temperature 
int temperaturepin=2;
//Wind Direction
int dirpin=3;
int dir=0;
int dircount=0;
int dirs[50];
unsigned long lastdir=0;
//Battery Voltage
int powerpin = 4;
/***********************************/

/******** Digital I/O Pins *********/
//the pin that connects to the arduinos reset pin
int restartPin=8;
//Arduino LED
int ledPin =  13;
//Router Relay Power
int routerpin = 3;
//Camera Relay Power
int camerapin = 2;
/*********************************/

/****** Mode Settings ***********/
int mode=0;
static int POWER_UP = 1;
static int SEND_DATA = 2;
static int MEASURE_PULSES = 3;
static int POWER_DOWN = 99;
/*******************************/


/********* Global Variables *****/
//Boolean Camera and Server Variables
boolean cameracanconnect = true;
boolean servercanconnect = true;
//Create the client object for the webserver
Client client(server, 80);
//Create the client object for the webcam
Client camera1(webcam, 80); 
Client camera2(webcam, 80); 
Client camera3(webcam, 80); 
Client camera4(webcam, 80); 
Client camera5(webcam, 80); 
Client camera6(webcam, 80); 
Client camera7(webcam, 80); 
Client camera8(webcam, 80); 
//Offset Variable
unsigned long offset=0;
//Variables for sensor readins
String wind="0"; // the wind speed 0-99mph
String wind_dir="0"; //the wind direction 0-359 degrees
String temperature="0"; //the temperature 0 to 60 degrees
String rainfall = "0"; //rain fall, measured in millimeters
String upload_script=""; //the location of the upload script will be fed into this!
//Delete all script location
String delall= "GET /192.168.2.3/ws/delete_all.php?s=";
//Boolean - Power values
boolean router_powered_on=false;
boolean camera_powered_on=false;
//Battery Reading variable
float realvoltage;
//Time To Live?
long ttl;
/*used for converting minutes to milliseconds and vice-versa
1000mS = 1sec      60,000ms = 1min*/
unsigned long converter = 60000;

void setup()
{ 
  //start up the serial port
  Serial.begin(9600); 
  Serial.println("Welcome to the University of abertay dundee");
  Serial.println("             Weather Station");
  Serial.println("                  V3.0");
  
  //convert the dealytime to milliseconds
  delaytime *=converter; 
  //Set Digital Pin Modes
  pinMode(ledPin, OUTPUT);
  pinMode(camerapin, OUTPUT);
  pinMode(routerpin, OUTPUT);
  //Start Ethernet Shield
  Ethernet.begin(mac, ip, gateway, subnet); 
  //delay(5000);//wait a bit before trying to connect to the internet, this gives us time to serial in.
  //Get current boot execution time
  offset=millis();
  //TODO: Remove - Debug Only
  Serial.print("Offset: ");
  Serial.print(offset);
  Serial.println();
}

void loop()
{
  //TODO: Remove - Debug Only
  Serial.print("Millis:");
  Serial.print(millis());
  Serial.println();

    if((millis()-offset) < (boottime * converter)) 
    {
       mode = MEASURE_PULSES; 
       Serial.println("MEASURE_PULSES");
 //    mode = POWER_UP;
//     Serial.println("POWER_UP");
       
    }
    else
    {
       if(mode == MEASURE_PULSES)
        {
           mode = POWER_UP;
           Serial.println("POWER_UP");
        } 
    }
  
  if(mode == POWER_UP)//power on the router and camera
  {
    power(true, true);
    delay(powerup); //wait for router to get a connection
    mode = SEND_DATA;
    Serial.println("SEND_DATA");    
  }
  
  else if(mode == POWER_DOWN)
  {
    //power everything down and wait for the restart time to expire
    power(false, false); 
    
    if(millis() >= delaytime)
    {
      Serial.println("restarting");
      //restart the arduino
      pinMode(restartPin, OUTPUT);
    }
  }
  else if(mode == SEND_DATA)//send out the data
  {
    digitalWrite(ledPin, HIGH);
    //clear the sensor input buffers
    wind = "";
    wind_dir = ""; 
    temperature = ""; 
    rainfall = ""; 


//scale the values to per second (this will now be done at the display side by dividing the figures stored i nteh database at dispaly.

//ok now to bubble sort the array

boolean sorted = false;

while(!sorted)
{
  sorted = true;
  for(int i=0;i<dircount;i++)
  {
     if(dirs[i+1] < dirs[i])
     {
       int tempbubble = dirs[i+1];
       dirs[i+1] = dirs[i];
       dirs[i] = tempbubble;
       sorted = false;
     }  
  }    
}


//ok array is bubble sorted

 realvoltage = map(analogRead(temperaturepin), 0, 1023,0 ,500);
 //Changed from 100 -> 1000;
 realvoltage = realvoltage / 1000;
  //realvoltage = realvoltage /10;
 realvoltage = realvoltage - 0.23;
 realvoltage = realvoltage * 100;
 int temperature_int = realvoltage * 100;

    //get the sensor variables
    wind.concat(map(windcount, 0, 1, 0, 325)); //divide this by seconds in 45 minutes at the server
    wind_dir.concat(map((dirs[(dircount / 2)]), 0, 1023, 359, 0 ));
    temperature.concat(temperature_int);
    rainfall.concat(map(raincount,0,1,0,17280)); //divide this by seconds in a day at the server

     delay(1000);
    //ok time to move the camera!

    move_camera();

    //ok the camera is done now!
    power(true, false);//shut down the camera
    //upload the data
    Serial.println("Looking for connection to the internet");


      upload_script = "";//flush the upload script
      
      upload_script.concat("GET /192.168.2.3/ws/input.php?s=");//now to build the url with hte querystrings tacked on at the end
      upload_script.concat(station);

      upload_script.concat("&w=");

      upload_script.concat(wind_dir);
      upload_script.concat("&ws=");

      upload_script.concat(wind);

      upload_script.concat("&t=");
      upload_script.concat(temperature);
      upload_script.concat("&r=");
      upload_script.concat(rainfall);

      upload_script.concat("&v=");
      upload_script.concat(map(analogRead(powerpin),530,705,1040,1380));//get the voltage
      upload_script.concat("&ttl=");
      ttl = delaytime;
      ttl /= converter;
      upload_script.concat(ttl); //let the server know when the next update will be!
  
      upload_script.concat(" HTTP/1.1");

      //TODO: Remove - Debug Only
      Serial.println(upload_script);


    if (client.connect()) 
    {
      Serial.println("Internet connection detected.");
      Serial.println();
      Serial.print("Attempting to open:");
      client.println(upload_script);//this basically opens the webpage using the built url with the querystrings.
      //client.println("Host: cctstudent.abertay.ac.uk");
      client.println("Host: 192.168.2.3");
      client.println();
      Serial.println("Data sent!");
      delall.concat(station);
      delall.concat(" HTTP/1.1");
      delay(3000);
      client.println(delall);//this basically opens the webpage using the built url with the querystrings.
      //client.println("Host: cctstudent.abertay.ac.uk");
      client.println("Host: 192.168.2.3");
      client.println();
      Serial.println("deleted temporary images.");
      //we dont need anything back from the webpage so we can stop sending now
      client.stop();
    } 
    else
    {
      Serial.println("Could not establish a connection to the Server");
      servercanconnect = false;
    }

    Serial.println("all done!");//and now we play the waiting game
    mode = POWER_DOWN;

  }
  
  else if(mode == MEASURE_PULSES)//measure pulses 
  {
    //Serial.println(millis() - lastdir);
    //ok measure the data and stuff
     //if the  pin is high increment counter by 1 
                //Serial.println(analogRead(dirpin));
                if(analogRead(windpin) > 900 && windflip)
                {
                  windcount++; 
                  windflip=false;
                  Serial.println("wind: " && windcount);
                }
                else if(analogRead(windpin) <= 500)
                {
                  windflip=true;
                }
            
            
                if(analogRead(rainpin) > 900 && rainflip)
                {
                  raincount++; 
                  rainflip=false;
                  Serial.print("rain: ");
                  Serial.print(raincount);
                  Serial.println();
                }
                else if(analogRead(rainpin) <= 500)
                {
                  rainflip=true;
                }
                      
                if((millis() - lastdir) > 60000)
                {
                  
                  lastdir = millis(); 
                  dirs[dircount] = analogRead(dirpin);
                  dircount++;        
                
                  Serial.println(analogRead(dirpin));               
              }             
  }

}

void move_camera()
{
//max of 5 calls on  each client object
  if (camera1.connect()) {
    
    camera1.connect();
    camera1.println("GET /cgi-bin/camctrl.cgi?move=home HTTP/1.1");
    camera1.println("Host: 192.168.0.70");
    camera1.println("");
    camera1.flush();
    camera1.stop();
    delay(3000);
    
    camera1.connect();
    camera1.println("GET /cgi-bin/setdo.cgi?do=h HTTP/1.1");
    camera1.println("Host: 192.168.0.70");
    camera1.println("");
    camera1.flush();
    camera1.stop();
    delay(2000);
    
    camera1.connect();
    camera1.println("GET /cgi-bin/setdo.cgi?do=l HTTP/1.1");
    camera1.println("Host: 192.168.0.70");
    camera1.println("");
    camera1.flush();
    camera1.stop();
    delay(10000);
    
    camera1.connect();
    camera1.println("GET /cgi-bin/camctrl.cgi?move=left HTTP/1.1");
    camera1.println("Host: 192.168.0.70");
    camera1.println("");
    camera1.flush();
    camera1.stop();
    delay(500);
    camera1.connect();
    camera1.println("GET /cgi-bin/camctrl.cgi?move=left HTTP/1.1");
    camera1.println("Host: 192.168.0.70");
    camera1.println("");
    camera1.flush();
    camera1.stop();
    delay(500);
  } 
  else
  {
    Serial.println("Could not establish a connection to the webcam!");
    cameracanconnect = false;
  }


  if (camera2.connect()) {
    
    camera2.connect();
    camera2.println("GET /cgi-bin/camctrl.cgi?move=left HTTP/1.1");
    camera2.println("Host: 192.168.0.70");
    camera2.println("");
    camera2.flush();
    camera2.stop();
    delay(500);
    
    camera2.connect();
    camera2.println("GET /cgi-bin/camctrl.cgi?move=left HTTP/1.1");
    camera2.println("Host: 192.168.0.70");
    camera2.println("");
    camera2.flush();
    camera2.stop();
    delay(500);

    camera2.connect();
    camera2.println("GET /cgi-bin/camctrl.cgi?move=left HTTP/1.1");
    camera2.println("Host: 192.168.0.70");
    camera2.println("");
    camera2.flush();
    camera2.stop();
    delay(500);
    
    camera2.connect();
    camera2.println("GET /cgi-bin/camctrl.cgi?move=left HTTP/1.1");
    camera2.println("Host: 192.168.0.70");
    camera2.println("");
    camera2.flush();
    camera2.stop();
    delay(500);
    
    
    camera2.connect();
    camera2.println("GET /cgi-bin/setdo.cgi?do=h HTTP/1.1");
    camera2.println("Host: 192.168.0.70");
    camera2.println("");
    camera2.flush();
    camera2.stop();
    delay(2000);
    } 
  
  else
  {
    Serial.println("Could not establish a connection to the webcam!");
    cameracanconnect = false;
  }

  if (camera3.connect()) {
    
    camera3.connect();
    camera3.println("GET /cgi-bin/setdo.cgi?do=l HTTP/1.1");
    camera3.println("Host: 192.168.0.70");
    camera3.println("");
    camera3.flush();
    camera3.stop();
     delay(10000);

    camera3.connect();
    camera3.println("GET /cgi-bin/camctrl.cgi?move=left HTTP/1.1");
    camera3.println("Host: 192.168.0.70");
    camera3.println("");
    camera3.flush();
    camera3.stop();
    delay(500);
    
    camera3.connect();
    camera3.println("GET /cgi-bin/camctrl.cgi?move=left HTTP/1.1");
    camera3.println("Host: 192.168.0.70");
    camera3.println("");
    camera3.flush();
    camera3.stop();
    delay(500);
    camera3.connect();
    camera3.println("GET /cgi-bin/camctrl.cgi?move=left HTTP/1.1");
    camera3.println("Host: 192.168.0.70");
    camera3.println("");
    camera3.flush();
    camera3.stop();
    delay(500);

    camera3.connect();
    camera3.println("GET /cgi-bin/camctrl.cgi?move=left HTTP/1.1");
    camera3.println("Host: 192.168.0.70");
    camera3.println("");
    camera3.flush();
    camera3.stop();
    delay(500);
    
    
  } 
  else
  {
    Serial.println("Could not establish a connection to the webcam!");
    cameracanconnect = false;
  }


  if (camera4.connect()) {
    
    camera4.connect();
    camera4.println("GET /cgi-bin/camctrl.cgi?move=left HTTP/1.1");
    camera4.println("Host: 192.168.0.70");
    camera4.println("");
    camera4.flush();
    camera4.stop();
    delay(500);

    camera4.connect();
    camera4.println("GET /cgi-bin/camctrl.cgi?move=left HTTP/1.1");
    camera4.println("Host: 192.168.0.70");
    camera4.println("");
    camera4.flush();
    camera4.stop();
    delay(500);
    
    
    camera4.connect();
    camera4.println("GET /cgi-bin/setdo.cgi?do=h HTTP/1.1");
    camera4.println("Host: 192.168.0.70");
    camera4.println("");
    camera4.flush();
    camera4.stop();
    delay(2000);
    
    camera4.connect();
    camera4.println("GET /cgi-bin/setdo.cgi?do=l HTTP/1.1");
    camera4.println("Host: 192.168.0.70");
    camera4.println("");
    camera4.flush();
    camera4.stop();
     delay(10000);

    camera4.connect();
    camera4.println("GET /cgi-bin/camctrl.cgi?move=home HTTP/1.1");
    camera4.println("Host: 192.168.0.70");
    camera4.println("");
    camera4.flush();
    camera4.stop();
    delay(3000);
    
    
  } 
  else
  {
    Serial.println("Could not establish a connection to the webcam!");
    cameracanconnect = false;
  }


  if (camera5.connect()) {
    //ok lets try reading a picture

    camera5.connect();
    camera5.println("GET /cgi-bin/camctrl.cgi?move=right HTTP/1.1");
    camera5.println("Host: 192.168.0.70");
    camera5.println("");
    camera5.flush();
    camera5.stop();
    delay(500);

    camera5.connect();
    camera5.println("GET /cgi-bin/camctrl.cgi?move=right HTTP/1.1");
    camera5.println("Host: 192.168.0.70");
    camera5.println("");
    camera5.flush();
    camera5.stop();
    delay(500);
    camera5.connect();
    camera5.println("GET /cgi-bin/camctrl.cgi?move=right HTTP/1.1");
    camera5.println("Host: 192.168.0.70");
    camera5.println("");
    camera5.flush();
    camera5.stop();
    delay(500);
    

    } 
  else
  {
    Serial.println("Could not establish a connection to the webcam!");
    cameracanconnect = false;
  }

  if (camera6.connect()) 
  {
     //ok lets try reading a picture
    camera6.connect();
    camera6.println("GET /cgi-bin/camctrl.cgi?move=right HTTP/1.1");
    camera6.println("Host: 192.168.0.70");
    camera6.println("");
    camera6.flush();
    camera6.stop();
    delay(500);


    camera6.connect();
    camera6.println("GET /cgi-bin/camctrl.cgi?move=right HTTP/1.1");
    camera6.println("Host: 192.168.0.70");
    camera6.println("");
    camera6.flush();
    camera6.stop();
    delay(500);
    
    camera6.connect();
    camera6.println("GET /cgi-bin/camctrl.cgi?move=right HTTP/1.1");
    camera6.println("Host: 192.168.0.70");
    camera6.println("");
    camera6.flush();
    camera6.stop();
    delay(500);
    
    camera6.connect();
    camera6.println("GET /cgi-bin/setdo.cgi?do=h HTTP/1.1");
    camera6.println("Host: 192.168.0.70");
    camera6.println("");
    camera6.flush();
    camera6.stop();
    delay(2000);
    
    camera6.connect();
    camera6.println("GET /cgi-bin/setdo.cgi?do=l HTTP/1.1");
    camera6.println("Host: 192.168.0.70");
    camera6.println("");
    camera6.flush();
    camera6.stop();
    delay(10000);

  } 
  else
  {
    Serial.println("Could not establish a connection to the webcam!");
    cameracanconnect = false;
  }
   
   if (camera7.connect()) 
   {
    camera7.connect();
    camera7.println("GET /cgi-bin/camctrl.cgi?move=right HTTP/1.1");
    camera7.println("Host: 192.168.0.70");
    camera7.println("");
    camera7.flush();
    camera7.stop();
    delay(500);

    camera7.connect();
    camera7.println("GET /cgi-bin/camctrl.cgi?move=right HTTP/1.1");
    camera7.println("Host: 192.168.0.70");
    camera7.println("");
    camera7.flush();
    camera7.stop();
    delay(500);

    camera7.connect();
    camera7.println("GET /cgi-bin/camctrl.cgi?move=right HTTP/1.1");
    camera7.println("Host: 192.168.0.70");
    camera7.println("");
    camera7.flush();
    camera7.stop();
    delay(500);


    camera7.connect();
    camera7.println("GET /cgi-bin/camctrl.cgi?move=right HTTP/1.1");
    camera7.println("Host: 192.168.0.70");
    camera7.println("");
    camera7.flush();
    camera7.stop();
    delay(500);
    
    camera7.connect();
    camera7.println("GET /cgi-bin/camctrl.cgi?move=right HTTP/1.1");
    camera7.println("Host: 192.168.0.70");
    camera7.println("");
    camera7.flush();
    camera7.stop();
    delay(500);
    } 
  else
  {
    Serial.println("Could not establish a connection to the webcam!");
    cameracanconnect = false;
  } 
  
    if (camera8.connect()) 
   {
camera8.connect();
    camera8.println("GET /cgi-bin/camctrl.cgi?move=right HTTP/1.1");
    camera8.println("Host: 192.168.0.70");
    camera8.println("");
    camera8.flush();
    camera8.stop();
    delay(500);

  
    camera8.connect();
    camera8.println("GET /cgi-bin/setdo.cgi?do=h HTTP/1.1");
    camera8.println("Host: 192.168.0.70");
    camera8.println("");
    camera8.flush();
    camera8.stop();
   delay(2000);
    
    camera8.connect();
    camera8.println("GET /cgi-bin/setdo.cgi?do=l HTTP/1.1");
    camera8.println("Host: 192.168.0.70");
    camera8.println("");
    camera8.flush();
    camera8.stop();
     delay(10000);

    } 
  else
  {
    Serial.println("Could not establish a connection to the webcam!");
    cameracanconnect = false;
  } 

}

void power(boolean power_switch_router, boolean power_switch_camera)
{

  if(power_switch_router)
  {
    if(!router_powered_on)
    {
      //set powerpin high
      Serial.println("Switching router on");
      digitalWrite(routerpin, HIGH);
      router_powered_on=true;
    }
  }
  else
  {
    if(router_powered_on)
    {
      //set powerpin high
      Serial.println("Switching router off");
      
      digitalWrite(routerpin, LOW);
      router_powered_on=false;
    }
  }
  
  
    if(power_switch_camera)
  {
    if(!camera_powered_on)
    {
      //set powerpin high
      Serial.println("Switching camera on");
      digitalWrite(camerapin, HIGH);
      camera_powered_on=true;
    }
  }
  else
  {
    if(camera_powered_on)
    {
      //set powerpin high
      Serial.println("Switching camera off");
      
      digitalWrite(camerapin, LOW);
      camera_powered_on=false;
      delay(5000);
    }
  }
  
  Serial.println("Exiting Power Routine");

}








