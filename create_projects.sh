#!/bin/bash 

rm -R build
mkdir build
cd build

ARCH=$(uname -i)
if [[ $ARCH == "aarch64" ]] 
then
echo "Creating projects on Tegra"
cmake -DCMAKE_BUILD_TYPE=Release -DCUDA_ARCH:STRING="sm_53" -G "Unix Makefiles" ..
else
echo "Creating projects on PC"
cmake -DCMAKE_BUILD_TYPE=Release -DCUDA_ARCH:STRING="sm_52" -G "Unix Makefiles" ..
fi
cd ..

