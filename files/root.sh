#!/bin/sh

# work out where we are mounted
MNT=$(readlink -f $0 | sed -e 's/\/www.*//g' -e 's/\/files.*//g')

echo "Content-type: text/html"
echo ""

echo "We are mounted on $MNT</br>"

# create our new bin directory with a new busybox
[ -d "/mnt/bin" ] || {
  echo "/mnt/bin does not exist, creating it</br/"
  
  mkdir -p /mnt/bin
  cp $MNT/files/busybox /mnt/bin/busybox
  chmod +s /mnt/bin/busybox
  /mnt/bin/busybox --install /mnt/bin/
}

# delete the root password
echo "Deleting the root password</br>"
echo "root::0:0:99999:7:::" > /tmp/shadow
grep -v ^root: /etc/shadow >> /tmp/shadow
cp /tmp/shadow /etc/shadow
rm -f /tmp/shadow

echo "updating the shell PATH env var</br>"
grep -v PATH.*mnt.bin /etc/profile > /tmp/profile
echo "export PATH=\$PATH:/mnt/bin" >> /tmp/profile
cp /tmp/profile /etc/profile
rm -f /tmp/profile

echo "Got root?</br>"

# backup / restore the dropbear keys
/etc/init.d/dropbear stop
killall -TERM dropbear

if [ -d "$MNT/dropbear" ]; then
  echo "restoring dropbear keys</br>"
  cp -a $MNT/dropbear/dropbear_* /etc/dropbear/
else
  echo "backing up dropbear keys</br>"
  mkdir "$MNT/dropbear/"
  cp /etc/dropbear/dropbear_* "$MNT/dropbear/"
fi

uci set dropbear.@dropbear[0].rsakeyfile=$MNT/dropbear/dropbear_rsa_host_key 
uci set dropbear.@dropbear[0].dsskeyfile=$MNT/dropbear/dropbear_dss_host_key 
uci_commit_flash
/etc/init.d/dropbear start

# finally redirect to the web interface
cat << EOF
</br>
Redirecting to the web interface...
<script>
  setTimeout(function() { window.location = "/" }, 2000);
</script>
EOF
