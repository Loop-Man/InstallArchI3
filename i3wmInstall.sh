#!/bin/bash

# Set the cores
echo "Setting the cores"

set -e

numberofcores=$(grep -c ^processor /proc/cpuinfo)

if [ $numberofcores -gt 1 ]
then
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'$(($numberofcores+1))'"/g' /etc/makepkg.conf;
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$numberofcores"' -z -)/g' /etc/makepkg.conf
else
        echo "No change."
fi

echo ""

sudo pacman -Syu --noconfirm --needed

# -------------------
# Sound
# -------------------

echo "Setting Sound"
sudo pacman -S --noconfirm --needed pulseaudio
sudo pacman -S --noconfirm --needed pulseaudio-alsa
sudo pacman -S --noconfirm --needed pavucontrol
sudo pacman -S --noconfirm --needed alsa-utils
sudo pacman -S --noconfirm --needed alsa-plugins
sudo pacman -S --noconfirm --needed alsa-lib
sudo pacman -S --noconfirm --needed alsa-firmware

echo ""

# -----------------
# Bluetooth
# -----------------

echo "Setting Bluetooth"

sudo pacman -S --noconfirm --needed pulseaudio-bluetooth
sudo pacman -S --noconfirm --needed bluez
sudo pacman -S --noconfirm --needed bluez-libs
sudo pacman -S --noconfirm --needed bluez-utils
sudo pacman -S --noconfirm --needed blueberry

sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

echo "reboot your system then ..."
echo "set with bluetooth icon in bottom right corner"
echo "change to have a2dp if needed"

echo ""

# -----------------
# Printers
# -----------------

#echo "Setting Printers"

#sudo pacman -S --noconfirm --needed cups 
#sudo pacman -S --noconfirm --needed cups-pdf


#first try if you can print without foomatic
#sudo pacman -S --noconfirm --needed foomatic-db-engine
#sudo pacman -S --noconfirm --needed foomatic-db
#sudo pacman -S --noconfirm --needed foomatic-db-ppds
#sudo pacman -S --noconfirm --needed foomatic-db-nonfree-ppds
#sudo pacman -S --noconfirm --needed foomatic-db-gutenprint-ppds

#sudo pacman -S --noconfirm --needed ghostscript
#sudo pacman -S --noconfirm --needed gsfonts 
#sudo pacman -S --noconfirm --needed gutenprint
#sudo pacman -S --noconfirm --needed gtk3-print-backends
#sudo pacman -S --noconfirm --needed libcups
#sudo pacman -S --noconfirm --needed hplip
#sudo pacman -S --noconfirm --needed system-config-printer

#sudo systemctl enable org.cups.cupsd.service

#echo "After rebooting it will work"

#echo ""

# -----------------
# Network Discovery
# -----------------

echo "Setting Network Discovery"

sudo pacman -S --noconfirm --needed wget 
sudo pacman -S --noconfirm --needed curl
sudo pacman -S --noconfirm --needed network-manager-applet
sudo pacman -S --noconfirm --needed avahi                       #Avahi es un entorno totalmente LGPL para el descubrimiento de servicios de DNS multicast

sudo systemctl enable avahi-daemon.service
sudo systemctl start avahi-daemon.service

#shares on a mac
sudo pacman -S --noconfirm --needed nss-mdns

#shares on a linux
sudo pacman -S --noconfirm --needed gvfs-smb

#first part
sudo sed -i 's/files mymachines myhostname/files mymachines/g' /etc/nsswitch.conf
#last part
sudo sed -i 's/\[\!UNAVAIL=return\] dns/\[\!UNAVAIL=return\] mdns dns wins myhostname/g' /etc/nsswitch.conf

echo ""

# --------------------
# Battery for Laptops
# --------------------

echo "Install tlp for battery life - laptops"

sudo pacman -S --noconfirm --needed cbatticon

echo ""

# --------------------
# Basic Linux Stuff
# --------------------

# software from standard Arch Linux repositories
# Core, Extra, Community, Multilib repositories
echo "Installing category Accessories"

sudo pacman -S --noconfirm --needed cronie                    # For cronjobs
sudo pacman -S --noconfirm --needed flameshot                 # For screenshoots

echo "Installing category Development"

