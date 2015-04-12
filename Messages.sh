#! /usr/bin/env bash
extractrc `find ./engine -name \*.rc -o -name \*.ui -o -name \*.kcfg` >> rc.cpp
xgettext --force-po `find ./plasmoid ./engine -name \*.js -o -name \*.cpp` \
rc.cpp -o ./po/plasma_applet_audoban.playbar.pot
rm -f rc.cpp
