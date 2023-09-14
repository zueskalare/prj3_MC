#!/bin/bash

#SBATCH --partition=batch   # Partition name (batch, highmem_p, or gpu_p)
##SBATCH --gres=gpu:A100:1
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=2
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --job-name=build_model
#SBATCH --mail-user=jt35560@uga.edu   # Mair eves BOIN, END, FAIL, ALL)
#SBATCH --mail-type=ALL
#SBATCH --output=/home/jt35560/tmp/slurm_log/%j-%x-%N.out

cd /home/jt35560/codebase/prj3/prj3/code/MC_model/python

source /home/jt35560/.bashrc
conda activate py311 || exit
ml OpenMPI

mpirun -np 16   python3.11 -i ./batch_BuildStl.py

#mpirun -np 16 python -i test_mpi.py

