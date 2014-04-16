import java.io.*;
import javax.swing.JOptionPane;
import processing.serial.*;

int BAUD_RATE = 9600;//460800;

PFont f, fButton;
FileOutputStream fstream;
BufferedOutputStream bstream;
DataOutputStream outputfile;
Serial teensyPort;

int max16 = 65535;
int out0, out1, crnt0, crnt1, temp0, temp1, trgt0, trgt1, adc0, adc1, graphPos = 0, graphHeight;
int windowWidth = 600, 
windowHeight = 480, 
uiHeight = 50, 
backgroundColor = 255, 
lastByte = 0, 
maxBytes = 500, 
dataIndex = 0;
long lastTime;
int [] inData;
String date, typeBuffer = "";
String [] translationCmdStr = {
  "", "", "", "", "", ""
}
, translationBtnStr = {
  "Stage X", "Stage Y", "Stage Z", "Pin X", "Pin Y", "Pin Z"
}
, tecCmdStr = {
  "", "", "", "", ""
}
, tecBtnStr = {
  "Temp", "Kp", "Ki", "Kd", "plain"
};
char [] translationCmdPrefix = {
  'x', 'y', 'z', 'X', 'Y', 'Z'
}
, tecCmdPrefix = {
  't', 'p', 'i', 'd', '\n'
};
char mode, DIRECTMODE = 'd', TECMODE = 'c';
boolean [] translationFlags, tecFlags;

boolean keyup = false;
boolean keyright = false;
boolean keyleft = false;
boolean keydown = false;
boolean keyshift = false;
boolean keyctrl = false;
boolean keyalt = false;
boolean byte2 = false;
boolean readingDataSetFlag, startTeensyDataSetFlag, runButtonOverFlag, tecModeHover, directModeHover;
int [] translationBoxLocation, tecBoxLocation;
int btnRad = 7, btnH = 22, 
runBtnX = 2, runBtnY = 2, runBtnW = 80, txtBoxW = 100, txtBoxX = windowWidth-2-txtBoxW, txtBoxY = 2, activeButtonIndex = 0, activeTecIndex = 0, 
tecBtnW = 40, tecBtnX = windowWidth-2-tecBtnW, tecBtnY = 4+btnH, 
directBtnW = 80, directBtnX = windowWidth-2-directBtnW-tecBtnW, directBtnY = 4+btnH;



color runBtnSetColor = color(200, 100, 200), 
runBtnUnsetColor = color(150, 250, 150), 
uiBackgroundColor = color(250, 240, 250);

PGraphics ui, graph;

void setup() {
  inData = new int[maxBytes];
  mode = DIRECTMODE;
  initDirectBoxArrays();
  initTecBoxArrays();
  readingDataSetFlag = false;
  startTeensyDataSetFlag = false;
  runButtonOverFlag = false;
  graphHeight = windowHeight - uiHeight;
  String prefix = "teensy_sipm_recordings-";
  date = year()+"-"+month()+"-"+day()+"-"
    +hour()+":"+minute()+":"+second()+"-";

  size(windowWidth, windowHeight);
  background(backgroundColor);
  smooth();
  f = createFont("Arial", 14, true);
  fButton = createFont("Helvetica", 15, true);

  ui = createGraphics(windowWidth, uiHeight);

  graph = createGraphics(windowWidth, graphHeight);


  try {
    teensyPort = new Serial(this, Serial.list()[getPortNum()], BAUD_RATE);
  } 
  catch(Exception e) {
    println("Could not connect to teensy Serial. " + e);
    exit();
  }
  teensyPort.clear();

  String storagePath = System.getProperty("user.home")+ File.separator+ prefix+date+ ".bin";
  try {
    fstream = new FileOutputStream(storagePath);
  }
  catch(FileNotFoundException e) {
    println("File not found exception: " + storagePath);
  }
  bstream = new BufferedOutputStream(fstream);
  outputfile = new DataOutputStream(bstream);
  //
  graph.background(250);
}
void draw() {
  HandleDrawingToWindow();
  if (startTeensyDataSetFlag) {
    readingDataSetFlag = true;
    teensyPort.write("start\n\r");
    startTeensyDataSetFlag = false;
  }
  if (millis()-lastTime > 40 && readingDataSetFlag) {
    if (dataIndex > 5) {
      drawGraph();
    }
  }
}

