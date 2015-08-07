#!/bin/bash

astyle --options='.astylerc' `find engine/ -name '*.cpp' -o -name '*.h'`
rm -v `find . -name '*.orig' -o -name '.directory' -o -name '*~'`
plasmapkg2 --remove audoban.applet.playbar