sudo pacman -S --noconfirm --needed vim
sudo pacman -S --noconfirm --needed python 
sudo pacman -S --noconfirm --needed python2
#sudo pacman -S --noconfirm --needed python-pip 
#sudo pacman -S --noconfirm --needed python2-pip
#sudo pip2 install -U pip                                       # Actualizar pip2
#sudo pip install -U pip                                        # Actualizar pip3
#sudo pip3 install cve_searchsploit                             # Instalamos searchsploit_cve

echo "Installing category Graphics"

#sudo pacman -S --noconfirm --needed gimp                     # GIMP es un programa de edición de imágenes digitales en forma de mapa de bits, tanto dibujos como fotografías
sudo pacman -S --noconfirm --needed eog                      # is the GNOME image viewer

echo "Installing category Internet"

#sudo pacman -S --noconfirm --needed chromium
sudo pacman -S --noconfirm --needed firefox
#sudo pacman -S --noconfirm --needed qbittorrent
#sudo pacman -S --noconfirm --needed lynx                   # Lynx es un navegador web y cliente de gopher en modo texto
sudo pacman -S --noconfirm --needed tor 
sudo pacman -S --noconfirm --needed torsocks
sudo pacman -S --noconfirm --needed torbrowser-launcher
sudo pacman -S --noconfirm --needed nyx                    # Nyx is a command-line monitor for Tor. With this you can get detailed real-time information about your relay such as bandwidth usage, connections, logs, and much more.
#sudo pacman -S --noconfirm --needed thunderbird            # Gestor de correo
#sudo pacman -S --noconfirm --needed pidgin                 # For social media
#sudo pacman -S --noconfirm --needed w3m                    # W3m es un navegador web basado en texto así como un paginador. Se parece mucho a Lynx

echo "Installing category Multimedia"

sudo pacman -S --noconfirm --needed simplescreenrecorder    #Grabador de pantalla con muchas funcionalidades
sudo pacman -S --noconfirm --needed vlc                     #Reproductor de video
sudo pacman -S --noconfirm --needed youtube-dl              #Programa para descargar videos de youtube.

echo "Installing category Office"

#sudo pacman -S --noconfirm --needed libreoffice             # Libreoffice
#sudo pacman -S --noconfirm --needed libreoffice-es          # Libreoffice español
#sudo pacman -S --noconfirm --needed evince                  # Visor de pdf
sudo pacman -S --noconfirm --needed okular                  # Es uno de los más populares y completos visores de documentos, te permite ver archivos formatos del tipo PDF, EPUB, CBR y CBZ (cómics).
sudo pacman -S --noconfirm --needed gedit                   # Editor de texto    

echo "Installing category System"

