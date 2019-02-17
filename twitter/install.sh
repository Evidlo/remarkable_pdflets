#!/bin/bash

tar cvf data.tar 72cb311d-38d6-4518-a5dc-26cb1efaecd1* twitter.*

pdflets_path=/home/root/.local/share/pdflets
data_path=/home/root/.local/share/remarkable/xochitl

# copy tarball
scp data.tar root@10.11.99.1:$data_path

# unpack tarball, unpack files, and reboot
ssh root@10.11.99.1 <<EOF
cd $data_path
tar xvf data.tar
rm data.tar

mv twitter.service twitter.path /etc/systemd/system
if [ ! -d $pdflets_path ]
then
  mkdir $pdflets_path
fi
mv twitter.sh $pdflets_path

systemctl daemon-reload
systemctl enable twitter.path
reboot

EOF
