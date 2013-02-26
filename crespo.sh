#!/bin/sh

if [ "$1" = "novoodoo" ]; then
make crespo_defconfig
echo "no voodoo"
REL=crespo_devil_$(date +%Y%m%d)
sed -i 's/^.*FB_VOODOO.*$//' .config
echo 'CONFIG_FB_VOODOO=n
CONFIG_FB_VOODOO_DEBUG_LOG=n' >> .config

make -j4

find . -name "*.ko" -exec cp {} release/system/lib/modules/ \; 2>/dev/null || exit 1

rm -rf release/kernel/Zimage
mv arch/arm/boot/zImage release/kernel/
cd release/kernel
zip -q -r "${REL}.zip" kernel META-INF system || exit 1
fi

if [ "$1" = "voodoo" ] ; then
make crespo_defconfig
echo "voodoo"
REL=crespo_devil_vc_$(date +%Y%m%d)
sed -i 's/^.*FB_VOODOO.*$//' .config
echo 'CONFIG_FB_VOODOO=y
CONFIG_FB_VOODOO_DEBUG_LOG=n' >> .config

make -j4

echo "copying modules ..."
find . -name "*.ko" -exec cp {} release/system/lib/modules/ \; 2>/dev/null || exit 1
echo "making zip ..."

rm -rf release/kernel/Zimage
mv arch/arm/boot/zImage release/kernel/
cd release/
zip -q -r "${REL}.zip" kernel META-INF system || exit 1
fi



