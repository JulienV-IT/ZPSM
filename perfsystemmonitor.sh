#!/bin/bash

##############################
#         Dr.redfish         #
#       20 Juillet 2022      #
#                            #
#     Perf System Monitor    #
#       Version : 0.0.0      #
##############################


#####################################intro ##############################
#      Ce script analyse votre system,aux moyens des paquets disponible #
#      sur les distributions basée sur debian.                          #
#                                                                       #
#      Il est possible qu'il soit installer certains paquets manquant   #
#      au démarrage                                                     #
#                                                                       #
#                                                                       #
#       Chaques commandes fait a peu pret ce que son nom indique        #
#########################################################################



# cheching installation of notify-send packages
notify="/usr/bin/notify-send"
if [ -f $notify ] ; then # if the path exist we do nothing
  echo "notify is already installed"
else
  sudo apt install libnotify-bin -y # else we install it
fi


# checking installation of zenity packages
zenity="/usr/bin/zenity"
if [ -f $zenity ] ; then # if the path exist we do nothing
  echo "zenity is already installed"
else
  sudo apt install zenity -y # else we install it
fi

# checking installation of figlet packages
figlet1="/usr/bin/figlet"
figlet2="/usr/bin/X11/figlet"
figlet3="/usr/share/figlet"
figlet4="/usr/share/man/man6/figlet.6.gz"
figlet5="figlet"
if [ -f $figlet1 ] || [ -f $figlet2 ] || [ -f $figlet3 ] || [ -f $figlet3 ] || [ -f $figlet4 ] || [ -f $figlet5 ] ; then # if the path exist we do nothing

        echo "figlet is already installed"

else
        sudo apt install figlet -y # else we install it
fi




# checking installation of toilet packages
toilet="/usr/bin/toilet"
if [ -f $toilet ] ; then  # if the path exist we do nothing
  echo "toilet is already installed"
else
  sudo apt install toilet toilet-fonts -y # else install it
fi




notify-send " Perf System Monitor" # cool simply notice on desktop


# here is many functions for analyse your hardware configuration like his name he do the same

NbProc(){
  echo "Quelle est la marque du processeur et nb de cœur ?"
  sleep 0.5
  toilet -f smblock -F metal NbProc
  zenity --width=500 --height=500 --list \
    --title="Nombre de processeur" \
    --column="NbProc" \
    `lscpu | grep Processeur`
}

CPUPower(){
  echo "Quelle est la puissance du processeur ?"
  sleep 0.5
  toilet -f future -F gay CpuPower
  zenity --width=500 --height=500 --list \
    --title="Speed of Proc" \
    --column="SpeedCPU" \
    `lscpu | grep Vitesse`
}


Virtual(){
  echo "la virtualisation est t'elle activer ?"
  sleep 0.5
  toilet -f pagga -F border Virtualisation
  zenity --width=500 --height=500 --list \
    --title="Virt is active?" \
    --column="Active or not" \
    `lscpu | grep Virtualisation`
}

Memory(){
  echo "la taille de la mémoire vive ?"
  sleep 0.5
  toilet -f future -F metal Memory
  zenity --width=500 --height=500 --list \
  --title="Memory" \
  --column="Total of Mem" \
    `cat /proc/meminfo | grep MemTotal`
  # free -l
}

SetVirt(){
  echo "Comment activer la virtualisation ?"
  sleep 0.5
  zenity --width=500 --height=500 --info --title="Activer la virtualisation" --text "Au démarrage de l’ordi appuyer sur la touch « hotkey » differentes en fonction des machines 
  pour ma part « del » puis activer la virtualisation AMD-v"
  toilet -f smmono9 -F border Activer le bios

}

Graph(){
  echo "Qui est le constructeur graphique ?"
  sleep 0.5
  toilet -f future -F gay Constructeur graphique
  zenity --width=500 --height=500 --list \
    --title="GPU" \
    --column="graphical" \
    `lspci | grep VGA`
}