sudo pacman -S --noconfirm --needed accountsservice         # Interfaz para las consultas y manipulación de cuentas de usuario del sistema
sudo pacman -S --noconfirm --needed git                     # CLI del software de control de versiones
sudo pacman -S --noconfirm --needed glances                # Herramienta de monitorización del sistema por CLI
sudo pacman -S --noconfirm --needed gparted                 # is a free partition editor for graphically managing your disk partitions
sudo pacman -S --noconfirm --needed grsync                 # rsync es una herramienta diferencial de copia de seguridad y sincronización de archivos
sudo pacman -S --noconfirm --needed gvfs                    # es un reemplazo para GNOME VFS, el sistema virtual de archivos de GNOME para detectar dispositivos extraibles.
sudo pacman -S --noconfirm --needed gvfs-mtp                # es un reemplazo para GNOME VFS, el sistema virtual de archivos de GNOME para detectar dispositivos extraibles.
sudo pacman -S --noconfirm --needed hardinfo               # is a system profiler and benchmark for Linux systems
sudo pacman -S --noconfirm --needed hddtemp                 # is a small utility (with daemon) that gives the hard-drive temperature
sudo pacman -S --noconfirm --needed htop                    # es un sistema de monitorización, administración y visor de procesos interactivo
sudo pacman -S --noconfirm --needed lsb-release             # El comando lsb_release nos muestra la información LSB (Linux Standard Base)
sudo pacman -S --noconfirm --needed mlocate                 # Es una versión más segura de la utilidad locate
sudo pacman -S --noconfirm --needed net-tools               # Conjunto de herramientas de red
sudo pacman -S --noconfirm --needed numlockx                # numlockx is a program to control the NumLock key inside X11 session scripts
sudo pacman -S --noconfirm --needed neofetch                # Neofetch muestra información sobre su sistema junto a una imagen.
sudo pacman -S --noconfirm --needed tmux                    # Tmux es un multiplexador de terminales
sudo pacman -S --noconfirm --needed termite                 # Terminal termite para arch. Is a minimal VTE-based terminal emulator. It is a modal application, similar to Vim
sudo pacman -S --noconfirm --needed thunar                  # Thunar es el gestor de archivos lanzado oficialmente con la versión 4.4 de Xfce
sudo pacman -S --noconfirm --needed thunar-archive-plugin
sudo pacman -S --noconfirm --needed thunar-volman
sudo pacman -S --noconfirm --needed caja                    # Caja es un gestor de archivos
sudo pacman -S --noconfirm --needed tumbler                 # is part of the XFCE standard installation
sudo pacman -S --noconfirm --needed virtualbox-host-modules-arch # Virtualbox es un software de virtualización para arquitecturas x86/amd64
sudo pacman -S --noconfirm --needed virtualbox              # Virtualbox es un software de virtualización para arquitecturas x86/amd64
sudo pacman -S --noconfirm --needed unclutter               # Unclutter hides your X mouse cursor when you do not need it
#sudo pacman -S --noconfirm --needed rxvt-unicode           # rxvt-unicode es un emulador de terminal altamente configurable derivado de rxvt. Comunmente es conocido como urxvt
#sudo pacman -S --noconfirm --needed urxvt-perls            # A small collection of perl extensions for the rxvt-unicode terminal emulator
sudo pacman -S --noconfirm --needed xdg-user-dirs           # xdg-user-dirs is a tool to help manage "well known" user directories like the desktop folder and the music folder
sudo pacman -S --noconfirm --needed xdo                     # Utilidad para realizar acciones sobre windows
sudo pacman -S --noconfirm --needed xdotool                 # CLI X11 automation tool
sudo pacman -S --noconfirm --needed zenity                  # Zenity es un conjunto de cajas de diálogos gráficas que usan las librerías gtk
sudo pacman -S --noconfirm --needed man                     # Man es una aplicación que proporciona manuales para los comandos utilizados
sudo pacman -S --noconfirm --needed cmake                   # CMake es una herramienta multiplataforma de generación o automatización de código
sudo pacman -S --noconfirm --needed ranger                  # Ranger, un potente administrador de archivos para el terminal
sudo pacman -S --noconfirm --needed reflector               # Reflector is a Python script which can retrieve the latest mirror list from the Arch Linux    
sudo pacman -S --noconfirm --needed dnsutils                # Proporciona herramientas para consultas dns
sudo pacman -S --noconfirm --needed xorg-xbacklight         # Aplicación para controlar la iluminación
sudo pacman -S --noconfirm --needed grc                     # Comando para darle color a la salida de los comandos
sudo pacman -S --noconfirm --needed xclip                   # Comando para copiar la salida al portapapeles
sudo pacman -S --noconfirm --needed jq                      # Comando para parsear json
sudo pacman -S --noconfirm --needed fish                    # Fish shell
sudo pacman -S --noconfirm --needed nfs-utils               # Herramientas para consultas nfs, NFS is a protocol that allows sharing file systems over the network. 
sudo pacman -S --noconfirm --needed tree                    # Comando para ver directorios en modo arbol
#sudo pacman -S --noconfirm --needed remmina                # Remmina es un cliente de escritorio remoto para sistemas operativos de computadora basados en POSIX. Es compatible con los protocolos Remote Desktop Protocol, VNC, NX, XDMCP, SPICE y SSH
sudo pacman -S --noconfirm --needed rdesktop                # Cliente para RDP
sudo pacman -S --noconfirm --needed calcurse                # calcurse is a calendar and scheduling application for the command line
sudo pacman -S --noconfirm --needed sysstat                 # sysstat es una colección de herramientas de monitoreo de rendimiento para Linux
sudo pacman -S --noconfirm --needed task                    # Gestor de tareas
sudo pacman -S --noconfirm --needed keepassxc               # Gestor de contraseñas

