#!/bin/bash
set -e


echo "**********************************"
echo "building patex with" 
echo "$CXX using $BUILDCHAIN"
echo "FLAGS= $FLAGS"
echo "**********************************"

cd /usr/local/src/patex

if [ "$BUILDCHAIN" == "make" ] 
then
    make clean
    make -e test
    make clean
    make -e install
else

    mkdir build
    cd build
    cmake .. -DCMAKE_CXX_COMPILER=$CXX  -DWITH_TEST=$WITH_TEST
    make 
    if [ "$WITH_TEST" == "On" ]
    then
	    make test
    fi
    make install
fi

