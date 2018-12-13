

void boundaryCondition(float t, float[] x, float y[]) 
{
  x[0] = footPointLeftX;   // x-coord if particle No.0.
  y[0] = 0.0;              // y-coord if particle No.0.
  x[BALLS_NUM-1] = footPointRightX;  // x-coord if the last particle.
  y[BALLS_NUM-1] = 0.0;              // y-coord if the last particle.
  float swingAmp = SPRING_NATURAL_LENGTH*0.5;
  float swingOmega = 0.001*SPRING_CHAR_OMEGA;
  x[0]           = footPointLeftX + swingAmp*sin(swingOmega*t);
  x[BALLS_NUM-1] = footPointRightX - swingAmp*sin(swingOmega*t);
}
