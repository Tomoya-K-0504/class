#include<stdio.h>
#include<stdlib.h>
#include<omp.h>
#include<mpi.h>

#define NX 2400
#define NLOOP 100000
#define NINTERVAL 1000

int main(int argc, char **argv) {
  int n, i, istart, iend;
  double *u, *un, *u_global, *u_output;
  double lx = 1.0, h, hsq;
  double t0, t1;
  int nprocs, myrank, left, right, src;
  int midp = NX / 2;
  int tag = 100;
  int count;
  MPI_Status istat;
  FILE *file;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
  MPI_Comm_rank(MPI_COMM_WORLD, &myrank);

  // 0. Define h & hsq
  h = lx/NX;
  hsq = h*h;

  // 1. Define subdomain (calc. istart & iend)
  int np = NX / nprocs;
  if (myrank == 0) {
    istart = 1;
  } else {
    istart = myrank * np;
  }
  iend = (myrank + 1) * np - 1;

  // 2. Memory allocation (define sizes and ranges of u & un)
  u  = (double*)malloc((iend-istart+3)*sizeof(double)) - (istart - 1);
  un = (double*)malloc((iend-istart+1)*sizeof(double)) - istart;

  // 3. Initializing u (zero-clear u)
  for (i = istart; i <= iend; i++){
    u[i] = 0.0;
    un[i] = 0.0;
  } 

  // 4. Set rank of left & right domains
  left = (myrank > 0) ? (myrank - 1) : MPI_PROC_NULL;
  right = (myrank < nprocs - 1) ? (myrank + 1) : MPI_PROC_NULL;

  MPI_Barrier(MPI_COMM_WORLD);
  t0 = MPI_Wtime();
  // 5. Mainloop
  for(n = 1; n <= NLOOP; n++) { // Time iteration
    for(i = istart; i <= iend; i++) { // Grid scan
      un[i] = (u[i+1] + u[i-1]) * 0.5 + hsq;
    }

    // Copy un back to u
    u = un; 

    // Boundary communication (Sendrecv*2)
    // 1. get istart - 1 from prev proc and send istart to prev proc
    MPI_Sendrecv( &u[iend] , 1, MPI_DOUBLE, right, 420, 
                  &u[istart-1], 1, MPI_DOUBLE, left, 420, 
                  MPI_COMM_WORLD, &istat );
    MPI_Sendrecv( &u[istart], 1, MPI_DOUBLE, left, 125,
                  &u[iend+1], 1, MPI_DOUBLE, right, 125,
                  MPI_COMM_WORLD, &istat ); 

    // Diagnostics (print T@midpoint)
    if(n%NINTERVAL == 0 && istart <= midp && midp <= iend) {
      printf("Step: %d, T@midpoint = %lf, Diff = %lf\n", n, u[midp], fabs(u[midp]-lx/4.0));
    }
  }
  // End of mainloop
  MPI_Barrier(MPI_COMM_WORLD);
  t1 = MPI_Wtime();
  if(myrank == 0) printf("...done\nElapsed time: %lf\n", t1 - t0);

  // 6a. Output final T-profile
  if(myrank == 0) {
    // Output simulation result (to Tsim1d.dat)
    file = fopen("Tsim1d.dat", "w");
    for(i = 0; i <= iend; i++) {
	    fprintf(file, "%-6d %lf %.16E\n", i, i*h, u[i]);
    }
    for(src = 1; src < nprocs; src++) {
      count = (src < nprocs - 1) ? NX/nprocs : NX/nprocs + 1;
      MPI_Recv(&u[0], count, MPI_DOUBLE, src, tag, MPI_COMM_WORLD, &istat);
      for(i = 0; i < count; i++) {
        fprintf(file, "%-6d %lf %.16E\n", i, ((NX-1)*src/nprocs+1 + i)*h, u[i]);
      }
    }
    fclose(file);
    // Output analytical (steady-state) values (to Tthe1d.dat)
    file = fopen("Tthe1d.dat", "w");
    for(i = 0; i <= NX; i++) {
      fprintf(file, "%-6d %lf %.16E\n", i, i*h, -(i*h)*(i*h - lx));
    }
    fclose(file);
  } else {
    count = (myrank < nprocs - 1) ? NX/nprocs : NX/nprocs + 1;
    MPI_Send(&u[istart], count, MPI_DOUBLE, 0, tag, MPI_COMM_WORLD);
  }

  // 6b. Output final T-profile (alternative way)
  /*
  u_global = (double*)malloc((NX+1)*sizeof(double));
  u_output = (double*)malloc((NX+1)*sizeof(double));
  for(i = 0; i <= NX; i++) u_global[i] = 0.0;
  for(i = istart; i <= iend; i++) u_global[i] = u[i];
  MPI_Reduce(&u_global[0], &u_output[0], NX+1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
  if(myrank == 0) {
    // Output simulation result (to Tsim1d.dat)
    file = fopen("Tsim1d.dat", "w");
    for(i = 0; i <= NX; i++) {
      fprintf(file, "%-6d %lf %.16E\n", i, i*h, u_output[i]);
    }
    fclose(file);
    // Output analytical (steady-state) values (to Tthe1d.dat)
    file = fopen("Tthe1d.dat", "w");
    for(i = 0; i <= NX; i++) {
      fprintf(file, "%-6d %lf %.16E\n", i, i*h, -(i*h)*(i*h - lx));
    }
    fclose(file);
  }
  free(u_global);
  free(u_output);
  */

  // 7. Deallocate memory
  //free(&u[istart-1]);
  //free(&un[istart]);

  MPI_Finalize();

  return 0;

}
