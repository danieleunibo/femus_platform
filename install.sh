#!/bin/bash
# =======================================================================================
#               Package download function
# =======================================================================================
source gui_dowload.sh # contains show_dowloading
# =======================================================================================
#               Package guide function
# =======================================================================================
source gui_guide.sh # contains show_guide
# =======================================================================================
#               Package installation function
# =======================================================================================
source gui_install_package.sh # contains show_install
# ===================================================================================

# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$
# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$
# get text editor or fall back to vi_editor
vi_editor=${EDITOR-vi}
# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

#
# set infinite loop
#
while true
do

### display main menu ###
dialog --clear   --backtitle " Platform installer " \
--title "[ INSTALLATION MENU ]" \
--menu "Choose the TASK" 15 50 6 \
Download "Dowload packages" \
Installation "Installation program" \
Guide "Installation guide " \
Editor "Start a text editor" \
Exit "Exit to the shell" 2>"${INPUT}"

menuitem=$(<"${INPUT}")
# make decsion 
case $menuitem in
	Download) show_dowloading;;
	Installation) show_install;;
	Guide) show_guide;;
	Editor) $vi_editor;;
	Exit) echo "Bye"; break;;
esac

done

# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
