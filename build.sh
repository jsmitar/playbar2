#!/bin/bash

./formatter.sh
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DKDE_INSTALL_LIBDIR=lib64/qt5 -DCMAKE_BUILD_TYPE=Release ..
make
sudo make install
cd ..
