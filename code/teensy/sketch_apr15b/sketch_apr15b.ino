#include "./PID_v1.h"

#define LEDPin 13
#define STRLEN 50
#define BAUD_RATE 115200  //921600 //460800 // 230400 //115200
#define BAUD1_RATE 9600
#define encPIN 12
#define plusPIN 11
#define minPIN 10
#define tempPIN 3 // temperature reading
#define crntPIN 2 // current, in Amperes
#define SiPMpin 0 // SiPM power reading pin
#define VMAX12 4095
#define VMAX16 65536
#define VRF 3.3
#define T0 298.15
#define B 4500.71
#define R2 2.13
#define R0 2.20
#define C0 273.15
#define NumAverageSamples 32
#define MaxNumTimesToRunADCInterrupt 2001
#define NumSerialBytes 2
#define NumcollectData 1

char inString[STRLEN], inString1[STRLEN];
double consKp, consKd, consKi, Input, Output, Setpoint;
int temperature, current, targetTemp;
int loopcounter;
volatile boolean runcollectDataTimerInterrupt, runADCtimerInterrupt, runPIDtimerInterrupt;
volatile int ADCinterruptCounter;
volatile int ADCtimerInterruptInMicroSeconds = 8; //how often take ADC data from the SiPM
volatile int PIDtimerInterruptInMilliSeconds = 10;
volatile int collectDatatimerInterruptInMilliSeconds = 40;
volatile int ADCdata[MaxNumTimesToRunADCInterrupt];
volatile int NumTimesToRunADCInterrupt = 20;
volatile int elapsedTimeForADCInterrupt;
volatile int collectDataInterruptCounter =0;
volatile int pidoutput;
IntervalTimer ADCtimer;
IntervalTimer PIDtimer;
IntervalTimer collectDataTimer;

elapsedMicros totalTimeForADCInterruptSeries;

PID tecPID(&Input, &Output, &Setpoint, consKp, consKi, consKd, REVERSE);

void ADCtimerfunctionUseRAM(){
  unsigned char serialBytes[NumSerialBytes];
  if(runADCtimerInterrupt){
    ADCinterruptCounter++;
    if(ADCinterruptCounter == 1) totalTimeForADCInterruptSeries=0;
    ADCdata[ADCinterruptCounter] = analogRead(SiPMpin);
    if (ADCinterruptCounter >= NumTimesToRunADCInterrupt) {
      elapsedTimeForADCInterrupt = totalTimeForADCInterruptSeries;
      runADCtimerInterrupt = false;
      digitalWriteFast(LEDPin, LOW);
      for(int i=0; i<NumTimesToRunADCInterrupt; i++){
        serialBytes[0] = (ADCdata[i] >> 8) & 0xff;
        serialBytes[1] = ADCdata[i] & 0xff;
        Serial.write(serialBytes, NumSerialBytes);
      }
      writeStatus();
    }
  }
}

void writeStatus(){
  unsigned char serialBytes[NumSerialBytes];
  pidoutput = (((Output)/2+50)*VMAX16/100);
  serialBytes[0] = (pidoutput >> 8) & 0xff;
  serialBytes[1] = pidoutput & 0xff;
  Serial.write(serialBytes, NumSerialBytes);
  current = analogRead(crntPIN);
  serialBytes[0] = (current >> 8) & 0xff;
  serialBytes[1] = current & 0xff;
  Serial.write(serialBytes, NumSerialBytes);
  serialBytes[0] = (temperature >> 8) & 0xff;
  serialBytes[1] = temperature & 0xff;
  Serial.write(serialBytes, NumSerialBytes);
  targetTemp = Setpoint;
  serialBytes[0] = (targetTemp >> 8) & 0xff;
  serialBytes[1] = targetTemp & 0xff;
  Serial.write(serialBytes, NumSerialBytes);
  /*
  serialBytes[0] = (elapsedTimeForADCInterrupt >> 24) & 0xff;
   serialBytes[1] = (elapsedTimeForADCInterrupt >> 16) & 0xff;
   Serial.write(serialBytes, NumSerialBytes); 
   serialBytes[0] = (elapsedTimeForADCInterrupt >> 8) & 0xff;
   serialBytes[1] = elapsedTimeForADCInterrupt & 0xff;
   Serial.write(serialBytes, NumSerialBytes);
   */
}

void calculatePID(){
  if(runPIDtimerInterrupt){
    temperature = analogRead(tempPIN);
    Input = 1 / ((log(R2) + log(1 - temperature / VMAX16)- log(R0)- log(temperature) + log(VMAX16)) / B + 1 / T0);
    tecPID.SetTunings(consKp, consKi, consKd);
    tecPID.Compute();
    writeoutput();
  }
}
void collectDataInterrupt(){
  unsigned char serialBytes[NumSerialBytes];
  if(runcollectDataTimerInterrupt && !runADCtimerInterrupt){
    collectDataInterruptCounter += 1;
    digitalWriteFast(LEDPin, HIGH);
    ADCinterruptCounter = 0;
    runADCtimerInterrupt = true;
    if(collectDataInterruptCounter > NumcollectData){
      runcollectDataTimerInterrupt = false;
      serialBytes[0] = 0 & 0xff;
      serialBytes[1] = 0 & 0xff;
      Serial.write(serialBytes,NumSerialBytes);
    }
  }
}

