
void draw() {
  background(255);
  stroke(0, 0, 255);

  translate(width/2, height*ymax/(ymax-ymin));
  scale(1, -1);

  drawRope();
  drawHorizontalLine();


  for (int n=0; n<20; n++) { // to speed up the display
    rungeKutta4();
    step += 1;
    if ( step%10 == 0 ) {
      println("step=", step, " time=", time, " energy=", totalEnergy());
    }
  }
}



void drawHorizontalLine() {
  stroke(200,0,200);
  line(mapx(xmin), mapy(0), mapx(xmax), mapy(0));
}



void drawRope() {
  stroke(50, 100, 200);

  int nb = BALLS_NUM;

  for (int i=0; i<nb-1; i++) {
    float x0 = ballPosX[i];
    float y0 = ballPosY[i];
    float x1 = ballPosX[i+1];
    float y1 = ballPosY[i+1];
    line(mapx(x0), mapy(y0), mapx(x1), mapy(y1));
  }

  for (int i=0; i<nb; i++) {
    float x = ballPosX[i];
    float y = ballPosY[i];
    ellipse(mapx(x), mapy(y), 5, 5);
  }
}
