void initDirectBoxArrays() {
  translationBoxLocation = new int[3];
  translationBoxLocation[0] = runBtnX+runBtnW+2;
  for (int i=0; i<translationBoxLocation.length; i++) {
    translationBoxLocation[i] = i==0? translationBoxLocation[i] : 70+translationBoxLocation[i-1] + 2;
  }
  translationFlags = new boolean[12];
  translationFlags[1] = true;
}
void drawDirectModeBlocks() {
  for (int i = 0; i < 6; i++) {
    translationFlags[i*2] = DrawCommandButton(translationBtnStr[i], translationFlags[i*2+1], translationBoxLocation[i%3], i<3?2:4+btnH, i<3?70:55);
  }
}
void drawDirectModeChooser() {
  directModeHover = runButtonOver(directBtnX, directBtnY, directBtnW, btnH);
  ui.fill(directModeHover? 100:(mode==DIRECTMODE? 0:255));
  ui.stroke(0);
  ui.rect(directBtnX, directBtnY, directBtnW, btnH, btnRad);
  ui.fill((mode==DIRECTMODE?255:0));
  ui.textFont(fButton); 
  ui.textAlign(CENTER, CENTER);
  ui.text("Motor", directBtnX+directBtnW/2, directBtnY+btnH/2);
}

void directModeMousePressed() {
  for (int i=0; i<translationFlags.length; i+=2) {
    if (translationFlags[i]) {
      translationFlags[activeButtonIndex*2+1] = false;
      translationFlags[i+1] = true;
      activeButtonIndex = i/2;
    }
  }
}

void directModeKeyPressed() {
  if (keyleft) {
    if (!keyshift && !keyctrl && !keyalt && activeButtonIndex != 0 && activeButtonIndex != 3 ) switchActiveTranslationTextBox(-1);
    if (keyshift && !keyctrl ) {
      if (translationCmdPrefix[activeButtonIndex] <=90) teensyPort.write("X"+(typeBuffer==""?"-1":-Integer.parseInt(typeBuffer))+"\n\r");
      if (translationCmdPrefix[activeButtonIndex] >=120) teensyPort.write("x"+(typeBuffer==""?"-1":-Integer.parseInt(typeBuffer))+"\n\r");
    }
  }
  if (keyright) {
    if (!keyshift && !keyctrl && !keyalt && activeButtonIndex != 2 && activeButtonIndex != 5 ) switchActiveTranslationTextBox(1);
    if (keyshift && !keyctrl ) {
      if (translationCmdPrefix[activeButtonIndex] <=90) teensyPort.write("X"+(typeBuffer==""?"1":Integer.parseInt(typeBuffer))+"\n\r");
      if (translationCmdPrefix[activeButtonIndex] >=120) teensyPort.write("x"+(typeBuffer==""?"1":Integer.parseInt(typeBuffer))+"\n\r");
    }
  }
  if (keyup) {
    if (!keyshift && !keyctrl && !keyalt && activeButtonIndex > 2) switchActiveTranslationTextBox(-3);
    if (keyshift && !keyctrl ) {
      if (translationCmdPrefix[activeButtonIndex] <=90) teensyPort.write("Y"+(typeBuffer==""?"1":Integer.parseInt(typeBuffer))+"\n\r");
      if (translationCmdPrefix[activeButtonIndex] >=120) teensyPort.write("y"+(typeBuffer==""?"1":Integer.parseInt(typeBuffer))+"\n\r");
    }
    if (keyshift && keyctrl ) {
      if (translationCmdPrefix[activeButtonIndex] <=90) teensyPort.write("Z"+(typeBuffer==""?"1":Integer.parseInt(typeBuffer))+"\n\r");
      if (translationCmdPrefix[activeButtonIndex] >=120) teensyPort.write("z"+(typeBuffer==""?"1":Integer.parseInt(typeBuffer))+"\n\r");
    }
  }
  if (keydown) {
    if (!keyshift && !keyctrl && !keyalt && activeButtonIndex <= 2 ) switchActiveTranslationTextBox(3);
    if (keyshift && !keyctrl ) {
      if (translationCmdPrefix[activeButtonIndex] <=90) teensyPort.write("Y"+(typeBuffer==""?"-1":-Integer.parseInt(typeBuffer))+"\n\r");
      if (translationCmdPrefix[activeButtonIndex] >=120) teensyPort.write("y"+(typeBuffer==""?"-1":-Integer.parseInt(typeBuffer))+"\n\r");
    }
    if (keyshift && keyctrl ) {
      if (translationCmdPrefix[activeButtonIndex] <=90) teensyPort.write("Z"+(typeBuffer==""?"-1":-Integer.parseInt(typeBuffer))+"\n\r");
      if (translationCmdPrefix[activeButtonIndex] >=120) teensyPort.write("z"+(typeBuffer==""?"-1":-Integer.parseInt(typeBuffer))+"\n\r");
    }
  }
  if (key == '\n') {
    // send command
    typeBuffer += "\n\r";
    if (!readingDataSetFlag || activeButtonIndex >2) {
      typeBuffer = translationCmdPrefix[activeButtonIndex] + typeBuffer;
      teensyPort.write(typeBuffer);
    }
    typeBuffer = "";
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
  if (activeButtonIndex >=0) {
    translationCmdStr[activeButtonIndex] = typeBuffer;
  }
}
void switchActiveTranslationTextBox(int amount) {
  translationFlags[activeButtonIndex*2+1] = false;
  activeButtonIndex += amount;
  typeBuffer = translationCmdStr[activeButtonIndex];
  translationFlags[activeButtonIndex*2+1] = true;
}

