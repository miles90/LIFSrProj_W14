#include <SoftwareSerial.h>

#define Xmax = 26;

SoftwareSerial mySerial(10, 11);

void setup() 
{
  Serial.begin(9600);
} 

void loop()
{
  test_algorithm();
  delay(100000);
}

void test_algorithm() 
{ 	
  float test_data[26] = {0,0,0,1,1,3,7,4,5,8,4,8,9,10,11,10,9,8,7,6,5,4,3,2,1,0};
  int i; 	
  
  average_row(test_data, 5);
  average_row(test_data, 3); 
  average_row(test_data, 2); 
    
  for (i = 0; i < 26; i++)	 	
  {
    Serial.print(test_data[i], DEC); 
    Serial.print("\n"); 
  }
  Serial.print("\n"); 
  
  delay(100000);
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







	/*
  int x;
  int i; 
  int sum; 	
  int[Xmax] smoothed; 	 	

  for(x = 0; x < sample_size; x++) 	
  {
    sum = 0; 	
    for(i = -x; i < sample_size; i++) 	
    {
      sum += sample[x+i]; 	
    }
    smoothed[x] = sum/(sample_size + 1 + x) 
  } 		 	
  
    


}
*/

