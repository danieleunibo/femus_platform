 
# #############################################################################
# Install CATHARE
#
# call this script as
# source cathare.sh v5.0
#        cathare.sh package-version 
# #############################################################################


export PKG_NAME=cathare-$1
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
echo " --------- Start cathare.sh script -------- "
echo
export SCRIPT_NAME=cathare
echo $SCRIPT_NAME ": Script set up for "  $SCRIPT_NAME 
echo

# =================================================================================
# 1) ==================  setup ====================================================
# =================================================================================
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
if [ ! -d "$INSTALL_DIR/cathare" ]; then
  mkdir $INSTALL_DIR/cathare
  echo "cathare does not exist: extraction tar"
  tar -xzf $PKG_NAME.tar.gz -C $INSTALL_DIR/cathare/
  echo $SCRIPT_NAME ": 1c  cathare extract and in place" 
else
  echo " cathare dir exists: no extraction tar"
fi
echo

# =================================================================================
# 2) Install OpenMPI script  ======================================================
# =================================================================================

# cathare is buid in its own directory
OFBUILD_DIR=$INSTALL_DIR/cathare
cd $OFBUILD_DIR    
echo $SCRIPT_NAME " 2a: build in " $PWD

# export environment base dir $v25_3
export v25_3=$OFBUILD_DIR/v25_3/mod2.1
echo $SCRIPT_NAME " 2a: cathare base dir in  " $v25_3/

echo $SCRIPT_NAME " 2c: Patches for files TEQJONO2.f and OPIBECO2.f"
rm -f $v25_3/sources/pipe/discret/TEQJONO2.f
cp $OFBUILD_DIR/modification/TEQJONO2.f $v25_3/sources/pipe/discret/

rm -f $v25_3/sources/boundary/discret/OPIBECO2.f
cp $OFBUILD_DIR/modification/OPIBECO2.f $v25_3/sources/boundary/discret/
echo $SCRIPT_NAME " 2b: make lib command sh ./unix-procedur/makelib.unix " in dir $v25_3

chmod 755 $v25_3/unix-procedur/*.unix
cd $v25_3
sh ./unix-procedur/makelib.unix






# =================================================================================
# 3 post install ==================================================================
# =================================================================================
 
echo $SCRIPT_NAME "3 a Postinstall: chmod"
chmod 555 $v25_3/unix-procedur/*.unix
echo $SCRIPT_NAME " 3b. Postinstall: make ICoCo libraries"
cd $v25_3/ICoCo
make 



cd $BUILD_DIR
