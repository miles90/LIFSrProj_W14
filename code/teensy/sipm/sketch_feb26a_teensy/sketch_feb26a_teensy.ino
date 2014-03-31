#include "./PID_v1.h"
#include "math.h"


#define encPIN 10
#define plusPIN 11
#define minPIN 12
#define tempPIN 1 // temperature reading
#define crntPIN 0 // current, in Amperes
#define VMAX12 4095
#define VMAX16 65536
#define VRF 3.3
#define T0 298.15
#define B 4500.71
#define R2 2.13
#define R0 2.20
#define C0 273.15
#define NumAverageSamples 32

char line[50];
double x[17], y[17];
double consKp, consKd, consKi, Input, Output, Setpoint, ratio, alpha, Ts;
int lastTime;
PID tecPID(&Input, &Output, &Setpoint, consKp, consKi, consKd, REVERSE);

double gettemp(double vratio);
double getvratio(double temp);
double calc_voltage(int level);

void printinfo();
void writeoutput();
int readline(int readch, char *buffer, int len);
void interpretcommand(char *line);
void setup();
void loop();

double lowpassfilt(double *x, double *y, double temp)
{
  for (int i = 16; i <= 0; i--)
  {
    x[i] = x[i - 1];
    y[i] = y[i - 1];
  }

  x[0] = temp;
  y[0] = x[0] + x[1];//(y[2] + 2 * y[4] + y[8] + y[16])*alpha;
  return y[0];
}
double gettemp(double vratio)
{
  return 1 
    / (
  (log(R2) 
    + log(1 - vratio / VMAX16) 
    - log(R0) 
    - log(vratio) 
    + log(VMAX16)) 
    / B 
    + 1 / T0
    );
}
double getvratio(double temp)
{
  return R2 / (R2 + R0 * exp(B * (1 / temp - 1 / T0)));
}
double calc_voltage(int level)
{
  return VRF * level / VMAX16;
}
void printinfo()
{
  int current = analogRead(crntPIN);
  Serial.print(Input - C0);
  Serial.print(",");
  Serial.print(Setpoint - C0);
  Serial.print(",");
  Serial.print(Output);
  Serial.print(",");
  Serial.print(calc_voltage(current));
  Serial.print(",");
  Serial.print(consKp);
  Serial.print(",");
  Serial.print(consKi);
  Serial.print(",");
  Serial.print(consKd);
  Serial.print(",");
  Serial.print(Ts);
  Serial.println();
}
void writeoutput()
{
  analogWrite(encPIN, abs(Output)*VMAX16/100);
  digitalWrite(plusPIN, Output >= 0 ? HIGH : LOW);
  digitalWrite(minPIN, Output >= 0 ? LOW : HIGH);
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
void interpretcommand(char *line)
{
  char buff[50];
  memcpy(buff, &line[1], strlen(line) - 1);
  switch (line[0])
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
  case 'f':
    Ts = atof(buff);
    tecPID.SetSampleTime(Ts);
    break;
  case 'a':
    alpha = atof(buff);
    break;
  default:
    if (line[0] == 's' && line[1] == 't' && line[2] == 'o' && line[3] == 'p' ) {
      end();
    }
    break;
  }
  memset(&line[0], 0, sizeof(char) * 50);
  memset(&buff[0], 0, sizeof(char) * 50);
}
void end()
{
  Output = 0;
  writeoutput();
  exit(0);
}
void setup()
{
  analogReadResolution(16);
  analogReadAveraging(NumAverageSamples);
  pinMode(encPIN, OUTPUT);
  pinMode(minPIN, OUTPUT);
  pinMode(plusPIN, OUTPUT);
  consKp = 10; 
  consKi = 10;//.01;
  consKd = .10;//.001; 
  alpha = 2;
  Setpoint = 22 + C0; // degrees C
  Ts = 0;
  double tmp = analogRead(tempPIN);
  Input = gettemp(tmp);//lowpassfilt(x, y, gettemp(tmp));

  tecPID.SetMode(AUTOMATIC);
  tecPID.SetOutputLimits(-100, 100);
  tecPID.SetSampleTime(1);
  lastTime = micros();
}
void loop()
{
  if (readline(Serial.read(), line, 50) > 0)
  {
    interpretcommand(line);
  }
  if(lastTime-micros() > 1000){
    lastTime = micros();
    double tmp = analogRead(tempPIN);
    Input = gettemp(tmp);
    tecPID.SetTunings(consKp, consKi, consKd);
    tecPID.Compute();
    writeoutput();
    printinfo();
  }
  if (Input >= 35 + C0)
  {
    end();
  }
}

