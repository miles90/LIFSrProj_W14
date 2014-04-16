void initTecBoxArrays() {
  tecBoxLocation = new int[5];
  tecBoxLocation[0] = runBtnX+runBtnW+2;
  for (int i=0; i<tecBoxLocation.length; i++) {
    tecBoxLocation[i] = i==0? tecBoxLocation[i] : 55+tecBoxLocation[i-1] + 2;
  }
  tecFlags = new boolean[10];
  tecFlags[1] = true;
}
void drawTECModeBlocks() {
  for (int i = 0; i < tecBoxLocation.length; i++) {
    tecFlags[i*2] = DrawCommandButton(tecBtnStr[i], tecFlags[i*2+1], tecBoxLocation[i], 2, 55);
  }
}
void tecModeMousePressed() {
  for (int i=0; i<tecFlags.length; i+=2) {
    if (tecFlags[i]) {
      tecFlags[activeTecIndex*2+1] = false;
      tecFlags[i+1] = true;
      activeTecIndex = i/2;
    }
  }
}
void drawTECModeChooser() {
  tecModeHover = runButtonOver(tecBtnX, tecBtnY, tecBtnW, btnH);
  ui.fill(tecModeHover? 100:(mode==TECMODE? 0:255));
  ui.stroke(0);
  ui.rect(tecBtnX, tecBtnY, tecBtnW, btnH, btnRad);
  ui.fill((mode==TECMODE?255:0));
  ui.textFont(fButton); 
  ui.textAlign(CENTER, CENTER);
  ui.text("TEC", tecBtnX+tecBtnW/2, tecBtnY+btnH/2);
}

void tecModeKeyPressed() {
  if (keyleft) {
    if (!keyshift && !keyctrl && !keyalt && activeTecIndex != 0) switchActiveTECTextBox(-1);
  }
  if (keyright) {
    if (!keyshift && !keyctrl && !keyalt && activeTecIndex != 4) switchActiveTECTextBox(1);
  }
  if (keyshift && keyup) teensyPort.write(tecCmdPrefix[activeTecIndex]+""+(typeBuffer==""?"1":float(typeBuffer))+"\n\r");
  if (keyshift && keydown) teensyPort.write(tecCmdPrefix[activeTecIndex]+""+(typeBuffer==""?"-1":-float(typeBuffer))+"\n\r");

  if (key == '\n') {
    // send command
    if(activeTecIndex == 4) {
      teensyPort.write(typeBuffer+"\n\r");
      typeBuffer = "";
    }else{
      teensyPort.write(tecCmdPrefix[activeTecIndex] + typeBuffer +"\n\r");
    }
    
  }
  else if (keyCode == ALT || keyCode == CONTROL || keyCode == UP || keyCode == DOWN ||
    keyCode == LEFT || keyCode == RIGHT || keyCode == SHIFT) {
    /*Do nothing here*/
  } 
  else {
    if (keyCode == BACKSPACE || keyCode == DELETE) {
      if (typeBuffer.length()>0) {
        typeBuffer = typeBuffer.substring(0, typeBuffer.length()-1);
      }
    }
    else {
      typeBuffer = typeBuffer + key;
    }
  }
  if (activeTecIndex >=0) {
    tecCmdStr[activeTecIndex] = typeBuffer;
  }
}
void switchActiveTECTextBox(int amount) {
  tecFlags[activeTecIndex*2+1] = false;
  activeTecIndex += amount;
  typeBuffer = tecCmdStr[activeTecIndex];
  tecFlags[activeTecIndex*2+1] = true;
}

