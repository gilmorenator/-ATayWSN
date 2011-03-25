//Include EEPROM Library
#include <EEPROM.h>

//Analogue Temperature Pin
int tempPin = 0;
//Temperature Variable
float temp = 0.0;
//Temperature Span
int tempSpan = 20;
//EEPROM Address
int addr = 0;

void setup ()
{
  Serial.begin(9600);
  //Start by clearing the EEPROM
  for (int i = 0; i < 512; i ++)
  {
    //EEPROM.write(i, 0);
  }
  
  pinMode(2,OUTPUT);
  digitalWrite(2, HIGH);
}

void loop ()
{
   float tempraw = 0;
   float tempV = 0;
   float tempC = 0;

    // read the value on analog input span times then divide by the number of span for average.
    for (int i = 0; i < tempSpan; i++)
    {
      tempraw = tempraw+analogRead(tempPin);
      Serial.print("Temp Raw: ");
      Serial.print(tempraw);
      Serial.println();
      tempraw = tempraw / tempSpan;
      //Serial.println(tempraw);
      tempV = ((tempraw * 3.30) / 1076.84); //using 3.20 since analogReference is set to Default of 3
      tempC = ((tempV-1.375) / .0225);   //Seems to be a 1.375 offset and a 22.5mV/C from spec sheet.
    }
    
    //Write Value to EEPROM
    Serial.println(tempC);
    //writeToMemory(tempC);
}

void writeToMemory (float a)
{
  //Variable to hold value to be written
  int val = 0;
  //Divide read value by 4 - EEPROM can only hold values between: 0 - 255 A2D Values: 0 - 1023
  val = a / 4;
  //Write to Address
  EEPROM.write(addr, val);
}
