#!/bin/bash
#SBATCH --partition=batch   # Partition name (batch, highmem_p, or gpu_p)
##SBATCH --gres=gpu:A100:1
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --cpus-per-task=1
#SBATCH --mem=128G
#SBATCH --time=2-00:00:00
#SBATCH --job-name={job_name}
#SBATCH --mail-user=jt35560@uga.edu   # Mair eves BOIN, END, FAIL, ALL)
#SBATCH --mail-type=ALL
#SBATCH --output=/home/jt35560/tmp/slurm_log/%j-%x-%N.out

# Log file to keep track of completed jobs
LOGFILE="job_log.txt"

# Output log for the jobs
OUTPUT_LOG="output_log.txt"

# List of jobs. These are just example commands; replace them with your actual jobs.
declare -a jobs=("sleep 1" "echo 'Job 2'" "sleep 2" "echo 'Job 4'")

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

