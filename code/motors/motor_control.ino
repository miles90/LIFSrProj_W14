#include <Stepper.h>
#include <Wire.h> 
#include <SoftwareSerial.h>
#include <Adafruit_MotorShield.h> 
#include "utility/Adafruit_PWMServoDriver.h"  

#define Xmax 2500	// 2500 steps * 4 microns per step ~= 1 cm 
#define Ymax 2500 
#define Zmax 2500 
#define mode 1		// 1 for calibration mode, 2 for regular operation   

// change these values to whatever results we get from calibration 
#define calibrated_x 1234 
#define calibrated_y 1234 
#define calibrated_z 1234  

SoftwareSerial mySerial(10, 11);

Adafruit_MotorShield AFMS = Adafruit_MotorShield();
Adafruit_StepperMotor *pinhole_x = AFMS.getStepper(200, 1); 
Adafruit_StepperMotor *pinhole_y = AFMS.getStepper(200, 2); 
Adafruit_StepperMotor *pinhole_z = AFMS.getStepper(200, 3); 
Adafruit_StepperMotor *sample_x = AFMS.getStepper(200, 4); 
Adafruit_StepperMotor *sample_y = AFMS.getStepper(200, 5); 
Adafruit_StepperMotor *sample_z = AFMS.getStepper(200, 6);  

int SPM = A0;   

void setup() 
{ 	 	 	  	
  AFMS.begin();
    
  // set the motor speed at 60 RPMS 	
  pinhole_x->setSpeed(60); 	
  pinhole_y->setSpeed(60);	 	
  pinhole_z->setSpeed(60); 	
  sample_x->setSpeed(60); 	
  sample_y->setSpeed(60); 	
  sample_z->setSpeed(60);   	

  // Initialize the Serial port: 	
  Serial.begin(9600);  	
}  

void move_sample() 
{  	
  int instruction = 0;  	
  //instructions subject to change based on possibility of using arrow keys and shift 	
  Serial.println("Move the sample in the x-y direction with the ASDW keys.  Use F and R"); 	
  Serial.println("to move the sample up and down.  For larger movements, use uppercase."); 	
  Serial.println("Use lowercase for smaller movements.  Press L when done.\n");  	
  
  while (instruction != 76)  // while instruction not enter 	
  { 		
    instruction = Serial.read(); 		 		
    switch(instruction) 		
    {
      case 65:  //A 
        sample_x->step(10, BACKWARD, SINGLE);
        delay(100);
        Serial.println("A received.  Moved sample left 10 steps.");
        break;
      case 97:  //a
        sample_x->step(1, BACKWARD, SINGLE);
        delay(100);
        Serial.println("a received.  Moved sample left 1 step.");
        break;
      case 83:  //S 
        sample_y->step(10, BACKWARD, SINGLE);
        delay(100);
        Serial.println("S received.  Moved sample backward 10 steps.");
        break;
      case 115:  //s
        sample_y->step(1, BACKWARD, SINGLE);
        delay(100);
        Serial.println("s received.  Moved sample backward 1 step.");
        break;
      case 68:  //D 
        sample_x->step(10, FORWARD, SINGLE);
        delay(100);
        Serial.println("D received.  Moved sample right 10 steps.");
        break;
      case 100:  //d
        sample_x->step(1, FORWARD, SINGLE);
        delay(100);
        Serial.println("d received.  Moved sample right 1 step.");
        break;
      case 87:  //W 
        sample_y->step(10, FORWARD, SINGLE);
        delay(100);
        Serial.println("W received.  Moved sample forward 10 steps.");
        break;
      case 119:  //w
        sample_y->step(1, FORWARD, SINGLE);
        delay(100);
        Serial.println("w received.  Moved sample forward 1 step.");
        break;
      case 70:  //F 
        sample_z->step(10, BACKWARD, SINGLE);
        delay(100);
        Serial.println("F received.  Moved sample down 10 steps.");
        break;
      case 102:  //f
        sample_z->step(1, BACKWARD, SINGLE);
        delay(100);
        Serial.println("f received.  Moved sample down 1 step.");
        break;
      case 82:  //R 
        sample_z->step(10, BACKWARD, SINGLE);
        delay(100);
        Serial.println("R received.  Moved sample up 10 steps.");
        break;
      case 114:  //r
        sample_z->step(1, BACKWARD, SINGLE);
        delay(100);
        Serial.println("r received.  Moved sample up 1 step.");
        break;
      default:
        break;
    }
  }
  
  Serial.println("L received.  Terminating sample movement.\n");
  
  if (mode == 1)
    calibrate_pinhole();
  else
    move_pinhole();
  
}
   
