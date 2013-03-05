#!/bin/sh

build ()
{
    local target=$1
    echo "Building $target"
	REL=crespo_devil_$(date +%Y%m%d)
	make -j4

	echo "copying modules ..."
	find . -name "*.ko" -exec cp {} release/system/lib/modules/ \; 2>/dev/null || exit 1
	echo "making zip ..."

	rm -rf release/kernel/Zimage
	mv arch/arm/boot/zImage release/kernel/
	cd release/
	zip -q -r "${REL}_$target.zip" kernel META-INF system || exit 1
	cd ..
}

make crespo_defconfig

if [ "$1" = "novoodoo" ] || [ "$1" = "" ] ; then
echo "no voodoo"
sed -i 's/^.*FB_VOODOO.*$//' .config
echo 'CONFIG_FB_VOODOO=n
CONFIG_FB_VOODOO_DEBUG_LOG=n' >> .config
build DC
fi


if [ "$1" = "voodoo" ] ; then
echo "voodoo"
sed -i 's/^.*FB_VOODOO.*$//' .config
echo 'CONFIG_FB_VOODOO=y
CONFIG_FB_VOODOO_DEBUG_LOG=n' >> .config
build VC
fi

