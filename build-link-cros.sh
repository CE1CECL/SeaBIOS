#!/bin/bash
#
set -e
rm -rf ./out
cp configs/.config-hswbdw-box-cros .config
make EXTRAVERSION=-MrChromebox-`date +"%Y.%m.%d"`
filename="seabios-link-mrchromebox_`date +"%Y%m%d"`.bin"
#cbfstool ${filename} create -m x86 -s 0x00200000 -H $((0x200000 - 0x60)) 
cp seabios-link-empty.bin ${filename}
cbfstool ${filename} add-payload -f ./out/bios.bin.elf -n payload -b 0x0 -c lzma
cbfstool ${filename} add -f ~/dev/coreboot/blobs/mainboard/google/link/vgabios.bin -n pci8086,0166.rom -t optionrom
cbfstool ${filename} add -f ~/dev/coreboot/cbfs/bootorder.ssd -n bootorder -t raw
cbfstool ${filename} add-int -i 3000 -n etc/boot-menu-wait
cbfstool ${filename} print
md5sum ${filename} > ${filename}.md5
mv ${filename}* ~/dev/firmware/