###############################################################################################

# installation of zippers and unzippers
sudo pacman -S --noconfirm --needed unace unrar zip unzip sharutils uudeview arj cabextract file-roller tar bzip2 gzip p7zip pbzip2

echo ""

# -------------------
# AUR Packages
# -------------------

echo "Installing yay"

if ! type "yay" &>/dev/null
then
        cd ~
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ~/InstallArchI3
 else
        echo "Yay installed, skipping..."
 fi

echo "Installing category System"

yay -S --noconfirm --needed downgrade                                   # Script de bash para degradar uno o más paquetes a una versión en su caché o en A.L.A.
yay -S --noconfirm --needed font-manager-git                            # FUENTE
yay -S --noconfirm --needed inxi                                        # Esta es una herramienta de información del equipo para la línea de comandos
yay -S --noconfirm --needed oxy-neon                                    # Es un tema para crear un escritorio oscuro
#yay -S --noconfirm --needed pamac-aur                                   # PAMAC es una excelente GUI de los chicos de Manjaro para manejar el gestor de paquetes pacman
yay -S --noconfirm --needed sardi-icons                                 # Conjunto de iconos
yay -S --noconfirm --needed sardi-orb-colora-variations-icons-git       # Conjunto de iconos
yay -S --noconfirm --needed surfn-icons-git                             # Conjunto de iconos
#yay -S --noconfirm --needed the_platinum_searcher-bin                   # A code search tool similar to ack
yay -S --noconfirm --needed ttf-font-awesome                            # FUENTE
yay -S --noconfirm --needed ttf-mac-fonts                               # FUENTE
yay -S --noconfirm --needed nerd-fonts-hack                             # FUENTE
#yay -S --noconfirm --needed brave-nightly-bin                          # Navegador web brave
yay -S --noconfirm --needed brave-bin
#yay -S --noconfirm --needed gksu                                        # Permite iniciar aplicaciones gráficas desde consola con otro usuario pidiendo sus datos.
yay -S --noconfirm --needed cherrytree                                  # Programa de notas offline
#yay -S --noconfirm --needed remmina-plugin-rdesktop                    # Plugin para rdesktop de remina
#yay -S --noconfirm --needed etcher-bin                                  # Etcher es una utilidad gratuita y de código abierto que se utiliza para grabar archivos de imagen como archivos .iso y .img
#yay -S --noconfirm --needed octopi                                     # Octopi es un frontend para pacman muy poderoso. Con esta aplicación podremos administrar nuestra paqueteria de forma amigables
#yay -S --noconfirm --needed sublime-text                                # Sublime Text es un editor de texto y editor de código fuente está escrito en C++ y Python para los plugins.Desarrollado originalmente como una extensión de Vim.

# these come always last
yay -S --noconfirm --needed hardcode-fixer-git                          # Este programa pretende ser una solución segura, fácil y estandarizada al problema de los iconos de aplicaciones codificados en Linux. 
sudo hardcode-fixer

echo "" 

# --------------------
# Display Manager
# --------------------

echo "Setting Display Manager"

sudo pacman -Syyuu
yay -Syyuu

sudo pacman -S --noconfirm --needed i3-gaps                     # i3-gaps is a fork of i3wm, a tiling window manager for X11
sudo pacman -S --noconfirm --needed i3blocks                    # Define bloques para la barra de estado de i3bar
yay -S --noconfirm --needed ly-git                              # Ly is a lightweight TUI (ncurses-like) display manager for Linux and BSD.

sudo systemctl enable ly.service
sudo systemctl disable getty@tty2.service

echo ""

# -------------------------
# Arch Linux Repo Distro Specific
# -------------------------

echo "DESKTOP SPECIFIC APPLICATIONS"

echo "Installing category Accessories"

sudo pacman -S xfce4-terminal --noconfirm --needed

echo "Installing category System"

