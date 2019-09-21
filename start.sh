#!/bin/bash
archiso_path=.archlive
work=work
out=out

rm -rfv ${archiso_path} ${work}
cp -r /usr/share/archiso/configs/releng/ ${archiso_path}
cp -vfp ./build.sh ${archiso_path}

if [ ! -d ${out} ]; then
    mkdir -v ${out};
fi

cd ${archiso_path}
./build.sh -v