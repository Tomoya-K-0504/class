/*
  class_hpc_swing_string.pde

 */


final float ROPE_MASS = 0.005;
final float ROPE_LENGTH = 2.0;
final int BALLS_NUM = 20;
//
//         when BALLS_NUM = 6
//         ......o............o........
//              0 \          / 5
//                 o        o
//                1 \      / 4
//                   o----o
//                  2      3 
//
final float BALLS_MASS = ROPE_MASS / (BALLS_NUM-2);

final float SPRING_NATURAL_LENGTH = ROPE_LENGTH / (BALLS_NUM-1);
final float SPRING_CHAR_PERIOD = 0.01; // second
final float SPRING_CHAR_OMEGA = PI*2 / SPRING_CHAR_PERIOD;
final float SPRING_CHAR_OMEGA_SQ = SPRING_CHAR_OMEGA*SPRING_CHAR_OMEGA;
      // omega^2 = k/m
final float SPRING_CONST = BALLS_MASS * SPRING_CHAR_OMEGA_SQ; 

final float GRAVITY_ACCELERATION = 9.80665;  

float[] ballPosX = new float[BALLS_NUM];
float[] ballPosY = new float[BALLS_NUM];
float[] ballVelX = new float[BALLS_NUM];
float[] ballVelY = new float[BALLS_NUM];


//
//          LeftX              RightX
//             |                  |
//             |<---separation--->|
//             |         |        |
//       ......o..................o........
//            0 \        |       / BALLS_NUM-1
//               o      x=0     o
//              1 \            / BALLS_NUM-2
//   
float footPointSeparation = ROPE_LENGTH * 0.5;
float footPointRightX = footPointSeparation/2;
float footPointLeftX = -footPointRightX;

float xmin = -1.0;
float xmax =  1.0;
float ymin = -1.5;
float ymax =  0.5;


float time = 0.0;
int step = 0;
float dt = SPRING_CHAR_PERIOD*0.05;



void initialize()
{


//
//           angle
//           theta
//              \
//               \  |
//              \ \_|     separation/2
//               \/ |    /
//                \ |<------>|
//                 \|        |
//            ......o........+........o........
//                  |\               /    
//   natural length | o <--1        o <--NB-2
//              l0.....\           / 
//                  |   o         .            
//                  |    .       .               
//                  |     \     /
//            (NB-2)/2 --> o---o <--(NB-2)/2+1
//
//     (((NB-2)/2)*l0*sin(theta)+0.5*l0) \sim separation/2
//   or
//      sin(theta) \sim ((separation/2)-0.5*l0) / ((NB-2)/2)*l0
//   

  int nb = BALLS_NUM;
  float l0 = SPRING_NATURAL_LENGTH;
  float sinTheta = (footPointSeparation/2-0.5*l0) / ((nb-2)/2*l0);
  float cosTheta = sqrt(1-sinTheta*sinTheta);

  int i;

  i=0;
  ballPosX[i] = footPointLeftX; // x coord
  ballPosY[i] = 0.0; // y coord
  ballVelX[i] = 0.0; // vx
  ballVelY[i] = 0.0; // vy

  for (i=1; i<=(nb-2)/2; i++) {
    ballPosX[i] = ballPosX[i-1] + l0*sinTheta; // x
    ballPosY[i] = ballPosY[i-1] - l0*cosTheta; // y
    ballVelX[i] = 0.0; // vx
    ballVelY[i] = 0.0; // vy
  }

  i = nb-1;
  ballPosX[i] = footPointRightX;
  ballPosY[i] = 0.0;
  ballVelX[i] = 0.0;
  ballVelY[i] = 0.0;

  for (i=(nb-2); i>=(nb-2)/2+1; i--) {
    ballPosX[i] = ballPosX[i+1] - l0*sinTheta; // x
    ballPosY[i] = ballPosY[i+1] - l0*cosTheta; // y
    ballVelX[i] = 0.0; // vx
    ballVelY[i] = 0.0; // vy
  }
}


void setup() {
  size(500, 500);
  background(255);
  initialize();
  frameRate(60);
}



float mapx(float x) {
  // (x,y) = physical unit coords. 
  // (map(x),map(y)) = pixel coords.
  float scale = width/(xmax-xmin);
  return map(x, xmin, xmax, scale*xmin, scale*xmax);
}


float mapy(float y) {
  // (x,y) = physical unit coords. 
  // (map(x),map(y)) = pixel coords.
  float scale = height/(ymax-ymin);
  return map(y, ymin, ymax, scale*ymin, scale*ymax);
}
