#!/bin/bash
#PBS -N jobname
#PBS -q uv-large
#PBS -l select=1:ncpus=8:mpiprocs=8
#PBS -l walltime=00:02:00

cd ${PBS_O_WORKDIR}

export KMP_AFFINITY=disabled

for opn in 1
do
  export OMP_NUM_THREADS=$opn
  mpiexec_mpt -np 8 omplace -nt ${OMP_NUM_THREADS} ./a.out
done
