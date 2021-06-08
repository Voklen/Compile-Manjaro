#!/bin/bash

COLOR='\033[1;31m'
NOCOLOR='\033[0m'
root=sudo
#root=doas
txteditor=nano
#txteditor=nvim

echo -e "$COLOR Downloading Manjaro-tools...$NOCOLOR"
git clone https://gitlab.manjaro.org/tools/development-tools/manjaro-tools.git ~/.manjaro-tools
echo -e "$COLOR Downloading iso-profiles... $NOCOLOR"
git clone https://gitlab.manjaro.org/profiles-and-settings/iso-profiles.git ~/iso-profiles
cd ~/.manjaro-tools/
echo -e "$COLOR Compiling Manjaro-tools... $NOCOLOR"
make
echo -e "$COLOR Installing Manjaro-tools... $NOCOLOR"
$root make install

while true 
do
    echo
    read -r -p "What desktop evironment do you want to use? [architect/bladebook/gnome/gnome-next/grub/kde/kde-dev/netinstall/nxd/plasma-mobile/xfce]" input
    case $input in 

    [aA][rR][cC][hH][iI][tT][eE][cC][tT]|[aA])
        DE=architect
        break
    ;;
    [bB][lL][aA][dD][eE][bB][oO][oO][kK]|[bB])
        DE=bladebook
        break
    ;;
    [gG][nN][oO][mM][eE]|[gG])
        DE=gnome
        break
    ;;
    [gG][nN][oO][mM][eE][-][nN][eE][xX][tT]|[gG][nN])
        DE=gnome-next
        break
    ;;
    [gG][rR][uU][bB]|[gG][rR])
        DE=grub
        break
    ;;
    [kK][dD][eE]|[kK])
        DE=kde
        break
    ;;
    [kK][dD][eE][-][dD][eE][vV]|[kK][dD])
        DE=kde-dev
        break
    ;;
    [nN][eE][tT][iI][nN][sS][tT][aA][lL][lL]|[nN])
        DE=kde-dev
        break
    ;;
    [nN][xX][dD]|[nN][xX])
        DE=nxd
        break
    ;;
    [pP][lL][aA][sS][mM][aA][-][mM][oO][bB][iI][lL][eE]|[pP])
        DE=plasma-mobile
        break
    ;;
    [xX][fF][cC][eE]|[xX])
        DE=xfce
        break
    ;;
    *)
        echo -e "$COLOR Invalid input... $NOCOLOR"
    ;;
    esac
done


echo -e "$COLOR Compiling for $DE $NOCOLOR"

while true 
do
    echo
    read -r -p "Do you want to configure Manjaro? Help: https://wiki.manjaro.org/index.php/Build_Manjaro_ISOs_with_buildiso#Modifying_an_ISO_profile [Y/n]" input
    case $input in 

    [yY][eE][sS]|[yY])
        $txteditor ~/iso-profiles/manjaro/$DE/profile.conf
        echo -e "$COLOR Using custom configuration... $NOCOLOR"
        break
    ;;
    
    [nN][oO]|[nN])
        echo -e "$COLOR Using default configuration... $NOCOLOR"
        break
    ;;
    
    *)
        echo -e "$COLOR Invalid input... $NOCOLOR"
    ;;
    esac
done


while true 
do
    echo
    read -r -p "Do you want to compile Manjaro now? [Y/n]" input
    case $input in 

    [yY][eE][sS]|[yY])
        echo -e "$COLOR Compiling Manjaro... $NOCOLOR"
        break
    ;;
    
    [nN][oO]|[nN])
        echo -e "$COLOR Exiting... $NOCOLOR"
        exit 0
    ;;
    
    *)
        echo -e "$COLOR Invalid input... $NOCOLOR"
    ;;
    esac
done

while true 
do
    echo
    read -r -p "Do you want to add any arguments to the 'buildiso' command? (Select 'h' for help) [Y/n/h]" input
    case $input in 

    [yY][eE][sS]|[yY])
        echo
        read -r -p "Please enter arguments" args
        echo
        echo -e "$COLOR Compiling using arguments: $NOCOLOR"
        echo $args
        break
    ;;
    
    [nN][oO]|[nN])
        echo -e "$COLOR Compiling without arguments... $NOCOLOR"
        break
    ;;
    [hH][eE][lL][pP]|[hH])
        buildiso -h
    ;;
    
    *)
        echo -e "$COLOR Invalid input... $NOCOLOR"
    ;;
    esac
done

buildiso -p $DE $args

echo -e "$COLOR Cleaning up... $NOCOLOR"
$root rm -r /var/lib/manjaro-tools/buildiso/

echo -e "$COLOR Your ISO file can now be found at: /var/cache/manjaro-tools/iso/ $NOCOLOR"


