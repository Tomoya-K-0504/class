
float totalEnergy()
{
  
  float kineticEnergy = 0.0;
  float potentialEnergy = 0.0;
  
  for (int i=0; i<BALLS_NUM; i++) {
    float posx = ballPosX[i];
    float posy = ballPosY[i];
    float velx = ballVelX[i];
    float vely = ballVelY[i];
  
    kineticEnergy += 0.5*BALLS_MASS*(velx*velx+vely*vely);
    
    if ( i>0 ) {
      float posx0 = ballPosX[i-1];
      float posy0 = ballPosY[i-1];
      float l = dist(posx,posy,posx0,posy0) - SPRING_NATURAL_LENGTH;
      float lsq = l*l;
      potentialEnergy += 0.5*SPRING_CONST*lsq; 
    }
    potentialEnergy += BALLS_MASS*GRAVITY_ACCELERATION*posy;
  }

  return(kineticEnergy + potentialEnergy);
}
