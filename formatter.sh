#!/bin/bash

astyle --options='.astylerc' `find engine/ -name '*.cpp' -o -name '*.h'`
rm `find . -name '*.orig' -o -name '.directory' -o -name '*~'`
