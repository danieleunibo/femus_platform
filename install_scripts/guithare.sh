# #############################################################################
# Install guithare-V1.8.5
# #############################################################################

export PKG_NAME=guithare-$1
export MY_PREFIX_DIR=plat_base_packs
export GUI_PREFIX_DIR=plat_vis_gui
export v25_DIR=cathare/v25_3

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
echo " --------- Start guithare.sh script -------- "
echo
export SCRIPT_NAME=guithare
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
mkdir ./$GUI_PREFIX_DIR
if [ "$?" != "0" ]; then
  echo -e " 1b packagelogs and plat_base_packs already exist. Overwriting "
fi

# cd $BUILD_DIR
#  if [ ! -f "$PKG_NAME" ] 
#  then
#     echo "=============extracting the file: "$PKG_NAME_DIR".tar.gz============="
#     tar -xzvf "$PKG_NAME.tar.gz"
#     echo "=============done extracting ==========================="
#  fi
cd $BUILD_DIR 
if [ ! -d "$INSTALL_DIR/$GUI_PREFIX_DIR/guithare" ]; then
  echo "guithare does not exist: extraction tar"
  mkdir $INSTALL_DIR/$GUI_PREFIX_DIR/guithare 
  tar -xzf $PKG_NAME.tar.gz -C $INSTALL_DIR/$GUI_PREFIX_DIR
  echo $SCRIPT_NAME ": 1c  guithare extract and in place"
else
  echo $SCRIPT_NAME "guithare dir does  exist: no extraction tar"
fi


# ============================================================================= 
# 2) Install guithare script  ==================================================
# =============================================================================
# if dir  does not exit in MY_PREFIX_DIR
# echo
# echo $SCRIPT_NAME "inst dir package=" $INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME-x86_64
# if [ ! -d "$INSTALL_DIR/$MY_PREFIX_DIR/$PKG_NAME-x86_64/" ]
# then
# 
#  echo $SCRIPT_NAME " 2 ->  2a install -> 2b links"
#  # 2a installing  --------------------------------------------------------------
#  cd $BUILD_DIR
#  echo $SCRIPT_NAME " 2a Now installing "
#  sh $PKG_NAME.run -t $INSTALL_DIR/$MY_PREFIX_DIR/ -a $INSTALL_DIR/$GUI_PREFIX_DIR/appli_salome -l ENGLISH
# else 
#  echo
#  echo $SCRIPT_NAME " 2 No installation "
#  echo $SCRIPT_NAME " 2 directory already exists: I am linking this directory !!!!!!!"
# fi
# # if dir does or does not exit in MY_PREFIX_DIR
# 



# =============================================================================
# 3) link =====================================================================
# =============================================================================
# 
# 3a link ---------------------------------------------------------------------
echo
echo $SCRIPT_NAME " 3 -> 3a links"
cd $BUILD_DIR
rm -r  $INSTALL_DIR/$GUI_PREFIX_DIR/guithare/Solvers/v25_1
rm -r  $INSTALL_DIR/$GUI_PREFIX_DIR/guithare/Solvers/v25_2
rm -r  $INSTALL_DIR/$GUI_PREFIX_DIR/guithare/Solvers/v25_3
 echo $SCRIPT_NAME " 3a link" $INSTALL_DIR/cathare/v25_3/mod5.1/ " ->  " $INSTALL_DIR/$GUI_PREFIX_DIR/guithare/Solvers/v25_3
ln -s $INSTALL_DIR/cathare/v25_3/mod5.1/     $INSTALL_DIR/$GUI_PREFIX_DIR/guithare/Solvers/v25_3
ln -s $INSTALL_DIR/cathare/v25_3/mod5.1/     $INSTALL_DIR/$GUI_PREFIX_DIR/guithare/Solvers/v25_1
ln -s $INSTALL_DIR/cathare/v25_3/mod5.1/     $INSTALL_DIR/$GUI_PREFIX_DIR/guithare/Solvers/v25_2

echo $SCRIPT_NAME " 3b Remark ****  shared libraries libstdc++.so.5 missed. They must be install from main page Suse"
echo $SCRIPT_NAME " 3b Remark ****  shared libraries  libpng.so.3 missed.  One may link the library 12 with ln -s  /usr/lib64/libpng12.so.0 /usr/lib64/libpng.so.3"
echo  $SCRIPT_NAME " 3b Remark **** shared libraries  libexpat0 missed.  You can download lib expat0 with yast"

echo $SCRIPT_NAME " 3c start the gui with ./run.csh (dos2linux on this file)"