void serialEvent(Serial p)
{
  int inByte=0;
  inByte = p.read();
  if (byte2) {
    inData[dataIndex++] = (lastByte << 8)+ inByte;
    lastTime = millis();
  }
  lastByte = inByte;
  byte2 = !byte2;
  try {
    outputfile.write(inByte);
    outputfile.flush();
  }
  catch(IOException e) {
    println("IOException - writing serial bytes ");
  }
}


void HandleDrawingToWindow() {

  ui.beginDraw();
  ui.background(uiBackgroundColor);
  drawDataCollectionUI();
  if (mode == DIRECTMODE) drawDirectModeBlocks();
  else if (mode == TECMODE) drawTECModeBlocks();
  drawDirectModeChooser();
  drawTECModeChooser();
  ui.endDraw();
  image(ui, 0, 0);
}

boolean DrawCommandButton(String btnText, boolean btnActive, int x, int y, int w) {
  ui.fill(runButtonOver(x, y, w, btnH)? color(200, 100, 100):(btnActive?255:color(100, 200, 200)));
  ui.stroke(0);
  ui.rect(x, y, w, btnH, btnRad);

  ui.fill(0);
  ui.textFont(fButton);
  ui.textAlign(CENTER, CENTER);
  ui.text(btnText, x+w/2, y+btnH/2);
  return runButtonOver(x, y, w, btnH);
}

boolean runButtonOver(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } 
  else {
    return false;
  }
}

void mousePressed() {
  if (runButtonOverFlag && !readingDataSetFlag && !startTeensyDataSetFlag) startTeensyDataSetFlag = true;
  else if (runButtonOverFlag && readingDataSetFlag && !startTeensyDataSetFlag) readingDataSetFlag = false;
  if (mode == DIRECTMODE) directModeMousePressed();
  if (mode == TECMODE) tecModeMousePressed();
  if (directModeHover) mode = DIRECTMODE;
  if (tecModeHover) mode = TECMODE;
}

void keyPressed() {
  if (key==CODED) {
    if (keyCode == UP) keyup = true; 
    if (keyCode == DOWN) keydown = true; 
    if (keyCode == LEFT) keyleft = true; 
    if (keyCode == RIGHT) keyright = true;
    if (keyCode == SHIFT) keyshift = true;
    if (keyCode == CONTROL) keyctrl = true;
    if (keyCode == ALT) keyalt = true;
  }
  if (mode == DIRECTMODE)  directModeKeyPressed();
  if (mode == TECMODE)  tecModeKeyPressed();
  if (keyalt && !keyshift && !keyctrl && keyleft && mode == TECMODE) mode = DIRECTMODE;
  if (keyalt && !keyshift && !keyctrl && keyright && mode == DIRECTMODE) mode = TECMODE;
  if (keyalt && !keyshift && !keyctrl && keyup) startTeensyDataSetFlag = true;
  if (keyalt && !keyshift && !keyctrl && keydown) readingDataSetFlag = false;
}
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) keyup = false; 
    if (keyCode == DOWN) keydown = false; 
    if (keyCode == LEFT) keyleft = false; 
    if (keyCode == RIGHT) keyright = false;
    if (keyCode == SHIFT) keyshift = false;
    if (keyCode == CONTROL) keyctrl = false;
    if (keyCode == ALT) keyalt = false;
  }
}

int getPortNum() {
  String[] portStr = Serial.list();
  int nPort = portStr.length;
  int index = -1;
  int ACMcount = 0;
  for (int i=0; i<nPort; i++) {
    if (match(portStr[i], "ACM") != null) {
      index = i;
      ACMcount++;
    } 
    portStr[i] =  i+ " "+portStr[i] ;
  }
  if (nPort < 1 || index < 0) {
    javax.swing.JOptionPane.showMessageDialog(frame, "No devices detected: please check Arduino power and drivers.");  
    exit();
  }
  if (ACMcount == 1) {
    return index;
  }
  String respStr = (String) JOptionPane.showInputDialog(null, 
  "Choose your device (if not listed: check drivers and power)", "Select Arduino", 
  JOptionPane.PLAIN_MESSAGE, null, 
  portStr, portStr[index]);
  return Integer.parseInt(respStr.substring(0, 1));
}

