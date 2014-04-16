void drawDataCollectionUI() {
  runButtonOverFlag = runButtonOver(runBtnX, runBtnY, runBtnW, btnH);
  if (readingDataSetFlag) {
    ui.fill(runBtnSetColor);
  }
  else {
    ui.fill(runBtnUnsetColor);
  }
  ui.stroke(0);
  ui.rect(runBtnX, runBtnY, runBtnW, btnH, btnRad);
  ui.textFont(fButton); 
  ui.textAlign(CENTER, CENTER); 
  ui.fill(0);
  if (readingDataSetFlag) {
    ui.text("Stop", runBtnX+runBtnW/2, runBtnY+btnH/2);
  }
  else {
    ui.text("Run", runBtnX+runBtnW/2, runBtnY+btnH/2);
  }


  ui.fill(255);
  ui.rect(txtBoxX, txtBoxY, txtBoxW, btnH);

  ui.fill(0);
  ui.textAlign(LEFT, CENTER);
  ui.textFont(f);
  ui.text(typeBuffer + (frameCount/10 % 2 == 0 ? "_" : ""), txtBoxX+1, txtBoxY+btnH/2);
}

void drawGraph() {
  adc0 = graphHeight - inData[dataIndex/2]*graphHeight/max16;
  trgt0 = graphHeight - inData[dataIndex-1]*graphHeight/max16;
  temp0 = graphHeight - inData[dataIndex-2]*graphHeight/max16;
  crnt0 = graphHeight - inData[dataIndex-3]*graphHeight/max16;
  out0 = graphHeight - inData[dataIndex-4]*graphHeight/max16;
  graph.beginDraw();
  graph.strokeWeight(1);
  graph.stroke(150, 200, 100);
  graph.line(graphPos, adc1, graphPos+1, adc0);
  graph.stroke(250, 100, 150);
  graph.line(graphPos, temp1, graphPos+1, temp0);
  graph.stroke(50, 100, 250);
  graph.line(graphPos, trgt1, graphPos+1, trgt0);
  graph.stroke(100, 100, 50);
  graph.line(graphPos, crnt1, graphPos+1, crnt0);
  graph.stroke(150, 100, 50);
  graph.line(graphPos, out1, graphPos+1, out0);
  graph.endDraw();
  image(graph, 0, uiHeight);
  println(dataIndex);
  out1 = out0;
  crnt1 = crnt0;
  temp1 = temp0;
  trgt1 = trgt0;
  adc1 = adc0;
  graphPos+=1;
  dataIndex = 0;
  teensyPort.write("update\n\r");
  if(graphPos > windowWidth){
    graph.clear();
    graph.background(250);
    graph.beginDraw();
    graph.endDraw();
    image(graph,0,uiHeight);
    graphPos = 0;
  }
}

