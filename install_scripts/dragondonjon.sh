 
# #############################################################################
# Install Dragon Donjon
#
# call this script as
# source Dragon Dopnjon.sh v5.0
#        dragondonjon.sh package-version 
# #############################################################################


export PKG_NAME=dragondonjon-v5.0.2
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
echo " --------- Start dragondonjon.sh script -------- "
echo
export SCRIPT_NAME=dragondonjon
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
if [ ! -d "$INSTALL_DIR/dragondonjon" ]; then
  mkdir $INSTALL_DIR/dragondonjon
  echo "Dragon Donjon does not exist: extraction tar"
  tar -xzf version5_v5.0.2.tgz -C $INSTALL_DIR/dragondonjon/ --strip-components 1
  mkdir $INSTALL_DIR/dragondonjon/install_logs
  echo $SCRIPT_NAME ": 1c  Dragon Donjon extract and in place" 
else
  echo " Dragon Donjon dir exists: no extraction tar"
fi
echo

# 2) Install OpenMPI script  ==================================================
# openfoam is buid in its own directory
OFBUILD_DIR=$INSTALL_DIR/dragondonjon
cd $OFBUILD_DIR    
echo $SCRIPT_NAME " 2a: build in " $PWD

# ..................................................................
#!/bin/bash 
# ..................................................................=
echo ".................................................................."
echo "STARTING UTILIB"
cd ./Utilib/
../script/install >../install_logs/utilib
grep "Install  : ERROR" ../install_logs/utilib
if [  "$?" -eq "0" ]; then
echo -e "${red}ERROR! Finalizing UTILIB installation see ../install_logs/utilib"
cd ..
#exit 1
fi
kill $!; trap 'kill $!' SIGTERM
echo "\n"
echo "DONE UTILIB"
echo ".................................................................."
echo "STARTING GANLIB"
cd ../Ganlib/
../script/install >../install_logs/ganlib
grep "Install  : ERROR" ../install_logs/ganlib
if [  "$?" -eq "0" ]; then
echo -e "${red}ERROR! Finalizing UTILIB installation see ../install_logs/ganlib"
cd ..
#exit 1
fi
echo "DONE GANLIB"
echo ".................................................................."
echo "STARTING TRIVAC"
cd ../Trivac/
../script/install >../install_logs/trivac
grep "Install  : ERROR" ../install_logs/trivac
if [  "$?" -eq "0" ]; then
echo -e "${red}ERROR! Finalizing UTILIB installation see ../install_logs/trivac"
cd ..
#exit 1
fi
echo "DONE TRIVAC"
echo ".................................................................."
echo "STARTING DRAGON"
cd ../Dragon/
../script/install >../install_logs/dragon
grep "Install  : ERROR" ../install_logs/dragon
if [  "$?" -eq "0" ]; then
echo -e "${red}ERROR! Finalizing DRAGON installation see ../install_logs/dragon"
cd ..
#exit 1
fi
echo "DONE DRAGON"
echo ".................................................................."
echo "STARTING DONJON"
cd ../Donjon/
../script/install>../install_logs/donjon
grep "Install  : ERROR" ../install_logs/donjon
if [  "$?" -eq "0" ]; then
echo -e "${red}ERROR! Finalizing DONJON installation see ../install_logs/donjon"
cd ..
#exit 1
fi
echo "DONE DONJON"
echo ".................................................................."
echo "STARTING SKINN++"
export BOOST_ROOT=/usr/
cd ../Skin++/
../script/install>../install_logs/skinn
grep "Install  : ERROR" ../install_logs/skinn
if [  "$?" -eq "0" ]; then
echo -e "${red}ERROR! Finalizing SKINN++ installation see ../install_logs/skinn"
cd ..
#exit 1
fi
echo "DONE SKINN++"
echo ".................................................................."
cd ..
echo ".................................................................."
echo "pathcing file ./Ganlib/src/cle2000.h max min issues"
echo ".................................................................."
patch  ./Ganlib/src/cle2000.h $BUILD_DIR/patches/clee2000.patch
echo ".................................................................."
# cd ..
# ln -s ./Version5_beta_ev3 ./Version5
echo "DONE"
echo ".................................................................."























# source install.sh

# export FOAM_INST_DIR=$OFBUILD_DIR
# foamDotFile=$FOAM_INST_DIR/$PKG_NAME/etc/bashrc
# [ -f $foamDotFile ] && . $foamDotFile
# 
# echo $SCRIPT_NAME " 2a: setting envronment bashrc "
# source $FOAM_INST_DIR/$PKG_NAME/etc/bashrc
# 
# echo $SCRIPT_NAME " 2a: foamSystemCheck "
# foamSystemCheck > $INSTALL_DIR/$MY_PREFIX_DIR/package_logs/openfoam.config
# echo $SCRIPT_NAME " 2a :foam "
# foam
# 
# echo $SCRIPT_NAME " 2b : Allwmake "
# ./Allwmake > $INSTALL_DIR/$MY_PREFIX_DIR/package_logs/openfoam.make
 
# ..................................................................=================
# 3 post install ..................................................................==
# ..................................................................=================
 
# echo $SCRIPT_NAME "3 a  Validate the build by running"
# foamInstallationTest
# echo $SCRIPT_NAME "3 a  Create the user run directory:"
# mkdir -p $FOAM_RUN
#  
# echo $SCRIPT_NAME " in order to run set the environment with" 
# echo "source" $FOAM_INST_DIR/$PKG_NAME/etc/bashrc
 
cd $BUILD_DIR
