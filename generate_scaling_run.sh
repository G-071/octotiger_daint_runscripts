#!/bin/bash


# Directories
OCTOTIGER_BUILD_DIR="/scratch/snx3000/daissgr/build/octobuild"
OCTOTIGER_SOURCE_DIR="/scratch/snx3000/daissgr/octotiger"
DATA_DIR="/scratch/snx3000/daissgr/initfiles_14_revised"

#Config
HPX_ARGS="-Ihpx.stacks.use_guard_pages=0"
GPU_ARGS="--cuda_number_gpus=1 --cuda_streams_per_gpu=128 --cuda_buffer_capacity=4 --cuda_polling_executor=0"
FAB_ENABLE= #"-Ihpx.parcel.libfabric.enable=1 -Ihpx.parcel.bootstrap=libfabric -Ihpx.parcel.message_handlers=0"
TIME=00:30:00

echo ""
echo "INSTRUCTIONS:"
echo "- Replace OCTOTIGER_BUILD_DIR and HPX_ARGS in the script to suit your needs!"
echo "- Also please replace my email address before running jobs (see sbatch file generation in this script)"
echo "- Adapt TIME to expected scenario runtime (or edit resulting sbatch files manually"
echo ""
sleep 4 # Make people read this

echo "Using build in ${OCTOTIGER_BUILD_DIR} ..."
echo "Using inputfile in ${DATA_DIR} ..."
echo "Using HPX args: ${HPX_ARGS} ..."
echo "Using GPU args: ${GPU_ARGS} ..."
read -p "Enter desired name for run: " scaling_name
mkdir -p ${scaling_name}
cd ${scaling_name}
echo "!/bin/bash" > submit_all_jobs.sh
chmod u+x submit_all_jobs.sh

for LEVEL in 14 
do
    if [ "$LEVEL" == 14 ]; then
        read -p "Enter minimal number of nodes! Format 2^N1. N1 : " N1
        read -p "Enter maximal number of nodes! Format 2^N2. N2 : " N2
    fi

    for NPOWER in $(seq $N1 $N2)
    do
        NODES=$(( 2 ** $NPOWER))
        echo "Generating job for ${NODES} nodes..."

        # Setup the build
        mkdir -p level_${LEVEL}_${NODES}
        pushd level_${LEVEL}_${NODES}
        path=$(pwd)
        # Copy executable and octo-tiger scenario options
        cp ${OCTOTIGER_BUILD_DIR}/octotiger octotiger
        cp ${DATA_DIR}/v1309.ini .
        # Symlink dataset into job folder
        ln -s ${DATA_DIR}/${LEVEL}/splitted_X.0.silo X.0.silo.data
        ln -s ${DATA_DIR}/${LEVEL}/splitted_X.0.silo X.0.silo
        # Crate sbatch file
	cat << _EOF_ > submit-job.sl
#!/bin/bash -l
#SBATCH --output=slurm.out
#SBATCH --error=slurm.err
#SBATCH -N ${NODES}
#SBATCH --job-name=Octotiger_Level_${LEVEL}_${NODES}
#SBATCH --mail-type=ALL
#SBATCH --mail-user=Gregor.Daiss@ipvs.uni-stuttgart.de
#SBATCH --time=${TIME}
#SBATCH --partition=normal
#SBATCH --constraint=gpu

cd ${path}
source ../../daint-source-me.sh

srun -N ${NODES} -n ${NODES} ./octotiger ${HPX_ARGS} --config_file=v1309.ini --restart_filename=X.0.silo --max_level=${LEVEL} --stop_step=3 --legacy_hydro=0 ${GPU_ARGS} --disable_output=0 --disable_diagnostics=on
_EOF_
	chmod u+x submit-job.sl 
        # Push sbatch to a submit all script
        echo "pushd ${path}" >> ../submit_all_jobs.sh
        echo "sbatch submit-job.sl" >> ../submit_all_jobs.sh
        echo "popd" >> ../submit_all_jobs.sh
        echo "done!"
        popd
    done
done
