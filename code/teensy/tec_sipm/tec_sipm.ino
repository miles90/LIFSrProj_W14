#define EncoderPin      12
#define TECpositivePin  11
#define TECnegativePin  10
#define TemperaturePin  3
#define CurrentPin      2
#define LEDpin          13
#define SiPMpin         0
#define VMAX12          4095
#define VMAX16          65535
#define SampleAverage   32
#define BAUD_RATE       9600//115200
#define analogresolution 16
#define numSerialBytes 2
// interrupt timing
volatile int SiPMperiod = 6000;
volatile boolean runSiPMtimer = false;
volatile int PIDperiodMillis = 5;
volatile int BlinkMillisTime = 300;

#define SiPMmaxReadTimes 100
volatile int SiPMcounter = 0;
volatile int SiPMdata[SiPMmaxReadTimes];

IntervalTimer PIDtimer;
IntervalTimer SiPMtimer;
IntervalTimer BlinkTimer;

volatile boolean blinking = false;

void measureSiPM(void){
  unsigned char serialBytes[numSerialBytes];
  SiPMdata[SiPMcounter] = analogRead(SiPMpin);
  serialBytes[0] = (SiPMdata[SiPMcounter] >> 8) & 0xff;
  serialBytes[1] = (SiPMdata[SiPMcounter]) & 0xff;
  Serial.write(serialBytes, numSerialBytes);
}

void calculatePID(void){
  // do pid calculations
  //analogRead(SiPMpin);
  //analogRead(TemperaturePin);
  //tecPID.SetTunings(consKp, consKi, consKd);
  //tecPID.Compute();
  //writeoutput();
  //printinfo();
  //digitalWriteFast(0,HIGH);
}

void Blink(void){
  if(blinking){
    blinking = false;
    digitalWrite(LEDpin, LOW);
  }
  else{
    blinking = true;
    digitalWrite(LEDpin, HIGH);
  }
}

void setupSiPM(void){
  SiPMtimer.begin(measureSiPM, SiPMperiod);
}
void stopSiPM(void){
  SiPMtimer.end();
}
void setupPID(){
  PIDtimer.begin(calculatePID, PIDperiodMillis*1000);
}
void stopPID(){
  // turn the encoder off first
  PIDtimer.end();
}
void setupBlink(){
  BlinkTimer.begin(Blink, BlinkMillisTime*1000);
}

void setup(){
  analogReadResolution(analogresolution);
  pinMode(LEDpin, OUTPUT);
  pinMode(EncoderPin, OUTPUT);
  pinMode(TECpositivePin, OUTPUT);
  pinMode(TECnegativePin, OUTPUT);

  setupPID();
  setupSiPM();
  setupBlink();
  Serial.begin(BAUD_RATE);
}

void loop(){
  Serial.println();
}





