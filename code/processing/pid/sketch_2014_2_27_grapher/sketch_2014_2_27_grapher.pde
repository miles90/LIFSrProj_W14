
import processing.serial.*;

PrintWriter output;
Serial myPort;
PFont myFont;
PGraphics pg, txt;
int w, h, x, xbuff;
int temp_1, trgt_1, outpt_1, crnt_1,sipm_1;
String filename, date;
double kp, ki, kd;
int temp, trgt, outpt, crnt, sipm;
String typing;

void serialEvent(Serial myPort)
{
  String inString = myPort.readStringUntil('\n');
  double Kp, Kd, Ki;
  if (inString != null)
  {

    inString = inString.trim();
    String[] inValue = split(inString, ",");
    temp = int(h*(1/2 - float(inValue[0])/100));
    trgt = inValue.length > 1 ? int(h*(1/2 - float(inValue[1])/100)) : trgt;
    outpt = inValue.length > 2 ? int(h*(1/2 - float(inValue[2])/200)) : outpt;
    crnt = inValue.length > 3 ? int(h*(1/2 - 1.5*float(inValue[3])/2)) : crnt;
    sipm = inValue.length > 4 ? int(h*float(inValue[4])/65536) : sipm;
    kp = inValue.length > 5 ? float(inValue[5]) : kp;
    ki = inValue.length > 6 ? float(inValue[6]) : ki;
    kd = inValue.length > 7 ? float(inValue[7]) : kd;
    output.println(inString);
    if (temp_1 == 0) {
      temp_1 = temp;
    }
    pg.beginDraw();
    pg.strokeWeight(1);
    pg.stroke(150, 200, 100);
    pg.line(x, h/2 + temp_1, x+1, h/2 + temp);
    pg.stroke(250, 100, 150);
    pg.line(x, h/2 + trgt_1, x+1, h/2 + trgt);
    pg.stroke(50, 100, 250);
    pg.line(x, h/2 + outpt_1, x+1, h/2 +outpt);
    pg.stroke(100, 100, 50);
    pg.line(x, h/2 + crnt_1, x+1, h/2 + crnt);
    pg.stroke(150, 100, 50);
    pg.line(x, h-sipm_1, x+1, h-sipm);
    pg.endDraw();
    image(pg, 0, 0);
    sipm_1 = sipm;
    temp_1 = temp;
    trgt_1 = trgt;
    outpt_1 = outpt;
    crnt_1 = crnt;
    x++;
    if (x >=w-75)
    {
      pg.save(filename);
      xbuff++;
      filename = date+xbuff+".png";
      x = 25;
      plotaxes();
    }
  }
}
/*
   void keyPressed()
 {
 if (key == '\n')
 {
 
 }
 }
 */
void plotaxes()
{
  int tx, bx=w-180;
  int scale = 4095;
  int i;
  pg.clear();
  pg.background(255);
  pg.beginDraw();
  pg.strokeWeight(1);
  pg.fill(0);
  pg.text("THERMISTOR TEST", h/2-50, 15);
  pg.fill(150, 200, 100);
  pg.stroke(50, 200, 150);
  pg.text("temperature (C)", bx, 15);
  for (i=-50;i<=50; i+=10) {
    pg.line(0, h*(i+50)/100, w, h*(i+50)/100);
  }
  for (i=-50;i<=50;i+=2) {
    pg.text(i, 10, h/2-i*h/100+10);
  }

  pg.fill(250, 100, 150);
  pg.text("target (C)", bx, 30);
  pg.fill(50, 100, 250);
  pg.text("PID output (%)", bx, 45);
  for (i=-100;i<=100;i+=5) {
    pg.text(i, w-20, h/2-i*h/200+10);
  }
  pg.fill(100, 100, 50);
  pg.text("output current (mA)", bx, 60);
  for (i=0;i<=1500;i+=40) {
    pg.text(i, w-50, h/2-i*h/3000+10);
  }
  pg.stroke(0);
  pg.line(0, (h)/2, w, (h)/2);
  pg.line(5, 0, 5, h);
  pg.fill(100, 100, 100);
  pg.text(kp+"", x, h-15*3);
  pg.text(ki+"", x, h-15*2);
  pg.text(nf((float)kd, 1, 3), x, h-15*1);
  pg.endDraw();
  image(pg, 0, 0);
}

void keyPressed()
{
  // If the return key is pressed, save the String and clear it
  if (key == '\n' )
  {
    typing += "\n\r";
    myPort.write(typing);
    if (typing.trim().equals("stop"))
    {
      pg.save(filename);
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
      //exit(); // Stops the program
    }
    typing = "";
  }
  else if (keyCode == UP || keyCode == DOWN ||
    keyCode == LEFT || keyCode == RIGHT || keyCode == SHIFT ||
    keyCode == ALT || keyCode == CONTROL)
  {/*do nothing for now */
  }
  else {
    if ((keyCode == BACKSPACE || keyCode == DELETE) && typing.length() >0)
    {
      typing = typing.substring(0, typing.length()-1);
    }
    else
    {
      typing = typing + key;
    }
  }
  txt.beginDraw();
  txt.background(0);
  txt.textFont(myFont);
  txt.fill(255);
  txt.text(typing, 10, 10);
  txt.endDraw();
  image(txt, 0, h+11);
}

void setup()
{
  typing = "";
  date = "sipmPID-"
    +year()+"-"+month()+"-"+day()+"-"
    +hour()+":"+minute()+":"+second()+"-";
  filename = date+xbuff+".png";
  x = 25;
  xbuff = 0;
  temp_1 = 0;
  w = 800;
  h = 600;
  size(w, h+15+11);
  pg = createGraphics(w, h+11);
  txt = createGraphics(w, 15);


  output = createWriter(date+xbuff+".txt");
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
  myPort.clear();
  myPort.bufferUntil('\n');

  myFont = createFont("Arial", 10, true);

  textFont(myFont);
  background(255);
  smooth();
  pg.background(255);
  txt.background(255);
  plotaxes();
}

void draw()
{
}