PeriphUSB(){
  echo "Lister les périphériques USB ?"
  sleep 0.5
  toilet -f pagga -F metal USB
  zenity --width=500 --height=500 --list \
    --title="USBdevices" \
    --column="Nb" \
    `ls -l /dev/usb/`
    #`sudo ls -l /dev/vboxusb/``
}

Partition(){
  echo "Lister les partitions ?"
  sleep 0.5
  toilet -f smmono9 -F gay Partitions
  zenity --width=500 --height=500 --list \
    --title="Partitions" \
    --column="Nb" \
    `lsblk | grep sda`
    `ls -l /dev/disk/by-uuid`
}



USBdev(){
  sleep 0.5
  toilet -f smmono9 -F border USBdevice
  echo "monitorer les clés usb !"
  zenity --width=500 --height=500 --list \
    --title="USBmon" \
    --column="nb" \
    `lsblk`
    `sudo dmesg`
}

ListHW(){
  sleep 0.5
  toilet -f smmono9 -F border ListHW
  echo "extraire votre configuration !"
  sudo lshw -html > config.html
  # FILE="config.html"
  FILE=`dirname $0`/config.html
  # zenity --text-info --html   "Config.html as been created with success" \
  # --title="ListHW" \

  zenity --text-info \
         --html \
         --title="License" \
         --filename=$FILE \


  zenity --question \
  --title "ouvrir ?" \
  --text "Ouvrir dans firefox ??"

  if [ $? = 0 ]
  then
  	echo "OUI ! merci"
    /opt/bin/firefox/firefox config.html
  	sleep 0.5
  else
  	echo "NON ! ca ira ..."
  	sleep 0.5
  fi


}

# /_!_\ work in progress /_!_\
# TODO get all VM and take control on it
GetMachineVirtuel(){
  sleep 0.5
  sudo virsh list --all > vmlist.txt
  FILE="vmlist.txt"
  toilet -f smmono9 -F gay Virtual machine
  zenity --text-info \
--title "Hostname Information" \
--filename $FILE

}


# here is starting of zenity interface with


# # loading bar

(
echo "10" ; sleep 1
echo "# logiciel PerfSystemMonitoring" ; sleep 1
echo "20" ; sleep 1
echo "# Vérification des dépendances" ; sleep 1
echo "50" ; sleep 1
echo "# ------------------------------------------------------->" ; sleep 1
echo "75" ; sleep 1
echo "# cliquez sur valider pour commencer" ; sleep 1
echo "100" ; sleep 1
) |
zenity --progress \
  --title="Démarrage de zenity" \
  --text="Lancement de PerfSystemMonitoring" \
  --percentage=0

if [ "$?" = -1 ] ; then
  zenity --error \
    --text="Démarrage stoppé."
fi

# menu
while true; do
choice="$(zenity --width=500 --height=500 --title="PerfSystemMonitoring" --list --column "fonction" --column "description" \
"Nbprocesseurs" \
"Affiche Nombre de processeur" \
"CPUPower" \
"Affiche La puissance en MHz" \
"Memory" \
"Affiche la capacité de la mémoire disponible" \
"SetVirtualisation" \
"Affiche un conseil pour activer la virtualisation" \
"Graphic" \
"Affiche des informations sur le GPU" \
"USBdevices" \
"Affiche des informations sur les périphériques USB" \
"Partitions" \
"Affiche les partitions" \
"ExportConfig" \
"Export HTML de la configuration globale avec possible ouverture dans firefox" \
"GetMachineVirtuel" \
"_!_ Bientot Disponible Ne fonctionne pas _!_" \
"Quit" \
"Quittez le programme")"

case ${choice} in
Nbprocesseurs)
NbProc;;
CPUPower)
CPUPower;;
Virtualisation)
Virtual;;
Memory)
Memory;;
SetVirtualisation)
SetVirt;;
Graphic)
Graph;;
USBdevices)
PeriphUSB;;
Partitions)
Partition;;
ExportConfig)
ListHW;;
GetMachineVirtuel)
GetMachineVirtuel;;
Quit)
break
exit;;

esac
done
