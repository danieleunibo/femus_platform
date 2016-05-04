# #############################################################################
# Install Petsc dbg with OpenMPI
# #############################################################################

export PKG_NAME=petsc-$1
# export PKG_NAME=petsc-3.5.2
export MY_PREFIX_DIR=plat_base_packs

# -----------------------------------------------------------------------------
# This file script should be placed outside the directory petsc-3.6.3
#     namely  ../openmpi-1.10.2
# -----------------------------------------------------------------------------
# Install base packs dir=INSTALL_DIR= up dir packages=../femus_installation
# Package name PKG_NAME=petsc-3.6.3
# MPI  = $INSTALL_DIR/openmpi
# build dir=BUILD_DIR=$INSTALL_DIR/femus_installation
# PETSC installation dir=$INSTALL_DIR/$MY_PREFIX_DIR/petsc-3.6.3/linux-dbg 
#                        ->$INSTALL_DIR/petsc
# logs in $INSTALL_DIR/package_logs 
# -----------------------------------------------------------------------------



echo 
echo " --------- Start petsc_opt.sh script -------- "
echo
export SCRIPT_NAME=petsc
echo $SCRIPT_NAME " Script set up for "  $SCRIPT_NAME

# =============================================================================
# 1) ==================  setup ================================================
# =============================================================================
echo $SCRIPT_NAME  " 1->1a.build dir->1b.log dir->1c.femus_install dir->1d openmpi setup"

# 1a --------------- platform setup -------------------------------------------
export BUILD_DIR=$PWD
echo $SCRIPT_NAME " 1a set up: BUILD dir (BUILD_DIR) is                   = " $BUILD_DIR
cd ../
#  down to platform dir 
export INSTALL_DIR=$PWD
echo $SCRIPT_NAME " 1a set up: INSTALLATION platform DIR (INSTALL_DIR) is = " $INSTALL_DIR

# 1b log directory -------------------------------------------------------------
echo $SCRIPT_NAME " 1b set up: make directories" 
mkdir ./$MY_PREFIX_DIR
mkdir ./$MY_PREFIX_DIR/package_logs
if [ "$?" != "0" ]; then
  echo -e " 1b packagelogs and plat_base_packs already exist. Overwriting "
fi

# 1c up to BUILD dir ----------------------------------------------------------
echo $SCRIPT_NAME " 1c set up: LOG dir ({BUILD_DIR}/MYLOG_DIR_NAME) is    = " $INSTALL_DIR/$MY_PREFIX_DIR/package_logs
cd $BUILD_DIR

# 1d openmpi setup (OPENMPI in  $INSTALL_DIR/openmpi) -----------
echo $SCRIPT_NAME " 1d MPI dependency: OPENMPI_DIR="  $INSTALL_DIR"/openmpi/" 
# Add to the path the openmpi executables and libraries in order to compile petsc
export PATH=$INSTALL_DIR/openmpi/bin/:$PATH
export LD_LIBRARY_PATH=$INSTALL_DIR/openmpi/lib64/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$INSTALL_DIR/openmpi/lib/:$LD_LIBRARY_PATH
echo $SCRIPT_NAME " 1d MPI dependency: PATH="$INSTALL_DIR/"openmpi/bin/"
echo $SCRIPT_NAME " 1d MPI dependency: LD_LIBRARY_PATH="$INSTALL_DIR/"openmpi/lib/"
echo



# =============================================================================
# ======= 2 Install Petsc script  =============================================
# =============================================================================
echo
echo $SCRIPT_NAME ": inst dir package=" $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME
# if dir  does not exit in MY_PREFIX_DIR
if [ ! -d "$INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/linux-opt" ]
then

 echo $SCRIPT_NAME " 2 Compiling "$PKG_NAME" in opt mode"
 echo $SCRIPT_NAME " 2 script-> 2a prefix ->2b configure-> 2c make-> 2d test -> 2e install"
 export PKG_NAME_DIR=$BUILD_DIR/$PKG_NAME
  if [ ! -d "$PKG_NAME_DIR" ] 
 then
    echo " ............  extracting the file: "$PKG_NAME_DIR".tar.gz ..............."
    tar -xzvf "$PKG_NAME_DIR.tar.gz"
    echo "............. done extracting ............................................"
 fi
 cd $PKG_NAME_DIR

 # 2a prefix -------------------------------------------------------------------
 export METHOD=opt
 export PETSC_DIR=$PKG_NAME_DIR
 export PETSC_ARCH=linux-opt
 export INST_PREFIX=$INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/$PETSC_ARCH
 export LOGDIR=$INSTALL_DIR/$MY_PREFIX_DIR/package_logs/
 echo $SCRIPT_NAME " 2a prefix="$INST_PREFIX
 echo $SCRIPT_NAME " 2a Log dir="$LOGDIR

 # 2b configure-----------------------------------------------------------------
 echo $SCRIPT_NAME " 2b starting configuration of petsc-opt"
 ./configure --prefix=$INST_PREFIX --with-mpi-dir=$INSTALL_DIR/openmpi --with-shared-libraries=1 --with-debugging=1 --download-fblaslapack=$BUILD_DIR/fblaslapack-3.4.2.tar.gz >& $LOGDIR/petsc-opt_config.log
 if [ "$?" != "0" ]; then
   echo -e " 2b ${red}ERROR! Unable to configure petsc in opt mode${NC}"
     echo -e " 2b ${red}See the log for details${NC}"
   exit 1
 fi

 # 2c compiling ----------------------------------------------------------------
 echo $SCRIPT_NAME " 2c Configuration ended, now compiling"
 make >& $LOGDIR/petsc-opt_compil.log
 if [ "$?" != "0" ]; then
   echo -e " 2c ${red}ERROR! Unable to compile${NC}"
     echo -e " 2c ${red}See the log for details${NC}"
   exit 1
 fi
 # 2d test----------------------------------------------------------------------
 echo $SCRIPT_NAME " 2d testing"
 make test >& $LOGDIR/petsc-opt_testing.log
 if [ "$?" != "0" ]; then
   echo -e " 2d ${red}ERROR! Unable to run test examples${NC}"
   exit 1
 fi
 # 2e install-------------------------------------------------------------------
 echo $SCRIPT_NAME " 2d installing"
 make install  >& $LOGDIR/petsc-opt_install.log
 if [ "$?" != "0" ]; then
   echo -e " 2e ${red}ERROR! Unable to install${NC}"
   exit 1
 fi
echo $SCRIPT_NAME ": 2 "$PKG_NAME" in opt mode successfully installed!" 
else 
echo
echo $SCRIPT_NAME " No installation "
echo $SCRIPT_NAME " directory does exists: I am linking this directory !!!!!!!"
# if dir does or does not exit in MY_PREFIX_DIR
fi




# =============================================================================
# 3) Post install =============================================================
# =============================================================================

cd $BUILD_DIR
if [ "$?" != "0" ]; then
  echo -e " 3 ${red}ERROR! Package not available${NC}"
  exit 1
fi
echo

echo $SCRIPT_NAME " 3 script -> 3a liks -> 3b usage commands"

# 3a link ---------------------------------------------------------------------
rm -r $INSTALL_DIR/petsc
echo $SCRIPT_NAME " 3a PETSC post-install: petsc -> petsc.version " 
ln -s $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/linux-opt  $INSTALL_DIR/petsc

# 3b usage commands -----------------------------------------------------------
echo  $SCRIPT_NAME " 3b PETSC post install: PETSC usage "
echo "In order to run PETSC please set the following environment: "
echo "export PETSC_DIR="$INSTALL_DIR/petsc
echo "export PETSC_ARCH=linux-opt"



