 
# #############################################################################
# Install OPENFAOM
#
# call this script as
# source openfoam.sh v3.0+
#        opnefoam.sh package-version 
# #############################################################################


export PKG_NAME=OpenFOAM-v3.0+
export MY_PREFIX_DIR=plat_base_packs

# -----------------------------------------------------------------------------
# This file script should be placed in the directory ../femus_installation
# -----------------------------------------------------------------------------
# Install base packs dir=INSTALL_DIR= up dir packages=../femus_installation
# Package name PKG_NAME=libmesh-0.9.5
# MPI  = $INSTALL_DIR/openmpi
# PETSC= $INSTALL_DIR/petsc
# build dir=BUILD_DIR=$INSTALL_DIR/femus_installation
# PETSC installation dir=$INSTALL_DIR/$MY_PREFIX_DIR/libmesh-0.9.5 
#                        ->$INSTALL_DIR/libmesh
# logs in $INSTALL_DIR/$MY_PREFIX_DIR/package_logs 
# -----------------------------------------------------------------------------

echo 
echo " --------- Start openfoam.sh script -------- "
echo
export SCRIPT_NAME=OpenFOAM
echo $SCRIPT_NAME ": Script set up for "  $SCRIPT_NAME 
echo


# 1) ==================  setup ================================================
echo $SCRIPT_NAME  ": 1 -> 1a.build dir-> 1b.log dir -> 1c.femus_install dir"

# 1a --------------- platform setup -------------------------------------------
export BUILD_DIR=$PWD
echo $SCRIPT_NAME ": 1a set up: BUILD dir (BUILD_DIR) is                   = " $BUILD_DIR
cd ../
#  down to platform dir 
export INSTALL_DIR=$PWD
echo $SCRIPT_NAME ": 1a set up: INSTALLATION platform DIR (INSTALL_DIR) is = " $INSTALL_DIR

# 1b log directory -------------------------------------------------------------
echo $SCRIPT_NAME ": 1b set up: make directories" 
mkdir ./$MY_PREFIX_DIR
mkdir ./$MY_PREFIX_DIR/package_logs
if [ "$?" != "0" ]; then
  echo -e $SCRIPT_NAME ": 1b packagelogs and plat_base_packs already exist. Overwriting "
fi



# 1c up to BUILD dir ----------------------------------------------------------
echo $SCRIPT_NAME ": 1c set up: LOG dir ({BUILD_DIR}/MYLOG_DIR_NAME) is    = " $INSTALL_DIR/$MY_PREFIX_DIR/package_logs
cd $BUILD_DIR
if [ ! -d "$INSTALL_DIR/OpenFOAM" ]; then
  echo "Openfoam does not exist: extraction tar"
  mkdir $INSTALL_DIR/OpenFOAM 
  tar -xzf OpenFOAM-v3.0+.tgz -C $INSTALL_DIR/OpenFOAM 
  tar -xzf ThirdParty-v3.0+.tgz -C $INSTALL_DIR/OpenFOAM
  echo $SCRIPT_NAME ": 1c  openfoam extract and in place" 
else
  echo "Openfoam dir exists: no extraction tar"
fi


# 1d openmpi setup (OPENMPI in  $INSTALL_DIR/openmpi) -----------
echo $SCRIPT_NAME " 1d MPI dependency: OPENMPI_DIR="  $INSTALL_DIR/openmpi/ 
# Add to the path the openmpi executables and libraries in order to compile petsc
export PATH=$INSTALL_DIR/openmpi/bin/:$PATH
export LD_LIBRARY_PATH=$INSTALL_DIR/openmpi/lib64/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$INSTALL_DIR/openmpi/lib/:$LD_LIBRARY_PATH
echo $SCRIPT_NAME " 1d MPI dependency: PATH="$INSTALL_DIR/"openmpi/bin/"
echo $SCRIPT_NAME " 1d MPI dependency: LD_LIBRARY_PATH="$INSTALL_DIR/"openmpi/lib/"
echo

# 2) Install OpenMPI script  ==================================================

# openfoam is buid in its own directory
OFBUILD_DIR=$INSTALL_DIR/OpenFOAM
cd $OFBUILD_DIR    
echo $SCRIPT_NAME " 2a: build in " $PWD
export FOAM_INST_DIR=$OFBUILD_DIR
foamDotFile=$FOAM_INST_DIR/$PKG_NAME/etc/bashrc
[ -f $foamDotFile ] && . $foamDotFile

echo $SCRIPT_NAME " 2a: setting envronment bashrc "
source $FOAM_INST_DIR/$PKG_NAME/etc/bashrc

echo $SCRIPT_NAME " 2a: foamSystemCheck "
foamSystemCheck > $INSTALL_DIR/$MY_PREFIX_DIR/package_logs/openfoam.config
echo $SCRIPT_NAME " 2a :foam "
foam

echo $SCRIPT_NAME " 2b : Allwmake "
./Allwmake > $INSTALL_DIR/$MY_PREFIX_DIR/package_logs/openfoam.make
 
# =============================================================================
# 3 post install ==============================================================
# =============================================================================
 
echo $SCRIPT_NAME "3 a  Validate the build by running"
foamInstallationTest
echo $SCRIPT_NAME "3 a  Create the user run directory:"
mkdir -p $FOAM_RUN
 
echo $SCRIPT_NAME " in order to run set the environment with" 
# echo "source" $FOAM_INST_DIR/$PKG_NAME/etc/bashrc
 
cd $BUILD_DIR