sudo pacman -S arandr --noconfirm --needed                      # arandr para la configuración de la resolución de video                     
sudo pacman -S picom  --noconfirm --needed                      # Para la transparencia de la shell
sudo pacman -S dmenu  --noconfirm --needed                      # Para ejecutar o lanzar programas
sudo pacman -S feh --noconfirm --needed                         # feh es un visor de imágenes ligero dirigido principalmente a usuarios de interfaces de línea de comandos
sudo pacman -S gtop --noconfirm --needed                        # Programa de monitorización del sistema por la terminal
sudo pacman -S imagemagick --noconfirm --needed                 # ImageMagick es un conjunto de utilidades de código abierto para mostrar, manipular y convertir imágenes, capaz de leer y escribir más de 200 formatos
sudo pacman -S lxappearance-gtk3 --noconfirm --needed           # Theme switcher
sudo pacman -S lxrandr --noconfirm --needed                     # LXRandR is the standard screen manager of LXDE
sudo pacman -S playerctl --noconfirm --needed                   # Playerctl es una utilidad de línea de comandos y biblioteca para controlar reproductores multimedia que implementan la especificación de interfaz MPRIS D-Bus
sudo pacman -S xfce4-appfinder --noconfirm --needed
sudo pacman -S xfce4-power-manager --noconfirm --needed
sudo pacman -S xfce4-settings --noconfirm --needed
sudo pacman -S xfce4-notifyd --noconfirm --needed

echo ""

# ----------------------
# Aur Repo Specific
# ----------------------

echo "AUR - DESKTOP SPECIFIC APPLICATIONS "

yay -S --noconfirm --needed gtk2-perl
yay -S --noconfirm --needed perl-linux-desktopfiles
yay -S --noconfirm --needed xtitle
#yay -S --noconfirm --needed urxvt-resize-font-git
yay -S --noconfirm --needed i3exit

echo ""

# --------------------
# Fonts
# --------------------

echo "Installing fonts and themes from Arch Linux repo"

sudo pacman -S adobe-source-sans-pro-fonts --noconfirm --needed
sudo pacman -S cantarell-fonts --noconfirm --needed
sudo pacman -S noto-fonts --noconfirm --needed                          # Familia de fuentes noto, fue desarrollada por google
sudo pacman -S ttf-bitstream-vera --noconfirm --needed
sudo pacman -S ttf-dejavu --noconfirm --needed
sudo pacman -S ttf-droid --noconfirm --needed                           # Conjunto de fuentes de propósito general liberadas por google como parte de android
sudo pacman -S ttf-hack --noconfirm --needed
sudo pacman -S ttf-inconsolata --noconfirm --needed
sudo pacman -S ttf-liberation --noconfirm --needed
sudo pacman -S ttf-roboto --noconfirm --needed
sudo pacman -S ttf-ubuntu-font-family --noconfirm --needed              # Familia de fuentes de ubuntu
sudo pacman -S tamsyn-font --noconfirm --needed
sudo pacman -S breeze --noconfirm --needed
sudo pacman -S otf-hermit --noconfirm --needed          
sudo pacman -S awesome-terminal-fonts --noconfirm --needed

echo ""

# ----------------
# Pentesting
# ----------------

echo "Installing Tools for Pentesting"

# Pacman repo
sudo pacman -S --noconfirm --needed nmap
sudo pacman -S --noconfirm --needed aircrack-ng
sudo pacman -S --noconfirm --needed usbutils
sudo pacman -S --noconfirm --needed bettercap
sudo pacman -S --noconfirm --needed inetutils
sudo pacman -S --noconfirm --needed openssh
sudo pacman -S --noconfirm --needed iputils 
sudo pacman -S --noconfirm --needed traceroute 
sudo pacman -S --noconfirm --needed whois 
sudo pacman -S --noconfirm --needed dnsutils
sudo pacman -S --noconfirm --needed impacket
sudo pacman -S --noconfirm --needed hydra 
sudo pacman -S --noconfirm --needed medusa
sudo pacman -S --noconfirm --needed john 
sudo pacman -S --noconfirm --needed hashcat
sudo pacman -S --noconfirm --needed nikto
sudo pacman -S --noconfirm --needed sqlmap
sudo pacman -S --noconfirm --needed wireshark-qt 
sudo pacman -S --noconfirm --needed tcpdump
sudo pacman -S --noconfirm --needed proxychains-ng
sudo pacman -S --noconfirm --needed dsniff
sudo pacman -S --noconfirm --needed ettercap-gtk
sudo pacman -S --noconfirm --needed hping
sudo pacman -S --noconfirm --needed ngrep
sudo pacman -S --noconfirm --needed metasploit
sudo pacman -S --noconfirm --needed masscan
#sudo pacman -S --noconfirm --needed zaproxy
sudo pacman -S --noconfirm --needed smbclient
sudo pacman -S --noconfirm --needed kxmlrpcclient               # XML-RPC client library for KDE
sudo pacman -S --noconfirm --needed radare2
sudo pacman -S --noconfirm --needed parallel
sudo pacman -S --noconfirm --needed mysql
sudo pacman -S --noconfirm --needed perl-image-exiftool
sudo pacman -S --noconfirm --needed wpscan

