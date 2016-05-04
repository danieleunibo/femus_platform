# #############################################################################
# Install Femus
# #############################################################################

export PKG_NAME=femus
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
export SCRIPT_NAME=femus
echo $SCRIPT_NAME " Script set up for "  $SCRIPT_NAME 
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
cd $BUILD_DIR


# 2) Install femus script  ==================================================
echo
echo $SCRIPT_NAME ": 2 instal dir:" $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME/
# if dir  does not exit in MY_PREFIX_DIR
if [ ! -d "$INSTALL_DIR/$PKG_NAME" ]
then
export PKG_NAME_DIR=$BUILD_DIR/$PKG_NAME
 if [ ! -d "$PKG_NAME_DIR" ] 
 then
    echo "=============extracting the file: "$PKG_NAME_DIR".tar.gz============="
    tar -xzvf "$PKG_NAME_DIR.tar.gz" 
    echo "=============done extracting ==========================="
 fi
  cd $BUILD_DIR/femus
  #   echo "export INSTALLATION_DIR="$INSTALL_DIR $'\n'\
  # "export med3_NAME=salome/med" $'\n'\
  # "export MED_NAME=salome/MED_mod" $'\n' > env_prepend.txt
  # cat env.sh >> env_prepend.txt
  # mv env_prepend.txt env.sh
  cd ../
  cp -r $BUILD_DIR/femus $INSTALL_DIR/femus
  if [ "$?" != "0" ]; then
   echo -e "${red}ERROR! Unable to move femus dir${NC}"
   exit 1
  fi
  echo $SCRIPT_NAME ": 2 Femus successfully installed!!!!!!!!"
else
echo $SCRIPT_NAME ": 2 No installation, directory already exists!!!!!!!!!"
fi


###################################################################################
# Clean build directory
###################################################################################
cd $INSTALL_DIR
# mv $BUILD_DIR/logs $INSTALL_DIR/logs
# rm -r $BUILD_DIR

