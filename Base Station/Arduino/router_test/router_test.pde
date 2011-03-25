int routerpin = 2;
int ledpin = 13;

void setup()
{
  pinMode(routerpin, OUTPUT);
  pinMode(ledpin, OUTPUT);
}

void loop()
{
  digitalWrite(routerpin, HIGH);
  digitalWrite(ledpin, HIGH);
  delay(1000);
  digitalWrite(ledpin, LOW);
  delay(500);
}
