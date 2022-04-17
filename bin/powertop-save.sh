#!/bin/sh
# Enable power savings suggested by PowerTOP
sysctl kernel.nmi_watchdog=0
sysctl vm.dirty_writeback_centisecs=1500

for i in /sys/bus/i2c/devices/i2c-*/device/power/control; do
    echo auto > $i
done

for i in /sys/bus/pci/devices/*/power/control; do
    echo auto > $i
done

for i in /sys/bus/pci/devices/*/*/power/control; do
    echo auto > $i
done

for i in /sys/block/*/device/power/control; do
    echo auto > $i
done

for i in /sys/class/scsi_host/host*/link_power_management_policy; do
    echo med_power_with_dipm > $i
done

#for i in /sys/bus/usb/devices/*/power/control; do
#    echo auto > $i
#done

for i in /sys/bus/usb/devices/*/power/wakeup; do
    echo disabled > $i
done

echo powersave > /sys/module/pcie_aspm/parameters/policy

exit 0
