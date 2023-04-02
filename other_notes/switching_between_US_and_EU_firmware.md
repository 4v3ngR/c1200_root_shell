## Switching bewteen US and EU firmware

*Requires a root shell on the C1200*

### Editing the product info for the device

1. In the root sheel, cd to the /tmp directory
   
   ```sh
   cd /tmp
   ```

2. Dump the `product-info` partition from nvram
   
   ```sh
   nvrammanager -r product-info -p product-info
   ```

3. Edit the `product-info` file
   
   ```sh
   vi product-info
   ```

4. Locate the `special_id` and edit the value to match the firmware you wish to write:
   
   * US: 55530000
   * EU: 45550000

5. Save the file

6. Write the `product-info` file back to the `product-info` partition
   
   ```sh
   nvrammanager -w product-info -p product-info
   ```

7. Reboot the router

8. After the reboot, load the web interface and go to the firmware update page

9. Upload the desired firmware, the router should now successfully update the firmware
