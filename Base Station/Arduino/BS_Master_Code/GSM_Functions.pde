// GSM Library
#include "GSM.h"
// Text Message Length @Definition
#define SMS_MAX_LEN 100
// GSM class instantiation
GSM gsm;
// SMS Variables
char buffer[50];

void gsmStart()
{
  // Initiate serial line
  gsm.InitSerLine(115200);
  
  gsm.TurnOn(); 
  // Set GPIO Pins
  gsm.SetGPIODir(GPIO10, GPIO_DIR_OUT);
  gsm.SetGPIODir(GPIO11, GPIO_DIR_OUT);
  gsm.EnableUserButton();
  
}

// Check that GSM is Connected
boolean isConnected()
{
  // Return Variable
  boolean isConnected;
  
  // Check the network registration
  gsm.CheckRegistration();        
  
  if (gsm.IsRegistered())
  {
    isConnected = true;
    gsm.TurnOnLED();
    
  }
  else
  {
    isConnected = false;
    gsm.TurnOffLED();
    
  }
  
  // Return true or false
  return isConnected;
}

// Update the xml data stream using SMS
void updateData(float a)
{

  // Send an update to the data stream using a text message
  // It is organised as follows streamID, Value1,Value2,Value3.......
  // The string of data to send....

  String abc = "D pachtweet set 20344 ";
  abc.concat("27.98");
  abc.concat(",");
  abc.concat("12.59");
  
  abc.toCharArray(buffer,50);

  // Send to the SMS gateway
  // 86444
  // +447880532630
  
   // GSM Send SMS  
   if (!gsm.SendSMS("86444", buffer))
   {
     // Save the details to a CSV file on the SD Card
     writeToSD(abc);
   }
   
   gsm.TurnOffLED();
}

