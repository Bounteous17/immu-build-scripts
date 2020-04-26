#!/bin/bash

if [[ ${EUID} -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

showUsageExample()
{
    echo "Usage example: ./make.sh /tmp/buildArchisoFolder /tmp/iso"
    exit 1
}

showErrorFolderNotFound()
{
    echo "Error: Folder $1 not found"
    exit 1
}

# Build output path
archiso_path=$1

if [ -z $archiso_path ]; then
    showUsageExample
fi

if [ ! -d $archiso_path ]; then
    showErrorFolderNotFound $archiso_path
fi

# ISO final destination
out=$2

if [ -z $out ]; then
    showUsageExample
fi

if [ ! -d $out ]; then
    showErrorFolderNotFound $out
fi

echo "Removing old build files: ${archiso_path}, ${out}"

rm -rf ${archiso_path} ${out}
cp -r /usr/share/archiso/configs/releng/ ${archiso_path}
cp -vfp ./build.sh ${archiso_path}

if [ ! -d ${out} ]; then
    mkdir -v ${out};
fi

cd ${archiso_path}
./build.sh -v