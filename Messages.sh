#! /usr/bin/env bash
lupdate-qt5 ./plasmoid -extensions qml,js -ts out.ts
lconvert-qt5 -locations relative -i out.ts -o ./po/plasma_applet_audoban.applet.playbar.pot -of pot
extractrc `find ./engine -name \*.ui -o -name \*.kcfg` > rc.cpp
xgettext -ki18n ./rc.cpp -o po/plasma_dataengine_playbar.pot
rm -f rc.cpp out.ts
