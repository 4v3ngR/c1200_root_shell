## Enabling the WDS interface without patching the DOM

*Requires a root shell on the C1200*

### Editing the profile for the device

1. In the root shell, cd to the /tmp directory
   
   ```sh
   cd /tmp
   ```

2. Dump the `profile` partition from nvwram
   
   ```sh
   nvrammanager -r profile -p profile
   ```

3. Edit the `profile` file (it should be an xml file)
   
   ```sh
   vi profile
   ```

4. Search for `wds2g_wds5g_compatible` and change the value from `no` to `yes`.

5. Also search for and edit `wds_show`. Change from `no` to `yes`.

6. Save the file.

7. Write the `profile` file back to the `profile` partition
   
   ```sh
   nvrammanager -w profile -p profile
   ```

8. Reboot the router

9. After the reboot, load the web interface and observe the WDS summary is in the advanced tab, and the settings are visibile within the advanced settings page.
