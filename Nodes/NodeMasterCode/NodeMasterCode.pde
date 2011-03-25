// Include required libraries for power saving
#include <avr/power.h>
#include <avr/sleep.h>

// Constants
const int switchPin = 2; // Micro Switch for animal trap
const int tempPin = 5; // DS18B20 Data Line
const int SLEEP_TIMEOUT = 10;

// Counter
int count = 0;

// Switch Status Variable
int switchStatus; // 0 - Off / 1 - ON


// This method is the first thing that is called when the node is woken up via the switch interrupt
// Note: Serial outputs do not work at this stage, nor does ADC conversions

void wakeUp()
{
  switchStatus = 1;
  digitalWrite(3, HIGH);
}

// We want to use the least amount of power as possible - this method pulls all the unused pins to HIGH
// This in turn activates the internal 20ohm Pullup resistors which stops the pin from "floating"

void setUnusedPins()
{
  // The array of pins to be set - simply add or remove pins here if they are required for other purposes
  int unusedPins[] = { 4, 6, 7, 8, 9, 10, 11, 12, 13 };
  // TODO - Add PIN 3 after testing
  
  // Loop through each pin and set to INPUT and pull HIGH
  for (int i = 0; i <= sizeof(unusedPins); i++)
  {
    // Set pin to input
    pinMode(i, INPUT); 
    // Activate PULLUP
    digitalWrite(i, HIGH);    
  }
}

void setup()
{
  // Start Serial comms for XBEE and Debug - Serial not required for API mode
  Serial.begin(9600);
  
  // Set the unused pins  
  setUnusedPins();
  
  // Configure the used pins
  pinMode(switchPin, INPUT);
  pinMode(tempPin, INPUT);
  pinMode(3, OUTPUT);
  digitalWrite(3, LOW);
  
  
   /* Enable an interrupt. In the function call 
   * attachInterrupt(A, B, C)
   * A   can be either 0 or 1 for interrupts on pin 2 or 3.   
   * 
   * B   Name of a function you want to execute while in interrupt A.
   *
   * C   Trigger mode of the interrupt pin. can be:
   *             LOW        a low level trigger
   *             CHANGE     a change in level trigger
   *             RISING     a rising edge of a level trigger
   *             FALLING    a falling edge of a level trigger
   *
   * In all but the IDLE sleep modes only LOW can be used.
   */
   
   // Use interrup 0 (pin 2) and run function wakeUp when pin 2 gets pressed
   // The Micro switch is configured to go loww on press rather than high
   attachInterrupt(0, wakeUp, LOW);  
}


// The following method manages the sleep modes of the MCU
// WARNING: DRAGONS AHEAD:- The first thing you must do on wakeup is disable the sleep modes
// You will "brick" the MCU if you DO NOT - TIMER0 Controls the MCU's instruction clock

void sleepNow()
{
    /* Now is the time to set the sleep mode. In the Atmega328 datasheet
     * http://www.atmel.com/dyn/resources/prod_documents/doc2486.pdf on page 35
     * there is a list of sleep modes which explains which clocks and 
     * wake up sources are available in which sleep modes.
     *
     * In the avr/sleep.h file, the call names of these sleep modus are to be found:
     *
     * The 5 different modes are:
     *     SLEEP_MODE_IDLE         -the least power savings 
     *     SLEEP_MODE_ADC
     *     SLEEP_MODE_PWR_SAVE
     *     SLEEP_MODE_STANDBY
     *     SLEEP_MODE_PWR_DOWN     -the most power savings
     *
     *  the power reduction management <avr/power.h>  is described in 
     *  http://www.nongnu.org/avr-libc/user-manual/group__avr__power.html
     */ 
     
     // Set sleep mode here
     set_sleep_mode(SLEEP_MODE_IDLE);  
     // Enables the sleep bit on the MCUCR register
     
     // Sleep is now possible << Safety Mechanism
     sleep_enable();
     
     // Disable parts of the MCU we do not require
     // This gets the MCU close to SLEEP_MODE_PWR_DOWN mode
     sleep_bod_disable(); // Brown Out Detector
     power_adc_disable(); // A2D Convertor
     power_spi_disable(); // Serial Peripheral Interface
     power_timer0_disable(); // Timer 0 Module
     power_timer1_disable(); // Timer 1 Module
     power_timer2_disable(); // Timer 2 Module
     power_twi_disable(); // Two Wire Interface Module
     
     // Attach the switch interrupt
     switchStatus = 0;
     attachInterrupt(0, wakeUp, LOW);
        
     // Initiate Sleep Mode
     sleep_mode();
     
     // The program will continue from here after waking from sleep
     // Firstly disable sleep mode
     sleep_disable();
     
     // Detach Interrupt
     detachInterrupt(0);
     
     // Enable the MCU features
     power_all_enable();
  
}

void loop()
{
  // Increment counter
  count++;
  
  // Check if it was a serial interrupt i.e. a network broadcast
  // First wait for 1 second to allow serial to initialise after sleep
  // An error will occur if this delay is not implemented
  delay(1000);
  
  // Check Serial lines
  if (Serial.available())
  {
    // Read the serial port value
    int val = Serial.read();
    
    // Detemine what to do
    switch(val)
    {
      case 'R':
      // Take a reading from the Temperature Sensor
      // Then send it back to the Coordinator node
      break;
      case 'B':
      // Send node battery status
      break;
      case 'S':
      // Send node to sleep
      // Delay - Required as sleep function will provoke a serial error otherwise
      delay(100);
      // Reset Counter
      count = 0;
      // Call Sleep Function
      sleepNow();
      break;
      case 'H':
      // For testing only
      digitalWrite(3, HIGH);
      delay(1000);
      digitalWrite(3, LOW);
      break;
      default:
      // Must be the switch interrupt
      break;
    }
    
    // Only arrive here is MCU has been woken by the switch
    if (switchStatus == 1)
    {
      // Alert the Coordinator so they can send an SMS
    }
  }
  
  // Now go back to sleep check that enough time has passed first
  if (count >= SLEEP_TIMEOUT)
  {
    // Enter Sleep mode
    // Delay - Required as sleep function will provoke a serial error otherwise
    delay(100);
    // Reset counter
    count = 0;
    // Call sleep function
    sleepNow();
  }
  
}
