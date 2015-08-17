#!/bin/bash -x

set +e

VERSION=$(wget "http://www.libreoffice.org/download/libreoffice-fresh/" -O - | grep -o -e "/dl/src/.*/all/" | cut -d "/" -f 4 | head -n 1)
OOODOWNLOADLINK="http://download.documentfoundation.org/libreoffice/stable/$VERSION/deb/x86_64/LibreOffice_$VERSION_Linux_x86-64_deb.tar.gz"

mkdir -p ./ooo/ooo.AppDir
cd ./ooo

wget -c "$OOODOWNLOADLINK"

tar xfvz *.tar.gz
# rm *.tar.gz

cd ooo.AppDir/

find ../ -name *.deb -exec dpkg -x \{\} . \;

find . -name startcenter.desktop -exec cp \{\} . \;

find -name *startcenter.png -path *hicolor*48x48* -exec cp \{\} . \;

BINARY=$(cat *.desktop | grep "Exec=" | head -n 1 | cut -d "=" -f 2 | cut -d " " -f 1)

# sed -i -e 's|/opt|../opt|g' ./usr/bin/$BINARY
cd usr/bin/
rm ./$BINARY
find ../../opt -name soffice -path *program* -exec ln -s \{\} ./$BINARY \;
cd ../../

# (64-bit)
wget -c "https://downloads.sourceforge.net/project/portable/64bit/AppRun"
# or (32-bit)
wget -c "https://downloads.sourceforge.net/project/portable/AppRun"

chmod a+x ./AppRun

# Try to run ./AppRun

cd ..

# (64-bit)
wget -c "https://downloads.sourceforge.net/project/portable/64bit/AppImageAssistant%200.9.3-64bit"
# or (32-bit)
wget -c "http://downloads.sourceforge.net/project/portable/AppImageAssistant%200.9.3"

chmod a+x ./AppImageAssistant*
./AppImageAssistant* ./ooo.AppDir/ ooo.AppImage
