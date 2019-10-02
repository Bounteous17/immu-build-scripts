#!/bin/bash

if [[ ${EUID} -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

archiso_path=.archlive
out=out

echo "Removing old build files: ${archiso_path}, ${out}"
rm -rf ${archiso_path} ${out}
cp -r /usr/share/archiso/configs/releng/ ${archiso_path}
cp -vfp ./build.sh ${archiso_path}

if [ ! -d ${out} ]; then
    mkdir -v ${out};
fi

cd ${archiso_path}
./build.sh -v