// Include the required libaries
#include <avr/power.h>
#include <avr/sleep.h>

// Constants
const int switchPin = 2;
const int LED = 13; 
// Sleep request variable
int sleepStatus = 0; 
// Counter
int count = 0;
int button;

void wakeUp ()
{
  button = 1;
}

void setUnusedPins ()
{
  // Define High
  pinMode(3, INPUT);
  // Activate internal 20ohm Pullup
  digitalWrite(3, HIGH);  
}

void setup ()
{
  Serial.begin(9600);
  setUnusedPins();
  pinMode(switchPin, INPUT);
  pinMode(LED, OUTPUT);
  
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
   
   // Use interrup 0 (pin 2) and run function wakeUp when pin 2 gets 
   attachInterrupt(0, wakeUp, LOW);
}

void sleepNow ()
{
      /* Now is the time to set the sleep mode. In the Atmega8 datasheet
     * http://www.atmel.com/dyn/resources/prod_documents/doc2486.pdf on page 35
     * there is a list of sleep modes which explains which clocks and 
     * wake up sources are available in which sleep modus.
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
     
     sleep_bod_disable(); // Brown Out Detector
     power_adc_disable(); // A2D Convertor
     power_spi_disable(); // Serial Peripheral Interface
     power_timer0_disable(); // Timer 0 Module
     power_timer1_disable(); // Timer 1 Module
     power_timer2_disable(); // Timer 2 Module
     power_twi_disable(); // Two Wire Interface Module
     
     // Attach the switch interrupt
     attachInterrupt(0, wakeUp, LOW);
     
     //Disable onboard LED
     digitalWrite(LED, LOW);
     
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

void loop ()
{
  digitalWrite(LED, HIGH);
  // Display information about the counter
  Serial.print("Awake for ");
  Serial.print(count);
  Serial.println(" sec");
  count++;
  // Wait for 1 second 
  delay(1000);
  
  // Compute serial input
  if (Serial.available())
  {

    
    // Read Serial port Value
    int val = Serial.read();
    
    // Determine What to do
    if (val == 'S')
    {
      Serial.println("Serial: Entering Sleep mode");
      // Delay - Required as sleep function will provoke a serial error otherwise
      delay(100);
      // Set counter
      count = 0;
      // Call sleep function
      sleepNow();
    }
    
    if ( val == 'A')
    {
      Serial.println("Doing Stuff - Reading Sensors etc..");
      
   }
 }
 
     if (button == 1)
    {
      Serial.println("Button activated");
      button = 0;      
    }
  
  // Check that enough time has passed and go back to sleep
  if (count >= 10)
  {
     Serial.println("Timer: Entering Sleep Mode");
     // Delay - Required as sleep function will provoke a serial error otherwise
     delay(100);
     // Reset counter
     count = 0;
     // Call the sleep function
     sleepNow();
  }
}