void ADCtimer_setup(){
  ADCtimer.begin(ADCtimerfunctionUseRAM, ADCtimerInterruptInMicroSeconds);
}
void PIDtimer_setup(){
  PIDtimer.begin(calculatePID, PIDtimerInterruptInMilliSeconds*1000);
}
void collectDataTimer_setup(){
  collectDataTimer.begin(collectDataInterrupt, collectDatatimerInterruptInMilliSeconds*1000);
}
void ADCtimer_stop(){ 
  ADCtimer.end(); 
}
void PIDtimer_stop(){
  PIDtimer.end();
}
void collectDataTimer_stop(){
  collectDataTimer.end();
}


void writeoutput()
{
  analogWrite(encPIN, abs(Output)*VMAX16/100);
  digitalWrite(plusPIN, Output >= 0 ? HIGH : LOW);
  digitalWrite(minPIN, Output >= 0 ? LOW : HIGH);
}

void setup(){
  loopcounter = 0;
  consKp = 10; 
  consKi = 1;//.01;
  consKd = .010;//.001; 
  Setpoint = -15 + C0; // degrees C

  ADCinterruptCounter = 0;
  runcollectDataTimerInterrupt = false;
  runADCtimerInterrupt = false;
  runPIDtimerInterrupt = false;

  tecPID.SetMode(AUTOMATIC);
  tecPID.SetOutputLimits(-100, 100);
  tecPID.SetSampleTime(PIDtimerInterruptInMilliSeconds);

  analogReadResolution(16);
  analogReadAveraging(NumAverageSamples);
  pinMode(encPIN, OUTPUT);
  pinMode(minPIN, OUTPUT);
  pinMode(plusPIN, OUTPUT);
  pinMode(LEDPin, OUTPUT); 
  digitalWriteFast(LEDPin, HIGH);

  ADCtimer_setup();
  PIDtimer_setup();
  collectDataTimer_setup();

  Serial1.begin(BAUD1_RATE);
  Serial.begin(BAUD_RATE);
  delay(2000);
  Serial.flush();
  Serial1.flush();
}

void loop(){
  loopcounter++;
  if(loopcounter ==1){
    Serial.flush();
    Serial1.flush();
  }
  /*if (readline(Serial.read(), inString, STRLEN) > 0){
    interpretcommand(inString);
  }*/
  if (!runcollectDataTimerInterrupt) {
   if (readline(Serial.read(), inString, 50) > 0){
   interpretcommand(inString);
   }
   }
}

void interpretcommand(char *str){
  char buff[STRLEN];
  memcpy(buff, &str[1], STRLEN - 1);
  if(!strcmp(str, "test")){
    char sb[2];
    int i=12345;
    sb[0] = (i >> 8) & 0xff;
    sb[1] = i & 0xff;
    //Serial.println("hi");
    Serial.write(sb,2);
  }
  else if(!strcmp(str, "start")){
    digitalWriteFast(LEDPin, LOW);
    collectDataInterruptCounter = 0;
    runcollectDataTimerInterrupt = true;

  }
  else if(!strcmp(str, "stop")){
    runPIDtimerInterrupt = false;
    Output = 0;
    writeoutput();
  }
  else if(!strcmp(str, "update")){
    collectDataInterruptCounter = 0;
    runcollectDataTimerInterrupt = true;
  }
  else{
    switch (str[0])
    {
    case 't':
      Setpoint = atof(buff) + C0;
      break;
    case 'p':
      consKp = atof(buff);
      break;
    case 'i':
      consKi = atof(buff);
      break;
    case 'd':
      consKd = atof(buff);
      break;
    default:
      char sb = atoi(buff) & 0xff;
      if(str[0] == 'x' || str[0] == 'X'){
        Serial1.write(1 & 0xff);
        Serial1.write(sb);
      }
      if(str[0] == 'y' || str[0] == 'Y' ){
        Serial1.write(2 & 0xff);
        Serial1.write(sb);
      }
      if( str[0] == 'z' || str[0] == 'Z'){
        Serial1.write(3 & 0xff);
        Serial1.write(sb);
      }
      break;
    }
  }
  memset(&str[0], 0, sizeof(char) * STRLEN);
  memset(&buff[0], 0, sizeof(char) * STRLEN);
}


int readline(int readch, char *buffer, int len)
{
  static int pos = 0;
  int rpos;

  if (readch > 0) {
    switch (readch) {
    case '\n': // Ignore new-lines
      break;
    case '\r': // Return on CR
      rpos = pos;
      pos = 0;  // Reset position index ready for next time
      return rpos;
    default:
      if (pos < len - 1) {
        buffer[pos++] = readch;
        buffer[pos] = 0;
      }
    }
  }
  // No end of line has been found, so return -1.
  return -1;
}
























