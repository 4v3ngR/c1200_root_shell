## Easily get a root shell on a Archer C1200 router


#### WARNING: if you perform this process and then remove the usb, the router will probably not operate as expected.

### prepare the usb

The usb drive will eventually store the dropbear keys as well as the files for the web interface.

1. Format a usb drive with a DOS (vfat) partition
2. Copy the files directory to the usb drive
3. Insert the usb drive into the router

### Getting ssh access

1. Log into the web interface of the router
2. Save a backup of the configuration to your computer
3. Use the decode.sh script in the config directory to extract the files from the backup
4. Edit the ori-backup-user-config.bin file (in the directory specified above)
5. Locate the `<dropbear>` entry
6. Ensure the configuration resembles the following:
```xml
<dropbear>
<dropbear>
<RootPasswordAuth>on</RootPasswordAuth>
<Port>22</Port>
<SysAccountLogin>off</SysAccountLogin>
<RemoteSSH>on</RemoteSSH>
<PasswordAuth>on</PasswordAuth>
</dropbear>
</dropbear>
```
7. Save the changes
8. Use the encode.sh script to build a new configuration backup file
9. In the web interface of the router, restore the new configuration
10. Wait for the router to reboot

### Bootstrapping the usb

1. Log into the router using ssh (you may need to provide a deprecated key algorithm). For example:
```sh
ssh -oHostKeyAlgorithms=+ssh-rsa -oKexAlgorithms=+diffie-hellman-group1-sha1 admin@192.168.0.1
```
2. Use the same password as the web interface login
3. Once you're logged into the shell, go to the root directory of the usb drive (prepared and installed above)
```sh
cd /mnt/sda1
```
4. Using the `ls` command, you should be able to see the files directory (created above), enter it.
```
cd files
```
5. Execute the bootstrap.sh. This script will copy the contents of the `/www` directory to the usb as well as copy the root.sh file to the cgi-bin directory.
6. Exit the ssh session.

### Configuring the web server

1. Edit the configuration again
2. Locate the `uhttpd` section, then locate the `home` property within
3. Change the value in the `home` property from `/www` to the www directory on the usb. eg:
```xml
<home>/mnt/sda1/www</home>
```
4. Create a new configuration backup bin file and then restore the configuration in the router
5. Wait for the router to reboot.
6. Load the `/cgi-bin/root.sh` url in your web browser. eg:
```
http://192.168.0.1/cgi-bin/root.sh
```
7. Once complete, your browser will be redirected to the login screen of the router.
8. If all went well, you can now connect with ssh (as above)
9. Once logged in, the `su` command is now available in the PATH.
```sh
su -
```

Note:
* The router had an annoying issue where the sha fingerprint for ssh would change every time the device rebooted. The root.sh script moves the keys and reconfigures dropbear to use the persistent files.
* By default, the root password is disabled - so it is not possible to log in, the root.sh script removes the lock on the root account and removes the password. If you want the root password to match the admin password, log in as root, get the contents of the /etc/shadow file for the admin user (specifically the hash) and then edit the root.sh to include the same has for the root user.
* The changes to the PATH and the password are done to files in the ram disk, so they're reset upon each boot. As such, the root.sh url (above) needs to be run to enable root access.
* Restoring the originally downloaded configuration file will revert the web server and dropbear changes. Effectively removing all the patches.
* This has been made possible by the wealth of information on the openwrt forum - check it out
