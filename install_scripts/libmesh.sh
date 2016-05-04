# #############################################################################
# Install LIBMESH with HDF5 - PETSC - OpenMPI
# #############################################################################

 export PKG_NAME=libmesh-$1
# export PKG_NAME=libmesh-0.9.4
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
echo " --------- Start libmesh.sh script -------- "
echo
export SCRIPT_NAME=libmesh
echo $SCRIPT_NAME " Script set up for "  $SCRIPT_NAME


# =============================================================================
# 1) ==================  setup ================================================
# =============================================================================
echo
echo $SCRIPT_NAME  " 1 setup "
echo $SCRIPT_NAME  " 1 script -> 1a build -> 2b log dir -> 1c openmpi -> 1d petsc -> 1e HDF5"

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
  echo -e $SCRIPT_NAME " 1b packagelogs and plat_base_packs dir already exist. Overwriting "
fi
echo $SCRIPT_NAME " 1b set up: LOG dir ({BUILD_DIR}/MYLOG_DIR_NAME) is    = " $INSTALL_DIR/$MY_PREFIX_DIR/package_logs


cd $BUILD_DIR


# 1c openmpi setup (OPENMPI in  $INSTALL_DIR/openmpi) -------------------------
echo $SCRIPT_NAME " 1d MPI dependency: OPENMPI directory=" $INSTALL_DIR"/openmpi/" 
# Add to the path the openmpi executables and libraries in order to compile petsc
export PATH=$INSTALL_DIR/openmpi/bin/:$PATH
export LD_LIBRARY_PATH=$INSTALL_DIR/openmpi/lib64/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$INSTALL_DIR/openmpi/lib/:$LD_LIBRARY_PATH
echo $SCRIPT_NAME " 1d MPI dependency: PATH=           "$INSTALL_DIR/"openmpi/bin/"
echo $SCRIPT_NAME " 1d MPI dependency: LD_LIBRARY_PATH="$INSTALL_DIR/"openmpi/lib/"

# 1d PETSC setup (PETSC opt in  $INSTALL_DIR/petsc) ---------------------------
export PETSC_ARCH=linux-opt
export PETSC_DIR=$INSTALL_DIR/petsc
echo $SCRIPT_NAME " 1e PETSC dependency: PETSC dir    =" $INSTALL_DIR/petsc

# 1e HDF5 setup ---------------------------------------------------------------
export HDF5_DIR=$INSTALL_DIR/hdf5
echo $SCRIPT_NAME " 1f HDF5 dependency: HDF5 dir      =:" $HDF5_DIR





# =============================================================================
# ======= 2 Install  Libmesh script  =============================================
# =============================================================================

# if dir  does not exit in MY_PREFIX_DIR
if [ ! -d "$INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME" ]
then
 echo
 echo $SCRIPT_NAME " 2 Compiling "$PKG_NAME
 echo $SCRIPT_NAME " 2 script-> 2a prefix -> 2b configure-> 2c make-> 2d test -> 2e install"

 export PKG_NAME_DIR=$BUILD_DIR/$PKG_NAME
 export INST_PREFIX=$INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/
 export LOGDIR=$INSTALL_DIR/$MY_PREFIX_DIR/package_logs/
  if [ ! -d "$PKG_NAME_DIR" ] 
 then
    echo " ............  extracting the file: "$PKG_NAME_DIR".tar.gz ..............."
    tar -xzvf "$PKG_NAME_DIR.tar.gz"
    echo "............. done extracting ............................................"
 fi
 cd $PKG_NAME_DIR

 echo $SCRIPT_NAME " 2a prefix="$INST_PREFIX
 echo $SCRIPT_NAME " 2a log directory="$LOGDIR

 # 2b configure-----------------------------------------------------------------
 echo $SCRIPT_NAME " 2b starting configuration"
 ./configure --prefix=$INST_PREFIX --with-mpi-dir=$INSTALL_DIR/openmpi --with-hdf5=$INSTALL_DIR/hdf5 --with-methods="dbg opt" >& $LOGDIR/libmesh_config.log
 if [ "$?" != "0" ]; then
   echo -e " 2b ${red}ERROR! Unable to configure${NC}"
     echo -e " 2b ${red}See the log for details${NC}"
   exit 1
 fi

 # 2c compiling ----------------------------------------------------------------
 echo $SCRIPT_NAME " 2c Configuration ended, now I am compiling"
 make -j2 >& $LOGDIR/libmesh_compile.log
 if [ "$?" != "0" ]; then
   echo -e " 2c ${red}ERROR! Unable to compile${NC} "
     echo -e " 2c ${red}See the log for details${NC}"
   exit 1
 fi
 # 2d test---------------------------------------------------------
 echo $SCRIPT_NAME " 2d testing: test is not active"
 # make test 
 # if [ "$?" != "0" ]; then
 #   echo -e " 2d ${red}ERROR! Unable to run petsc test examples in debug mode${NC}"
 #   exit 1
 # fi
 # 2e install---------------------------------------------------------
 echo $SCRIPT_NAME " 2e I am installing"
 make install  >& $LOGDIR/libmesh_install.log
 if [ "$?" != "0" ]; then
   echo -e " 2e ${red}ERROR! Unable to install${NC}"
   exit 1
 fi
else
echo
echo $SCRIPT_NAME " No installation "
echo $SCRIPT_NAME " directory does exists: I am linking this directory !!!!!!!"
fi
# endif dir does or does not exit in MY_PREFIX_DIR

# =============================================================================
# 3) Post install Libmesh script ==============================================
# =============================================================================





cd $BUILD_DIR
if [ "$?" != "0" ]; then
  echo -e " 2e ${red}ERROR!  libmesh installation not available${NC}"
  exit 1
fi
echo
echo $SCRIPT_NAME " 3: "$PKG_NAME"  post install"
echo $SCRIPT_NAME " 3 script -> 3a liks "

# 3a links --------------------------------------------------------------------
rm -r $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/lib
echo $SCRIPT_NAME " 3a Post-install: lib64 -> lib " 
ln -s $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/lib64 $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/lib

rm -r $INSTALL_DIR/libmesh
echo $SCRIPT_NAME " 3a post-install: libmesh -> libmesh.version " 
ln -s $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/  $INSTALL_DIR/libmesh


