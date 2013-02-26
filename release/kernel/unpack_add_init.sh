#!/tmp/busybox sh
cd /tmp
mkdir ramdisk
cd ramdisk
/tmp/busybox gzip -dc ../boot.img-ramdisk.gz | /tmp/busybox cpio -i

if [ -z `/tmp/busybox grep mtp init.herring.usb.rc` ]; then
/tmp/busybox echo -e "\non property:sys.usb.config=mtp\n"\
"     write /sys/class/android_usb/android0/enable 0\n"\
"     write /sys/class/android_usb/android0/idVendor 04e8\n"\
"     write /sys/class/android_usb/android0/idProduct 685c\n"\
"     write /sys/class/android_usb/android0/functions \$sys.usb.config\n"\
"     write /sys/class/android_usb/android0/enable 1\n"\
"     setprop sys.usb.state \${sys.usb.config}\n\n"\
"on property:sys.usb.config=mtp,adb\n"\
"     write /sys/class/android_usb/android0/enable 0\n"\
"     write /sys/class/android_usb/android0/idVendor 04e8\n"\
"     write /sys/class/android_usb/android0/idProduct 6860\n"\
"     write /sys/class/android_usb/android0/functions \$sys.usb.config\n"\
"     write /sys/class/android_usb/android0/enable 1\n"\
"     start adbd\n"\
"     setprop sys.usb.state \${sys.usb.config}\n\n"\
"on property:sys.usb.config=ptp\n"\
"     write /sys/class/android_usb/android0/enable 0\n"\
"     write /sys/class/android_usb/android0/idVendor 04e8\n"\
"     write /sys/class/android_usb/android0/idProduct 6865\n"\
"     write /sys/class/android_usb/android0/functions \$sys.usb.config\n"\
"     write /sys/class/android_usb/android0/enable 1\n"\
"     setprop sys.usb.state \${sys.usb.config}\n\n"\
"on property:sys.usb.config=ptp,adb\n"\
"     write /sys/class/android_usb/android0/enable 0\n"\
"     write /sys/class/android_usb/android0/idVendor 04e8\n"\
"     write /sys/class/android_usb/android0/idProduct 6866\n"\
"     write /sys/class/android_usb/android0/functions \$sys.usb.config\n"\
"     write /sys/class/android_usb/android0/enable 1\n"\
"     start adbd\n"\
"     setprop sys.usb.state \${sys.usb.config}\n\n" >> init.herring.usb.rc
fi 

/tmp/busybox sh -c "/tmp/busybox find . | /tmp/busybox cpio -o -H newc | /tmp/busybox gzip > ../boot.img-ramdisk-new.gz"
cd ../
