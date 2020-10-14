### octotiger_daint_runscripts

Notes:
- If you use your own build, make sure to adapt the daint-source-me.sh and the OCTOTIGER_BUILD_DIR in the generate_scaling.sh script
- Also, please change the email address for the slurm jobs

To generate the sbatch files and run directories:
- ./generate_scaling.sh
- Enter the desired name (for example "test_run1" of the run folder and the node counts!
- Verify that all auto-generated submit-job.sl files are as desired!

To run
- cd test_run1
- ./submit_all_jobs.sh

After the jobs are done:
- ./get_results.sh
- Enter name of run (for example test_run1 again)
- See results.csv
