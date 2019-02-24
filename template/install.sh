#!/bin/bash

tar cvf data.tar UUID* TEMPLATE.*

pdflets_path=/home/root/.local/share/pdflets
data_path=/home/root/.local/share/remarkable/xochitl

# copy tarball
scp data.tar root@10.11.99.1:$data_path

# unpack tarball, unpack files, and reboot
ssh root@10.11.99.1 <<EOF
cd $data_path
tar xvf data.tar
rm data.tar

mv TEMPLATE.service TEMPLATE.path /etc/systemd/system
if [ ! -d $pdflets_path ]
then
  mkdir $pdflets_path
fi
mv TEMPLATE.sh $pdflets_path

systemctl daemon-reload
systemctl enable TEMPLATE.path
# this is critical so that xochitl generates the missing files
reboot

EOF
