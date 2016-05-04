
function show_install(){


: ${DIALOG=dialog}
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ESC=255}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

$DIALOG --backtitle "Software platform" \
	--title "FEMus installation" \
	--extra-button --extra-label "Fast" \
        --checklist "
Press SPACE to toggle an option on/off. \n\n\
  Check on the package to install" 20 61 10 \
        "SALOME"           "V7_7_1" off  \
        "openmpi"          "1.10.2" off  \
        "petsc-dbg"        "3.6.3"  off  \
        "petsc-opt"        "3.6.3"  off  \
        "libmesh"          "0.9.5"  off  \
        "FEMUs"            "v0"     off  \
        "DragonDonjon"     "v5.02"  off  \
        "ParaFOAM"         "4.01"   off  \
        "OPENFOAM"         "3.01"   off  \
        "GUITHARE"          "1.8.5 " off \
        "CATHARE"          "v25_3"       off  2> $tempfile

retval=$?
# choice=`cat $tempfile`
choice=` sed s/\"//g  $tempfile`
more  $tempfile
fast=no
case $retval in
    $DIALOG_OK)
     echo "'$choice' chosen.";;
    $DIALOG_EXTRA)
     fast=yes;;
    $DIALOG_CANCEL)
     echo "Cancel pressed.";;
    $DIALOG_ESC)
     echo "ESC pressed.";;
   *)
    echo "Unexpected return code: $retval (ok would be $DIALOG_OK)";;
esac  

    
    for word in $choice; do 
#       if [ $word == 'No_installation' ]; then
#        echo "No installation"
#        count=1
#       fi
      if [ $word == 'SALOME'  ]; then
       if [ $fast == 'no' ]; then 
       dialog --title "requirements" --msgbox " SALOME required packages: none " 10 50
       fi
       source install_scripts/salome.sh V7_7_1
        if [ $fast == 'no' ]; then 
       dialog --title "Done installing" --msgbox " SALOME is installed" 10 50
       fi
      fi
      if [ $word == 'openmpi'  ]; then
       if [ $fast == 'no' ]; then 
        dialog --title "requirements" --msgbox " openmpi required packages: none " 10 50
        fi
        source install_scripts/openmpi.sh 1.10.2
         if [ $fast == 'no' ]; then 
        dialog --title "Done installing" --msgbox " openmp is installed" 10 50
        fi
      fi
      if [ $word == 'petsc-dbg'  ]; then
       if [ $fast == 'no' ]; then 
        dialog --title "requirements" --msgbox " PETSC required packages: openmpi " 10 50
        fi
        source install_scripts/petsc_dbg.sh 3.6.3
         if [ $fast == 'no' ]; then 
        dialog --title "Done installing" --msgbox " petsc-dbg is installed" 10 50
        fi
      fi
      if [ $word == 'petsc-opt' ]; then
       if [ $fast == 'no' ]; then 
        dialog --title "requirements" --msgbox " PETSC required packages: OPENMPI" 10 50
        fi
        source install_scripts/petsc_opt.sh 3.6.3
         if [ $fast == 'no' ]; then 
        dialog --title "Done installing" --msgbox " petsc-op is installed" 10 50
        fi
      fi
      if [ $word == 'libmesh' ]; then
       if [ $fast == 'no' ]; then 
        dialog --title "requirements" --msgbox " LIBMESH required packages: OPENMPI, PETSC" 10 50
        fi
        source install_scripts/libmesh.sh 0.9.5
         if [ $fast == 'no' ]; then 
        dialog --title "Done installing" --msgbox " LIBMESH is installed" 10 50
        fi
      fi
      if [ $word == 'FEMUs'  ]; then
       if [ $fast == 'no' ]; then 
        dialog --title "requirements" --msgbox " FEMUs required packages: OPENMPI, PETSC, LIBMESH" 10 50
        fi
        source install_scripts/femus.sh
       if [ $fast == 'no' ]; then 
       dialog --title "Done installing" --msgbox " FEMUs is installed" 10 50
       fi
      fi
      if [ $word == 'DragonDonjon' ]; then
       if [ $fast == 'no' ]; then 
       dialog --title "requirements" --msgbox " DragonDonjon required packages: none" 10 50
       fi
       source install_scripts/dragondonjon.sh
       dialog --title "Done installing" --msgbox " DragonDonjon is installed" 10 50
      fi
      if [ $word == 'ParaFOAM' ]; then
      if [ $fast == 'no' ]; then
       dialog --title "requirements" --msgbox " ParaFoam required packages: OPENMPI, ParafOAM" 10 50
       fi
       source install_scripts/parafoam.sh
       if [ $fast == 'no' ]; then
       dialog --title "Done installing" --msgbox " PARAFOAM is installed" 10 50
       fi
      fi
      if [ $word == 'OPENFOAM'  ]; then
       if [ $fast == 'no' ]; then
       dialog --title "requirements" --msgbox " OPENFOAM required packages: OPENMPI, ParafOAM" 10 50
       fi
       source install_scripts/openfoam.sh
       if [ $fast == 'no' ]; then
       dialog --title "Done installing" --msgbox " OPENFOAM is installed" 10 50
       fi
      fi
            if [ $word == 'GUITHARE'  ]; then
       if [ $fast == 'no' ]; then
       dialog --title "requirements" --msgbox " GUITHARE required packages: None" 10 50
       fi
       source install_scripts/guithare.sh V1.8.5       
       if [ $fast == 'no' ]; then
       dialog --title "Done installing" --msgbox " GUITHARE is installed" 10 50
       fi
      fi
      if [ $word == 'CATHARE'  ]; then
       source install_scripts/cathare.sh v25_3 
       if [ $fast == 'no' ]; then
       dialog --title "Done installing" --msgbox " CATHARE is installed" 10 50
       fi
      fi

      
    done
dialog --title "Done installation" --msgbox "you have installed: $choice" 8 30




# 	echo "Today is $(date) @ $(hostname -f)." >$OUTPUT
#     display_output 6 60 "Date and Time"
} 