void calibrate_pinhole()
{
  float samples[Xmax];
  int x, y, z;
  float maximum = 0.0;
  float max_x, max_y, max_z;
  
  Serial.println("Calibrating pinhole location...\n");
  delay(1000);
  
  pinhole_x->step(2500, BACKWARD, SINGLE);
  pinhole_y->step(2500, BACKWARD, SINGLE);
  pinhole_z->step(2500, BACKWARD, SINGLE);

  for (z = 0; z < Zmax; z++)
  {
    for (y = 0; y < Ymax; y++)
    {
      //step forward for a row
      for (x = 0; x < Xmax; x++)
      {
        samples[x] = analogRead(SPM);      //there may be a timing issue with this analogRead function  
        pinhole_x->step(1, FORWARD, SINGLE);
      }
      //smooth the dataa
      average_row(samples, 10);
      average_row(samples, 7);
      average_row(samples, 5); 
   
      for (x = 0; x < Xmax; x++)
      {
        if (samples[x] > maximum)
        {
          maximum = samples[x];
          max_x = x;
          max_y = y;
          max_z = z;
        }
      }
      
      pinhole_x->step(2500, BACKWARD, SINGLE);
      pinhole_y->step(1, FORWARD, SINGLE);
    
    }
    
    pinhole_x->step(2500, BACKWARD, SINGLE);
    pinhole_y->step(2500, BACKWARD, SINGLE);
    pinhole_z->step(1, FORWARD, SINGLE);
  
  }
    
}
  
  
  
  
  
  


void move_pinhole()
{
  int x, y, z;
  int max_x, max_y, max_z;
  float first_sample, second_sample, third_sample;
  float maximum = 0.0;
  float average;
  

  pinhole_x->step(2500, BACKWARD, SINGLE);
  pinhole_y->step(2500, BACKWARD, SINGLE);
  pinhole_z->step(2500, BACKWARD, SINGLE);
  pinhole_x->step(calibrated_x-20, FORWARD, SINGLE);
  pinhole_y->step(calibrated_x-20, FORWARD, SINGLE);
  pinhole_z->step(calibrated_x-20, FORWARD, SINGLE);

  for (z = -20; z <= 20; z++)
  {
    for (y = -20; y <= 20; y++)
    {
      for (x = -20; x <= 20; x++)
      {
        first_sample = analogRead(SPM);    //there may be a timing issue with these analogRead functions
        delay(1);
        second_sample = analogRead(SPM);
        delay(1);
        third_sample = analogRead(SPM);
        average = (first_sample + second_sample + third_sample) / 3.0;
        if (average > maximum)
        {
          maximum = average;
          max_x = x;
          max_y = y;
          max_z = z;
        }
        pinhole_x->step(1, FORWARD, SINGLE);
      }
      pinhole_x->step(41, BACKWARD, SINGLE);
      pinhole_y->step(1, FORWARD, SINGLE);
    }
    pinhole_x->step(41, BACKWARD, SINGLE);
    pinhole_y->step(41, BACKWARD, SINGLE);
    pinhole_z->step(1, FORWARD, SINGLE);
  }
  
  pinhole_x->step(41, BACKWARD, SINGLE);
  pinhole_y->step(41, BACKWARD, SINGLE);
  pinhole_z->step(41, BACKWARD, SINGLE);
  
  pinhole_x->step(max_x, FORWARD, SINGLE);
  pinhole_y->step(max_y, FORWARD, SINGLE);
  pinhole_z->step(max_z, FORWARD, SINGLE);
  
}
   
void loop()
{
  move_sample(); 
}

void average_row(float sample[], int sample_size) 
{ 
  int x;
  int i;
  float sum;
  float temp_array[26];
  for (x = 0; x < 26; x++)
    temp_array[x] = sample[x];

  for(x = 0; x < sample_size; x++) 	
  {
    sum = 0; 	
    for(i = -x; i <= sample_size; i++) 	
    {
      sum += temp_array[x+i]; 	
    }
    sample[x] = sum/(sample_size + 1 + x);
  } 

  for(x = sample_size; x < (26 - sample_size); x++) 	
  {
    sum = 0;
    for(i = -sample_size; i <= sample_size; i++) 	
    {
      sum += temp_array[x+i]; 	
    }
    sample[x] = sum/(2*sample_size + 1); 
  } 	
  
  for(x = 26 - sample_size; x < 26; x++) 	
  { 	
    sum = 0;
    for (i = -sample_size; i <= (26-x-1); i++) 	
    {
      sum += temp_array[x+i]; 		
    }
    sample[x] = sum/(sample_size + 1 + (26-x-1)); 	
  }
  
}