#For windows
sudo pacman -S --noconfirm --needed nbtscan

# For Wifi
sudo pacman -S --noconfirm --needed reaver              # Reaver-WPS desempeña un ataque de fuerza bruta contra el número de pin de WiFi de un punto de acceso
sudo pacman -S --noconfirm --needed bully               # Romper claves WPA por la vulnerabilidad del WPS mediante Bully.
sudo pacman -S --noconfirm --needed macchanger          # Herramienta para cambiar la mac de la tarjeta de red
sudo pacman -S --noconfirm --needed hcxdumptool         # Pequeña herramienta para capturar paquetes de dispositivos WLAN
sudo pacman -S --noconfirm --needed hcxtools            # Un pequeño conjunto de herramientas convierte paquetes de capturas (h = hash, c = captura, convierte y calcula candidatos, x = diferentes tipos de hash) para su uso con el último hashcat o John the Ripper.

# AUR Repo
yay -S --noconfirm --needed exploit-db-git              # The Exploit Database Git Repository
#yay -S --noconfirm --needed cutycapt-qt5-git            # Una utilidad de línea de comandos basada en Qt y WebKit que captura la representación de WebKit de una página web.
#yay -S --noconfirm --needed routersploit-git            # The RouterSploit Framework is an open-source exploitation framework dedicated to embedded devices.

echo ""


# ----------------
# Personal Configuration Jaime
# ----------------

#sudo pacman -S --noconfirm --needed telegram-desktop

# Antivirus
sudo pacman -S --noconfirm --needed clamav

# Uncomplicated Firewall
sudo pacman -S --noconfirm --needed ufw

# Criptography
sudo pacman -S --noconfirm --needed gnupg               # GnuPG permite cifrar y firmar tus datos y comunicaciones, incluye un sistema versátil de gestión de claves

# Eyes
sudo pacman -S --noconfirm --needed redshift            # Ajusta la temperatura del color de tu pantalla


# Custom Loop-Man pacman

sudo pacman -S --noconfirm --needed code        # Para programar con visual-studio-code
#sudo pacman -S --noconfirm --needed meld        # Para comparar ficheros o carpetas
sudo pacman -S --noconfirm --needed xorg-xkill  # Para matar graficamente un programa
sudo pacman -S --noconfirm --needed rlwrap      # rlwrap para consola con memoria en reverse shell
sudo pacman -S --noconfirm --needed openvpn     # Cliente vpn
sudo pacman -S --noconfirm --needed openbsd-netcat # Netcat que mas me gusta de pacman
sudo pacman -S --noconfirm --needed lsd         # ls con esteroides
sudo pacman -S --noconfirm --needed bat         # cat con esteroides
sudo pacman -S --noconfirm --needed samba       # Instalar samba
sudo pacman -S --noconfirm --needed python-pipenv #Instala pipenv para crear entornos virtuales con librerias independientes de las del sistema

# Custom Loop-Man yay

yay -S --noconfirm --needed rockyou                                     # Diccionario rockyou de owasp
yay -S --noconfirm --needed samdump2                                    # Para dumpear password en claro de los ficheros sam y system

## Instalo xfreerdp

#git clone https://aur.archlinux.org/rocket-depot-git.git ~/tools/
#cd ~/tools/rocket-depot-git
#makepkg -si

## Personal ADD  UNTESTED

