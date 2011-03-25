//Constants
const int ledPinPos = 8;
const int ledPinNeg = 7;
const int switchPin = 4;
const int onboardLed = 13;

//Reading Variable
int pinStatus = 0;

void setup ()
{
  //Set LED pins to OUTPUT
  pinMode(ledPinPos, OUTPUT);
  pinMode(ledPinNeg, OUTPUT);
  pinMode(onboardLed, OUTPUT);
  //Set switch pin to input
  pinMode(switchPin, INPUT);
  //Write Low bit to Negative Pin
  digitalWrite(ledPinNeg, LOW);
}

void loop ()
{
  //Read Pin Status
  pinStatus = digitalRead(switchPin);
  //Check pin condition
  if (pinStatus == HIGH)
  {
    digitalWrite(ledPinPos, HIGH);
    digitalWrite(onboardLed, HIGH);
  }
  else
  {
    digitalWrite(ledPinPos, LOW);
    digitalWrite(onboardLed, LOW);
  }
}
