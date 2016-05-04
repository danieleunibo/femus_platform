function show_dowloading(){
	
	
: ${DIALOG=dialog}
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ESC=255}
tempfiled=`tempfiled 2>/dev/null` || tempfiled=/tmp/test$$
trap "rm -f $tempfiled" 0 1 2 5 15

$DIALOG --backtitle "Software platform download" \
        --extra-button --extra-label "Fast" \
	--title "Download packages" \
        --checklist "
Press SPACE to toggle an option on/off. \n\n\
  Check on the package to Dowload" 23 50 13 \
        "SALOME"           "V7_7_1" ON  \
        "openmpi"          "1.10.2" ON  \
        "fblaslapack"      "3.4.2"  ON \
        "petsc"            "3.6.3"  ON  \
        "libmesh"          "0.9.5"  ON  \
        "FEMUs"            "v0"     ON  \
        "Paraview"         " "      off  \
        "DragonDonjon"     "v5.02"  off \
        "ParaFOAM"         "4.01"   off  \
        "OPENFOAM"         "3.01"   off  \
        "Saturne"          "4.0.5 " off  2> $tempfiled

retvald=$?
#choiced=`cat $tempfiled`
choiced=` sed s/\"//g  $tempfiled`
more  $tempfiled
fast=no
case $retvald in
    $DIALOG_OK)
     echo "'$choiced' chosen.";;
    $DIALOG_EXTRA)
     fast=yes;;
    $DIALOG_CANCEL)
     echo "Cancel pressed.";;
    $DIALOG_ESC)
     echo "ESC pressed.";;
   *)
    echo "Unexpected return code: $retvald (ok would be $DIALOG_OK)";;
esac 

msg_dialog=""
# msg_dialog10=""

for word in $choiced; do 

 # SALOME 7.7.1 ---------------------------------------------------------------------------------------------
 if [ $word == 'SALOME' ]; then
 if [ $fast == 'no' ]; then 
 dialog --title "Downloading SALOME" --msgbox "Now we are downloading SALOME: no other packages required " 10 50 
 fi
   wget --progress=dot http://slipknot.ing.unibo.it/~test/Salome-V7_7_1.run.tar.gz \
   2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
   | dialog --gauge "We are downloading SALOME" 10 100
   if [ $fast == 'no' ]; then 
   dialog --title "Done downloading" --msgbox "Salome-7.7.1.run.tar.gz dowloaded from http://slipknot.ing.unibo.it/~test/Salome-V7_7_1.run.tar.gz" 10 50
    fi
#    echo 
 fi
 if [ $word == 'Paraview' ]; then
 if [ $fast == 'no' ]; then 
 dialog --title "Done downloading" --msgbox " Paraview download not available" 10 50
 fi
#    echo 
 fi
 # Openmpi  1.10.2 ------------------------------------------------------------------------------------------
 if [ $word == 'openmpi' ]; then
 if [ $fast == 'no' ]; then 
 dialog --title "We are downloading fblaslapack" --msgbox "Now we are downloading openmpi: no other packages required " 10 50
 fi
   wget --progress=dot https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.2.tar.gz \
   2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
   | dialog --gauge "Download openmpi" 10 100
    if [ $fast == 'no' ]; then 
   dialog --title "Done downloading" --msgbox "openmpi-1.10.2.tar.gz dowloaded from https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.2.tar.gz" 10 50
   fi
 fi
 # PETSC  3.7.0 ---------------------------------------------------------------------------------------------
 if [ $word == 'fblaslapack' ]; then
  if [ $fast == 'no' ]; then 
     dialog --title "Downloading fblaslapack" --msgbox "Now we are downloading fblaslapack: no other packages required " 10 50
     fi
     wget --progress=dot http://ftp.mcs.anl.gov/pub/petsc/externalpackages/fblaslapack-3.4.2.tar.gz \
     2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e  "s,\%,,g" \
     | dialog --gauge "Download fblaslapack 3.4.2" 10 100
      if [ $fast == 'no' ]; then 
     dialog --title "Done downloading" --msgbox " fblaslapack-3.4.2 dowloaded from http://ftp.mcs.anl.gov/pub/petsc/externalpackages/fblaslapack-3.4.2.tar.gz" 10 50
      fi
     fi
 # PETSC  3.7.0 ---------------------------------------------------------------------------------------------
 if [ $word == 'petsc' ]; then
  if [ $fast == 'no' ]; then 
  dialog --title "Downloading PETSC" --msgbox "Now we are downloading PETSC 3.6.3: fblaslapack and openmpi required" 10 50 fblaslapack-3.4.2
  fi
     wget --progress=dot http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.6.3.tar.gz \
     2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e  "s,\%,,g" \
     | dialog --gauge "Download petsc 3.6.3" 10 100
      if [ $fast == 'no' ]; then 
     dialog --title "Done downloading" --msgbox "petsc-3.7.0.tar.gz dowloaded from http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.6.3.tar.gz" 10 50
     fi
  fi