yay -Sy --needed acpi
yay -Sy --needed airgeddon-git 
yay -Sy --needed arp-scan
yay -Sy --needed asleap
yay -Sy --needed autopsy
yay -Sy --needed batify
yay -Sy --needed berate_ap-git
yay -Sy --needed bloodhound
yay -Sy --needed blueman
yay -Sy --needed caja-deja-dup-bzr
yay -Sy --needed caja-extensions-common
yay -Sy --needed caja-open-terminal
yay -Sy --needed caja-share 
yay -Sy --needed cbatticon
yay -Sy --needed cewl
yay -Sy --needed Cewl
yay -Sy --needed code
yay -Sy --needed crackmapexec
yay -Sy --needed crackmapexec 
yay -Sy --needed create_ap
yay -Sy --needed curl
yay -Sy --needed dhclient
yay -Sy --needed dhcpdump
yay -Sy --needed dmks
yay -Sy --needed docker
yay -Sy --needed dwdiff
yay -Sy --needed engrampa
yay -Sy --needed enum4linux
yay -Sy --needed file-roller
yay -Sy --needed freedesktop
yay -Sy --needed gnome-keyring 
yay -Sy --needed go
yay -Sy --needed gobuster
yay -Sy --needed hash-identifier
yay -Sy --needed hg
yay -Sy --needed hostapd
yay -Sy --needed hostapd-mana
yay -Sy --needed hostapd-wpe
yay -Sy --needed i3blocks
yay -Sy --needed i3status
yay -Sy --needed impacket
yay -Sy --needed java
yay -Sy --needed joplin
yay -Sy --needed keepassxc
yay -Sy --needed libnotify
yay -Sy --needed libnotify-cil
yay -Sy --needed libnotify-cil-dev
yay -Sy --needed libva
yay -Sy --needed linux
yay -Sy --needed linux-headers
yay -Sy --needed m2crypto
yay -Sy --needed mana-toolkit
yay -Sy --needed mate-monitor
yay -Sy --needed System-monitor 
yay -Sy --needed mesa
yay -Sy --needed mesa-git
yay -Sy --needed miraclecast
yay -Sy --needed miraclecast-git
yay -Sy --needed neo4j-community
yay -Sy --needed nessus
yay -Sy --needed opencl-amd
yay -Sy --needed opensc-opendnie-git
yay -Sy --needed pasystray
yay -Sy --needed pavucontrol
yay -Sy --needed pcsclite
yay -Sy --needed pcsc-tools
yay -Sy --needed pkcs11-tool
yay -Sy --needed postgresql
yay -Sy --needed pth-toolkit
yay -Sy --needed python3
yay -Sy --needed python3.8
yay -Sy --needed python-m2crypto
yay -Sy --needed r1133.d160214,
yay -Sy --needed responder
yay -Sy --needed rpcclient smbclient
yay -Sy --needed rtl8812au
yay -Sy --needed rtl8812au-dkms-git
yay -Sy --needed rtl8814au
yay -Sy --needed rtl8814au-dkms-git 
yay -Sy --needed rtl88xxau-aircrack-dkms-git
yay -Sy --needed samba
yay -Sy --needed screen
yay -Sy --needed scribus
yay -Sy --needed scrot
yay -Sy --needed smb
yay -Sy --needed smbclient
yay -Sy --needed sqlitebrowser
yay -Sy --needed sslstrip mdk4 crunch pixiewps python2-crypto --overwrite
yay -Sy --needed swig
yay -Sy --needed system-monitor
yay -Sy --needed teams
yay -Sy --needed vainfo
yay -Sy --needed wafw00f
yay -Sy --needed x11-ssh-askpass
yay -Sy --needed xterm scrot jq
yay -Sy --needed zsh
yay -Sy --needed nitrogen

# ----------------
# Personal Configuration Raul
# ----------------

sudo pacman -S --noconfirm --needed nextcloud-client  # Para matar graficamente un programa
echo "Disabling beep sound"
sudo -- sh -c 'echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf'

echo "Configuring Nice Burpsuite"
sudo -- sh -c 'echo "_JAVA_AWT_WM_NONREPARENTING=1" > /etc/environment'

# Configuration for root
echo "sudo -- sh -c 'ln -sf /home/user/.bashrc /root/.bashrc'"

## Actualizo plugins, scripts y exploits

sudo updatedb
sudo nmap --script-updatedb
sudo searchsploit -u
#sudo cve_searchsploit -u
