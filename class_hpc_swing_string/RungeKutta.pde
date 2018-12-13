

void rungeKutta4Advance(int num, 
                        float[] posx,
                        float[] posy,
                        float[] velx,
                        float[] vely,
                        float[] posx1,
                        float[] posy1,
                        float[] velx1,
                        float[] vely1,
                        float[] dposx,
                        float[] dposy,
                        float[] dvelx,
                        float[] dvely,
                        float factor)
{
  for (int j=0; j<num; j++) {
    posx[j] = posx1[j] + factor*dposx[j];
    posy[j] = posy1[j] + factor*dposy[j];
    velx[j] = velx1[j] + factor*dvelx[j];
    vely[j] = vely1[j] + factor*dvely[j];
  }
}




void rungeKutta4()
{
  final float ONE_SIXTH = 1.0/6.0;
  final float ONE_THIRD = 1.0/3.0;
  final int NB = BALLS_NUM;

  float[] posxprev = new float[NB];
  float[] posxwork = new float[NB];
  float[]   dposx1 = new float[NB];
  float[]   dposx2 = new float[NB];
  float[]   dposx3 = new float[NB];
  float[]   dposx4 = new float[NB];
  float[] posyprev = new float[NB];
  float[] posywork = new float[NB];
  float[]   dposy1 = new float[NB];
  float[]   dposy2 = new float[NB];
  float[]   dposy3 = new float[NB];
  float[]   dposy4 = new float[NB];
  float[] velxprev = new float[NB];
  float[] velxwork = new float[NB];
  float[]   dvelx1 = new float[NB];
  float[]   dvelx2 = new float[NB];
  float[]   dvelx3 = new float[NB];
  float[]   dvelx4 = new float[NB];
  float[] velyprev = new float[NB];
  float[] velywork = new float[NB];
  float[]   dvely1 = new float[NB];
  float[]   dvely2 = new float[NB];
  float[]   dvely3 = new float[NB];
  float[]   dvely4 = new float[NB];

  for (int j=0; j<NB; j++) {
    posxprev[j] = ballPosX[j];
    posyprev[j] = ballPosY[j];
    velxprev[j] = ballVelX[j];
    velyprev[j] = ballVelY[j];
  }

  //step 1 
  equationOfMotion(posxprev,
                   posyprev,
                   velxprev,
                   velyprev,
                     dposx1,
                     dposy1,
                     dvelx1,
                     dvely1,
                         dt);
  rungeKutta4Advance(NB,
                     posxwork,
                     posywork,
                     velxwork,
                     velywork,
                     posxprev,
                     posyprev,
                     velxprev,
                     velyprev,
                       dposx1,
                       dposy1,
                       dvelx1,
                       dvely1,
                          0.5);                        
  boundaryCondition(time, posxwork, posywork);

  time += 0.5*dt;

  //step 2
  equationOfMotion(posxwork,
                   posywork,
                   velxwork,
                   velywork,
                     dposx2,
                     dposy2,
                     dvelx2,
                     dvely2,
                         dt);
  rungeKutta4Advance(NB,
                     posxwork,
                     posywork,
                     velxwork,
                     velywork,
                     posxprev,
                     posyprev,
                     velxprev,
                     velyprev,
                       dposx2,
                       dposy2,
                       dvelx2,
                       dvely2,
                          0.5);
  boundaryCondition(time, posxwork, posywork);
                          
  //step 3
  equationOfMotion(posxwork,
                   posywork,
                   velxwork,
                   velywork,
                     dposx3,
                     dposy3,
                     dvelx3,
                     dvely3,
                         dt);
  rungeKutta4Advance(NB,
                     posxwork,
                     posywork,
                     velxwork,
                     velywork,
                     posxprev,
                     posyprev,
                     velxprev,
                     velyprev,
                       dposx3,
                       dposy3,
                       dvelx3,
                       dvely3,
                          1.0);
  boundaryCondition(time, posxwork, posywork);

  time += 0.5*dt;

  //step 4
  equationOfMotion(posxwork,
                   posywork,
                   velxwork,
                   velywork,
                     dposx4,
                     dposy4,
                     dvelx4,
                     dvely4,
                         dt);
  
  //the result
  for (int j=1; j<NB-1; j++) { 
    posxwork[j] = posxprev[j] + (
                           ONE_SIXTH*dposx1[j]
                         + ONE_THIRD*dposx2[j]
                         + ONE_THIRD*dposx3[j]
                         + ONE_SIXTH*dposx4[j] 
                         );
    posywork[j] = posyprev[j] + (
                           ONE_SIXTH*dposy1[j]
                         + ONE_THIRD*dposy2[j]
                         + ONE_THIRD*dposy3[j]
                         + ONE_SIXTH*dposy4[j] 
                         );
    velxwork[j] = velxprev[j] + (
                           ONE_SIXTH*dvelx1[j]
                         + ONE_THIRD*dvelx2[j]
                         + ONE_THIRD*dvelx3[j]
                         + ONE_SIXTH*dvelx4[j] 
                         );
    velywork[j] = velyprev[j] + (
                           ONE_SIXTH*dvely1[j]
                         + ONE_THIRD*dvely2[j]
                         + ONE_THIRD*dvely3[j]
                         + ONE_SIXTH*dvely4[j] 
                         );
  }
  
  boundaryCondition(time, posxwork, posywork);
  
  for (int j=0; j<NB; j++) {
    ballPosX[j] = posxwork[j];
    ballPosY[j] = posywork[j];
    ballVelX[j] = velxwork[j];
    ballVelY[j] = velywork[j];
  }

}
