#!/bin/bash

tar cvf data.tar a6ab69e5-27b4-4606-8c82-1ca591333107* weather.*

pdflets_path=/home/root/.local/share/pdflets
data_path=/home/root/.local/share/remarkable/xochitl

# copy tarball
scp data.tar root@10.11.99.1:$data_path

# unpack tarball, unpack files, and reboot
ssh root@10.11.99.1 <<EOF
cd $data_path
tar xvf data.tar
rm data.tar

mv weather.service weather.path /etc/systemd/system
if [ ! -d $pdflets_path ]
then
  mkdir $pdflets_path
fi
mv weather.sh $pdflets_path

systemctl daemon-reload
systemctl enable weather.path
reboot

EOF
