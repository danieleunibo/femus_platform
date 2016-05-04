# #############################################################################
# Install OpenMPI
# #############################################################################

export PKG_NAME=openmpi-1.10.2
# export PKG_NAME=openmpi-1.8.3
export MY_PREFIX_DIR=plat_base_packs

# -----------------------------------------------------------------------------
# This file script should be placed inside femus-installation dir with
# openmpi package dir
# -----------------------------------------------------------------------------
# Install femus dir=INSTALL_DIR= up dir package=../femus_installation
# Package name PKG_NAME=openmpi-version
# MPI installation dir=$INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME 
#                      ->link ->$INSTALL_DIR/openmpi
# build dir=$INSTALL_DIR/femus_installation/$PKG_NAME
# logs in -> $INSTALL_DIR/$MY_PREFIX_DIR/package_logs directory
# -----------------------------------------------------------------------------




echo 
echo " --------- Start openmpi.sh script -------- "
echo
export SCRIPT_NAME=openmpi
echo $SCRIPT_NAME ": Script set up for "  $SCRIPT_NAME 
echo

# =============================================================================
# 1) ==================  setup ================================================
# =============================================================================
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
echo
echo $SCRIPT_NAME ": 1c  inst dir package=" $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME

# =============================================================================
# 2) Install OpenMPI script  ==================================================
# =============================================================================

# if dir  does not exit in MY_PREFIX_DIR
if [ ! -d "$INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/" ]
then

 echo $SCRIPT_NAME ": 2 -> 2b configure-> 2c make-> 2d install"

 # 2a place inside PKG_NAME_DIR=$BUILD_DIR/$OPENMPI_NAM --------------------
 export PKG_NAME_DIR=$BUILD_DIR/$PKG_NAME
 export INST_PREFIX=$INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME
 export LOGDIR=$INSTALL_DIR/$MY_PREFIX_DIR/package_logs/
#  uncompress the tar.gz file if needed
 if [ ! -d "$PKG_NAME_DIR" ] 
 then
    echo " ............  extracting the file: "$PKG_NAME_DIR".tar.gz ..............."
    tar -xzvf "$PKG_NAME_DIR.tar.gz"
    echo "............. done extracting ............................................"
 fi
 cd $PKG_NAME_DIR
 echo $SCRIPT_NAME ": 2b configuration  with --prefix="$INST_PREFIX  

 # 2b configure ----------------------------------------------------------------
 echo $SCRIPT_NAME ": 2b starting configure command" 
 ./configure --prefix=$INST_PREFIX >& $LOGDIR/openmpi_config.log
 if [ "$?" != "0" ]; then
   echo -e " 2b ${red}ERROR! Unable to configure${NC}"
     echo -e "  2b ${red}See the log for details${NC}"
   exit 1
 fi

 # 2c compiling -------------------------------------------------------------------
 echo $SCRIPT_NAME ": 2c Configuration ended, now compiling"
 make -j2 >&  $LOGDIR/openmpi_compile.log
 if [ "$?" != "0" ]; then
   echo -e " 2c ${red}ERROR! Unable to compile${NC}"
     echo -e " 2c ${red}See the log for details${NC}"
   exit 1
 fi

 # 2d make install ----------------------------------------------------------------
 echo $SCRIPT_NAME ": 2d Compilation ended now installing"
 make install >& $LOGDIR/openmpi_install.log
 if [ "$?" != "0" ]; then
   echo -e " 2d ${red}ERROR! Unable to install${NC}"
     echo -e " 2d ${red}See the log for details${NC}"
   exit 1
 fi
 echo $SCRIPT_NAME ": successfully installed! in " $INSTALL_DIR/$PKG_NAME/

 # ---------------------------------------------------------------------------------
else
 echo
 echo $SCRIPT_NAME ": 2 No installation "
 echo $SCRIPT_NAME ": 2 directory already exists: I am linking this directory !!!!!!!" 
# end if does not exit in MY_PREFIX_DIR
fi

# =============================================================================
# 3 post install ==============================================================
# =============================================================================

echo
echo $SCRIPT_NAME " 3 -> 3a links -> 3b openmpi usage commands"

# 3a Locate inside the build dir and to do links--------------------------------
cd $BUILD_DIR
if [ "$?" != "0" ]; then
  echo -e " 3a ${red}ERROR! installation dir not here ${NC}"
  exit 1
fi

 # Link to OPENMPI -------------------------------------------------------------
 echo $SCRIPT_NAME ": 3a OPENMPI Post-install: lib64 -> lib " 
 rm -r $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/lib
 ln -s $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/lib64  $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/lib

echo $SCRIPT_NAME ": 3a OPENMPI post-install: openmpi -> openmpi.version " 
rm -r $INSTALL_DIR/openmpi
ln -s $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/  $INSTALL_DIR/openmpi


# 3b Print comment how to use it -------------------------------------------------
echo " 3b Please add to the path the openmpi executables and libraries  to use it: "
echo " export PATH="$INSTALL_DIR"/openmpi/bin/:{PATH}"
echo " export LD_LIBRARY_PATH="$INSTALL_DIR"/openmpi/lib64/:{LD_LIBRARY_PATH}"
echo " export LD_LIBRARY_PATH="$INSTALL_DIR"/openmpi/lib/:{LD_LIBRARY_PATH}"
