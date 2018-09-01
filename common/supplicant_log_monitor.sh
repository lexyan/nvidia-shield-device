#!/system/bin/sh

#supplicant log file containg all the logs. size=5Mb
#dd if=/dev/zero of=/data/misc/wifi/supplicant.log  bs=1024k  count=5
touch /data/misc/wifi/supplicant.log
touch /data/misc/wifi/supplicant_old.log
chmod 0660 /data/misc/wifi/supplicant.log
chmod 0660 /data/misc/wifi/supplicant_old.log
chown system:wifi /data/misc/wifi/supplicant.log
chown system:wifi /data/misc/wifi/supplicant_old.log
FILESIZE=0
FILENAME=/data/misc/wifi/supplicant.log
while true
do
FILESIZE=$(stat -c%s "$FILENAME")
if [ "$FILESIZE" -gt 10000000 ]; then
    /system/bin/log -t "supplicant_log_monitor" -p i "Taking backup of log file"
    cp /data/misc/wifi/supplicant.log /data/misc/wifi/supplicant_old.log
    truncate -s 0 /data/misc/wifi/supplicant.log
fi
sleep 300
done
