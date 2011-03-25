//Include EEPROM Library
#include <EEPROM.h>
int addr = 0;
byte value;

void setup ()
{
  Serial.begin(9600);
  pinMode(2, OUTPUT);
}

void loop ()
{
  value = EEPROM.read(addr);
  //Output to serial console
  Serial.print(addr);
  Serial.print("\t");
  Serial.print(value, DEC);
  Serial.println();
  
  //Increment address
  addr++;

  if (addr == 512)
  {
    addr = 0;
    Serial.println("Reached EOF");
  }
    
  delay(500);
}
