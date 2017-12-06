#!/bin/bash

# *** Script to compile and install Dream DRM receiver software on Ubuntu
# *** and other APT based distros.
# *** More at: http://onetransistor.blogspot.com/2015/12/compile-install-dream-drm-linux.html
# *** based on instructions at: http://drm.sourceforge.net/wiki/index.php/Building_on_apt_based_distros

QMAKE_EXEC=qmake
#-qt4
MAKE_ARGS=-j3

# 1. Install required dependencies
sudo apt install libhamlib2 libqwt6abi1 
sudo apt install g++ unzip make qt4-dev-tools automake libtool libtool-bin libqtwebkit-dev libqtwebkit4 libqt5webkit5-dev libpulse-dev libhamlib-dev libfftw3-dev libqwt-dev libsndfile1-dev zlib1g-dev libgl1-mesa-dev libqt4-opengl-dev

# 2. Build and install FAAD2 library

wget http://downloads.sourceforge.net/faac/faad2-2.7.tar.gz
tar zxf faad2-2.7.tar.gz
cd faad2-2.7
. bootstrap
./configure --enable-shared --without-xmms --with-drm --without-mpeg4ip
make $MAKE_ARGS
sudo cp include/faad.h include/neaacdec.h /usr/include
sudo cp libfaad/.libs/libfaad.so.2.0.0 /usr/local/lib/libfaad2_drm.so.2.0.0
sudo ln -s /usr/local/lib/libfaad2_drm.so.2.0.0 /usr/local/lib/libfaad2_drm.so.2
sudo ln -s /usr/local/lib/libfaad2_drm.so.2.0.0 /usr/local/lib/libfaad2_drm.so
cd ..

# 3. Build and install FAAC library

wget http://downloads.sourceforge.net/faac/faac-1.28.tar.gz
tar zxf faac-1.28.tar.gz
cd faac-1.28
. bootstrap
./configure --with-pic --enable-shared --without-mp4v2 --enable-drm
make $MAKE_ARGS
sudo cp include/faaccfg.h  include/faac.h /usr/include
sudo cp libfaac/.libs/libfaac.so.0.0.0 /usr/local/lib/libfaac_drm.so.0.0.0
sudo ln -s /usr/local/lib/libfaac_drm.so.0.0.0 /usr/local/lib/libfaac_drm.so.0
sudo ln -s /usr/local/lib/libfaac_drm.so.0.0.0 /usr/local/lib/libfaac_drm.so
cd ..

# 4. Build and install Dream
# Follow this https://sourceforge.net/p/drm/wiki/Build%20on%20Ubuntu/
#Install build tools

sudo apt-get install g++ unzip make subversion

#Install libraries
#14.04 LTS
#sudo apt-get install libpulse-dev libhamlib-dev fftw3-dev libqwt-dev libpcap-dev libsndfile-dev

#16.04 LTS

sudo apt-get install qt5-default libqt5webkit5-dev libqt5svg5-dev libqwt-qt5-dev
sudo apt-get install libpulse-dev libhamlib-dev fftw3-dev libpcap-dev libsndfile-dev libfaad-dev

#Get the dream sources
#You can download releases from the files area. The following gets the head of the subverision reporsitory

svn checkout svn://svn.code.sf.net/p/drm/code/dream dream

#Building

#This should now be just:

 cd dream
 qmake
 make
 sudo cp dream /usr/local/bin/dream

#wget http://downloads.sourceforge.net/drm/dream-2.1.1-svn808.tar.gz
#tar zxf dream-2.1.1-svn808.tar.gz
#cd dream
#sed -i -- 's#$$OUT_PWD#/usr#g' dream.pro
#sed -i -- 's#faad_drm#faad2_drm#g' dream.pro
#$QMAKE_EXEC
#make $MAKE_ARGS
#sudo cp dream /usr/local/bin/dream
#sudo cp src/GUI-QT/res/MainIcon.svg /usr/share/icons/dream.svg
#printf "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Dream\nComment=Software Digital Radio Mondiale Receiver\nTryExec=/usr/local/bin/dream\nExec=/usr/local/bin/dream\nIcon=dream.svg\nCategories=Audio;AudioVideo;Science;Electronics\n" | tee dream.desktop
#cp dream.desktop ~/.local/share/applications/dream.desktop
#cd ..
#sudo ldconfig

# 5. Cleanup

#rm dream-2.1.1-svn808.tar.gz
rm faac-1.28.tar.gz
rm faad2-2.7.tar.gz
rm -rf ./dream
rm -rf ./faac-1.28
rm -rf ./faad2-2.7

# Optional: uncomment to remove dev libs
#sudo apt -y purge qt4-dev-tools automake libtool libtool-bin libqt5webkit5-dev libpulse-dev libhamlib-dev libfftw3-dev libqwt-dev libsndfile-dev
#sudo apt -y autoremove
