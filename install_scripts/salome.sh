# #############################################################################
# Install Salome
# #############################################################################

export PKG_NAME=Salome-$1
export MY_PREFIX_DIR=plat_base_packs
export GUI_PREFIX_DIR=plat_vis_gui
export SALOME_HDF5_DIR=prerequisites/Hdf5-1814/
export SALOME_med_dir=tools/Medfichier-310
export SALOME_MED_DIR=modules/MED_V7_7_1/

# -----------------------------------------------------------------------------
# This file script should be placed inside femus-installation dir with
# openmpi package dir
# -----------------------------------------------------------------------------
# Install  dir=INSTALL_DIR= up dir package=../femus_installation
# Package name PKG_NAME=openmpi-version
# MPI installation dir=$INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME 
#                      ->link ->$INSTALL_DIR/openmpi
# build dir=$INSTALL_DIR/femus_installation/$PKG_NAME
# logs in -> $INSTALL_DIR/$MY_PREFIX_DIR/package_logs directory
# -----------------------------------------------------------------------------



echo 
echo " --------- Start salome.sh script -------- "
echo
export SCRIPT_NAME=salome
echo $SCRIPT_NAME " Script set up for "  $SCRIPT_NAME 
echo

# =============================================================================
# 1) ==================  setup ================================================
# =============================================================================
echo $SCRIPT_NAME  " 1 -> 1a.build dir-> 1b.log dir -> 1c.femus_install dir"

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

cd $BUILD_DIR
 if [ ! -f "$PKG_NAME.run" ] 
 then
    echo "=============extracting the file: "$PKG_NAME_DIR".tar.gz============="
    tar -xzvf "$PKG_NAME.run.tar.gz"
    echo "=============done extracting ==========================="
 fi

# ============================================================================= 
# 2) Install Salome script  ==================================================
# =============================================================================
# if dir  does not exit in MY_PREFIX_DIR
echo
echo $SCRIPT_NAME "inst dir package=" $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME-x86_64
if [ ! -d "$INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME-x86_64/" ]
then

 echo $SCRIPT_NAME " 2 ->  2a install -> 2b links"
 # 2a installing  --------------------------------------------------------------
 cd $BUILD_DIR
 echo $SCRIPT_NAME " 2a Now installing "
 sh $PKG_NAME.run -t $INSTALL_DIR/$MY_PREFIX_DIR/ -a $INSTALL_DIR/$GUI_PREFIX_DIR/appli_salome -l ENGLISH
else 
 echo
 echo $SCRIPT_NAME " 2 No installation "
 echo $SCRIPT_NAME " 2 directory already exists: I am linking this directory !!!!!!!"
fi
# if dir does or does not exit in MY_PREFIX_DIR

# =============================================================================
# 3) link =====================================================================
# =============================================================================

cd $BUILD_DIR
echo $SCRIPT_NAME " 3 -> 3a links"

# 3a link ---------------------------------------------------------------------
rm -r  $INSTALL_DIR/hdf5
echo $SCRIPT_NAME " 3a link hdf5 -> ../plat_base_packs/salome.version/prerequisites/hdf5.version"
ln -s $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME-x86_64/$SALOME_HDF5_DIR       $INSTALL_DIR/hdf5

rm -r $INSTALL_DIR/salome
echo $SCRIPT_NAME " 3a link salome -> ../plat_base_packs/salome.version "
ln -s $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME-x86_64    $INSTALL_DIR/salome

 rm -r  $INSTALL_DIR/salome/med
 echo $SCRIPT_NAME " 3a link ../salome/med -> ../plat_base_packs/salome.version/tools/med.version"
 ln -s $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME-x86_64/$SALOME_med_dir   $INSTALL_DIR/salome/med

 rm -r  $INSTALL_DIR/salome/MED_mod
 echo $SCRIPT_NAME " 3a link ../salome/MED_mod -> ../plat_base_packs/salome.version/modules/MOD.version"
 ln -s $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME-x86_64/$SALOME_MED_DIR    $INSTALL_DIR/salome/MED_mod
#  else
 echo "The salome folder in ../plat_base_packs/ does not exist"
# fi



