#!/bin/bash

#SBATCH --partition=batch   # Partition name (batch, highmem_p, or gpu_p)
##SBATCH --gres=gpu:A100:1
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --cpus-per-task=1
#SBATCH --mem=128G
#SBATCH --time=2-00:00:00
#SBATCH --job-name=test_load_unload
#SBATCH --mail-user=jt35560@uga.edu   # Mair eves BOIN, END, FAIL, ALL)
#SBATCH --mail-type=ALL
#SBATCH --output=/home/jt35560/tmp/slurm_log/%j-%x-%N.out

source /home/jt35560/.bashrc
source /home/jt35560/.local/module/lmp.sh
conda activate py311 || exit
ml OpenMPI

cd /home/jt35560/codebase/prj3/batch_files

# Log file to keep track of completed jobs
LOGFILE="test_load_unload_log.txt"
# Check if log file exists, if not, create one
if [[ ! -f "$LOGFILE" ]]; then
    touch "$LOGFILE"
fi

# Output log for the jobs
OUTPUT_LOG="test_load_unload_log.txt"

if [[ ! -f "$OUTPUT_LOG" ]]; then
    touch "$OUTPUT_LOG"
fi

declare -a jobs=(
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 10"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 20"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 30"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 40"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 50"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.2/0.20_0.10_0.40_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.2/test75/0.20_0.10_0.40_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.4/0.10_0.10_0.60_5 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.4/test75/0.10_0.10_0.60_5 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.6/0.10_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.6/test75/0.10_0.20_0.20_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_0.8/0.50_0.20_0.20_7 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_0.8/test75/0.50_0.20_0.20_7 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressy_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressz -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx_relax -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 60"
"mpirun -np 64 tian_jie_lmp -i /home/jt35560/codebase/prj3/infile/in.compressx -var file /home/jt35560/codebase/prj3/spinodal_model_dat_1.0/0.50_0.20_0.20_10 -var ofile /scratch/jt35560/codebase/prj3/spinodal_model_dat_1.0/test75/0.50_0.20_0.20_10 -var comp 60"


# Function to check if a job is already done
is_job_done() {
    job_number=$1
    grep -q "Job $job_number: DONE" "$LOGFILE"
}

# Function to mark a job as done
mark_job_done() {
    job_number=$1
    echo "Job $job_number: DONE" >> "$LOGFILE"
}


# Start executing jobs
for i in "${!jobs[@]}"; do
    job_number=$((i + 1))
    job="${jobs[$i]}"

    if is_job_done $job_number; then
        echo "Job $job_number is already done. Skipping."
        continue
    fi

    # Run the job and log its output
    echo "Starting Job $job_number: $job"
    if eval "$job" >> "$OUTPUT_LOG" 2>&1; then
        echo "Job $job_number completed successfully."
        mark_job_done $job_number
    else
        echo "Job $job_number failed. Check $OUTPUT_LOG for details."
        exit 1
    fi
done

echo "All jobs completed."
Here, the lines:

bash
Copy code
# Check if log file exists, if not, create one
if [[ ! -f "$LOGFILE" ]]; then
    touch "$LOGFILE"
fi


# Check if log file exists, if not, create one
if [[ ! -f "$LOGFILE" ]]; then
    touch "$LOGFILE"
fi

# Start executing jobs
for i in "${!jobs[@]}"; do
    job_number=$((i + 1))
    job="${jobs[$i]}"

    if is_job_done $job_number; then
        echo "Job $job_number is already done. Skipping."
        continue
    fi

    # Run the job and log its output
    echo "Starting Job $job_number: $job"
    if eval "$job" >> "$OUTPUT_LOG" 2>&1; then
        echo "Job $job_number completed successfully."
        mark_job_done $job_number
    else
        echo "Job $job_number failed. Check $OUTPUT_LOG for details."
        exit 1
    fi
done

echo "All jobs completed."