#  libmesh.sh 0.9.5 -----------------------------------------------------------------------------------------
 if [ $word == 'libmesh' ]; then
  if [ $fast == 'no' ]; then 
      dialog --title "Dowloading " --msgbox "Now we are downloading libmesh v0.9.5: openmpi and petsc required" 10 50
      fi
      wget --progress=dot https://github.com/libMesh/libmesh/releases/download/v0.9.5/libmesh-0.9.5.tar.gz \
       2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
      | dialog --gauge "Download libmesh v0.9.5" 10 100
     if [ $fast == 'no' ]; then 
     dialog --title "Done downloading" --msgbox "libmesh-0.9.5.tar.gz dowloaded: libmesh-0.9.5 from https://github.com/libMesh/libmesh/releases/download/v0.9.5/libmesh-0.9.5.tar.gz" 10 50
     fi
 fi
 # femus ----------------------------------------------------------------------
 if [ $word == 'FEMUs' ]; then
  if [ $fast == 'no' ]; then 
  dialog --title "Downloading FEMUs" --msgbox "Now we are downloading FEMUs: SALOME, openmpi, petsc and libmesh required " 10 50
  fi
   wget --progress=dot http://slipknot.ing.unibo.it/~test/femus.tar.gz \
   2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
   | dialog --gauge "We are downloading FEMUs" 10 100
   if [ $fast == 'no' ]; then 
   dialog --title "Done downloading" --msgbox "femus.tar.gz dowloaded from http://slipknot.ing.unibo.it/~test/femus.tar.gz" 10 50
   fi
 fi
 # DragonDonjon v5.0.2 ---------------------------------------------------------------------------------------
 if [ $word == 'DragonDonjon' ]; then
  if [ $fast == 'no' ]; then 
     dialog --title "Dowloading " --msgbox "Now we are downloading DragonDonjon:  no other packages required" 10 50
  fi
      wget --progress=dot http://www.polymtl.ca/merlin/downloads/version5_v5.0.2.tgz \
      2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
      | dialog --gauge "Download Dragon-Donjon v5.0.2" 10 100
       if [ $fast == 'no' ]; then 
      dialog --title "Done downloading" --msgbox "Dragon-Donjon v5.0.2 dowloaded from http://www.polymtl.ca/merlin" 10 50 
      fi 
 fi
 # ParaviewFoam ---------------------------------------------------------------
 if [ $word == 'ParaFOAM' ]; then
   if [ $fast == 'no' ]; then 
     dialog --title "Dowloading " --msgbox "Now we are downloading ParaFoam: no other packages  required" 10 50
   fi   
      wget --progress=dot https://sourceforge.net/projects/openfoamplus/files/ThirdParty-v3.0+.tgz \
      2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
      | dialog --gauge "Download Parafoam-ThirdParty v3.0+" 10 100
       if [ $fast == 'no' ]; then 
       dialog --title "Done downloading" --msgbox "ThirdParty-v3.0+ dowloaded: ThirdParty-v3.0+ from https://sourceforge.net/projects/openfoamplus/files/ThirdParty-v3.0+.tgz" 10 50 
       fi
 fi
 # Open foam OpenFOAM-v3.0+ ---------------------------------------------------
 if [ $word == 'OPENFOAM' ]; then
   if [ $fast == 'no' ]; then 
    dialog --title "Dowloading " --msgbox "Now we are downloading OpenFoam:  openmpi  required" 10 50
    fi
    wget --progress=dot https://sourceforge.net/projects/openfoamplus/files/OpenFOAM-v3.0+.tgz \
    2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
    | dialog --gauge "Download Openfoam v3.0+" 10 100
   if [ $fast == 'no' ]; then 
   dialog --title "Done downloading" --msgbox "OPENFOAM-v3.0+ download from https://sourceforge.net/projects/openfoamplus/files/OpenFOAM-v3.0+.tgz" 10 50
   fi
 fi
  # Saturne  ---------------------------------------------------
 if [ $word == 'Saturne' ]; then
   if [ $fast == 'no' ]; then 
    dialog --title "Dowloading " --msgbox "Now we are downloading Saturne: see README for packages  required" 10 50
    fi
    wget --progress=dot http://code-saturne.org/cms/sites/default/files/releases/code_saturne-4.0.5.tar.gz \
    2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
    | dialog --gauge "Download Saturne 4.0.5  " 10 100
      if [ $fast == 'no' ]; then 
    if [ $fast == 'no' ]; then 
   dialog --title "Done downloading" --msgbox "saturne-4.0.5  download from http://code-saturne.org/cms/sites/default/files/releases/code_saturne-4.0.5.tar.gz" 10 50
   fi
    fi
 fi
 
      
done
# msg_dialog = " \n CATHARE: download not available "
dialog --title "Done downloading" --msgbox "You have dowloaded the following packages: $choiced   " 10 50
	
}
