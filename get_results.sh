#!/bin/bash
read -p "Enter run directory: " run_dir
pushd ${run_dir}
find . -name "slurm.out" | sed 's/.*level_//g' | sed 's/_.*//g' > levels.txt
find . -name "slurm.out" | sed 's/.*level_...//g' | sed 's/\/slurm.out//g' > nodes.txt
find . -name "slurm.out" -exec cat {} + | grep "Computation:" | sed 's/.*: //g' | sed 's/\s.*//g' > computation_time.txt
find . -name "slurm.out" -exec cat {} + | grep "Total:" | sed 's/.*: //g' > total_time.txt
paste levels.txt nodes.txt total_time.txt computation_time.txt | column -N level,nodes,total_time,computation_time -o , -t  >> results.csv
cat results.csv
popd
