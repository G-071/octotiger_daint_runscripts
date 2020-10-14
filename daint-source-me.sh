
# defaults for GD
export SRC=/scratch/snx3000/daissgr/src
export BLD=/scratch/snx3000/daissgr/build
export INSTALL_ROOT=/scratch/snx3000/daissgr/apps/$GCC_version

# Versions
GCC_version=8.3.0
CMAKE_version=3.10.5
MPI_version=7.7.15
HWLOC_VER=2.0.4
JEMALLOC_VER=5.2.1
OTF2_VER=2.1.1
#BOOST_VER=1.74.0
#BOOST_SUFFIX=1_74_0
BOOST_VER=1.70.0
BOOST_SUFFIX=1_70_0
BOOST_ROOT=$INSTALL_ROOT/boost/$GCC_version/$BOOST_VER
PAPI_VER=5.5.1
VC_VER=1.4.1
HDF5_VER=1.8.12
SILO_VER=4.10.2
FFTW_VER=3.3.8

# Modules
module unload PrgEnv-cray
module load   PrgEnv-gnu
#
module unload gcc
module load   gcc/$GCC_version
module unload cray-libsci
module unload cray-mpich
module load   cray-mpich/$MPI_version
module load   daint-gpu
module load   CMake
module load   cudatoolkit

# Optional MKL, Vampir, Papi, etc
# module load intel
# module load  papi

# Make sure compiler is detected well
export CC=/opt/cray/pe/craype/default/bin/cc
export CXX=/opt/cray/pe/craype/default/bin/CC

# flags we want CMake and configure to pick up
export CFLAGS=-fPIC
export CXXFLAGS="-fPIC -march=native -mtune=native -ffast-math -std=c++14"
export LDFLAGS="-ldl"
export LDCXXFLAGS="$LDFLAGS -std=c++14 -latomic"

# Apex output
export APEX_OTF2=1
export APEX_PROFILE=1
export APEX_SCREEN_OUTPUT=1

# Aliases
alias cds='cd $SCRATCH'
alias cdc='cd $SRC'
alias cdb='cd $BLD'
