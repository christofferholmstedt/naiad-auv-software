#!/bin/bash

echo "####################################"
echo "# Install required packages first"
echo "# gnat-4.6 and its requirements"
echo "####################################"
echo sudo apt-get install build-essential libc6-dev gnat-4.6  libgmp-dev bison \
    flex libmpfr-dev libmpc-dev git texinfo zlib1g-dev
echo mkdir -pv $HOME/avrada-build
echo cd $HOME/avrada-build
