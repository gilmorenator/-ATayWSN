// Main Code for BaseStation Node
// And component Libraries

void setup()
{
  Serial.begin(9600);
  // Set Pin 10 to Output for SD Card Reader
  pinMode(10, OUTPUT);
}

int count = 0;

void loop()
{  

 // if (count == 0)
 // {
    /*
    // Start the GSM Modem
    gsmStart();
    // Wait until connection
    while (!isConnected()) 
    {
    
    }
    // Delay for 2 seconds
   delay(2000);   
    // Now that connection has been established - send the data
   updateData(33.14);  
      */
   delay(5000);   
   writeToSD("I have written this from the MCU");
   //requestData();  
   count++;
  //} 
}

void requestData()
{
  
  Serial.print('H');
  delay(1000);
  Serial.print('L');
  delay(1000);  
  
}


