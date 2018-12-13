
void equationOfMotion(float  posx[],
                      float  posy[],
                      float  velx[],
                      float  vely[],
                      float dposx[],
                      float dposy[],
                      float dvelx[],
                      float dvely[],
                      float dt) 

{
  final float l0 = SPRING_NATURAL_LENGTH;
  final int NB = BALLS_NUM;

//    
//   when BALLS_NUM = 6
//   ......o............o........
//        0 \          / 5
//           o        o
//          1 \      / 4
//             o----o
//            2      3
//   

  for (int i=1; i<=NB-2; i++) {  // See boundaryCondition() for i=0 & NB-1.   
    // 
    //     (x0,y0)          (x1,y1)
    //         i-1           i
    //          o------------o
    //         /            / \  ____dist12
    //        /<--dist01-->/   \/
    //                          \ 
    //                           o i+1
    //                         (x2,y2)
    //
    //    force_amp = k*(spring_length - l0)
    //
    float dtm = dt / BALLS_MASS;
    
    float x0 = posx[i-1];
    float x1 = posx[i  ];
    float x2 = posx[i+1];
    float y0 = posy[i-1];
    float y1 = posy[i  ];
    float y2 = posy[i+1];
    float dist01 = dist(x0,y0,x1,y1);
    float dist12 = dist(x1,y1,x2,y2);

    float s_forceAmp01 = SPRING_CONST*(dist01-l0);
    float s_forceAmp12 = SPRING_CONST*(dist12-l0);
    
    float unitVec01x = (x1-x0)/dist01;
    float unitVec01y = (y1-y0)/dist01;
    float unitVec12x = (x2-x1)/dist12;
    float unitVec12y = (y2-y1)/dist12;
    float s_force01x = s_forceAmp01*unitVec01x;
    float s_force01y = s_forceAmp01*unitVec01y;
    float s_force12x = s_forceAmp12*unitVec12x;
    float s_force12y = s_forceAmp12*unitVec12y;
    float  g_force_y = - BALLS_MASS*GRAVITY_ACCELERATION;
    //float frictionCoeff = 0.0001;
    //float v_force_x = -frictionCoeff*velx[i];
    //float v_force_y = -frictionCoeff*vely[i];
    
    float force_x = s_force12x - s_force01x;
    float force_y = s_force12y - s_force01y + g_force_y;

    dposx[i] = velx[i] * dt;  // dx = vx * dt
    dposy[i] = vely[i] * dt;  // dy = vy * dt
    dvelx[i] = force_x * dtm; // dvx = (fx/m)*dt 
    dvely[i] = force_y * dtm; // dvy = (fy/m- g)*dt
  }
}
