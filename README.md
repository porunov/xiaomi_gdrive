# Google drive loader for xiaomi smart ip camera 
Google drive loader for xiaomi smart ip camera. xiaomi_gdrive let you automatically upload your videos from xiaomi smart ip camera to your google drive account. Also it can automatically remove old files from your google drive account to prevent space exhaustion.

![ants_smart_webcam_ xiaomi](https://cloud.githubusercontent.com/assets/17673243/17768152/76d2a56a-653b-11e6-81db-522a29f9f1f2.png)

###Step-by-step instruction for installing xiaomi_gdrive

1. Turn off your camera and get microSD
2. Download xiaomi_gdrive and unzip it (https://github.com/porunov/xiaomi_gdrive/releases/download/0.0.5/xiaomi_gdrive.zip)
3. Copy next folders into your microSD:

  ```
  test
  gdrive
  ```
  
4. If you want to set the time when your GDrive can interact with the Internet (i.e. send or remove files to Google Drive) you can change change the time in GDriveAutoremover and GDriveUploader files. If you want to let the camera interact with the Internet 24 hour/day (immediately send a video after it is recorded) then skip this step. If you still want to change the time then open your GDriveUploader script and change start_time and finish_time variables to whatever you want in the next format: HH:MM:SS. To do it find the next line:

```
start_time="00:00:00"
```

and change the time in this line to whatever you want. Example 7:35:00 pm will be: 

```
start_time="19:35:00"
```

Then find the next line:

```
finish_time="23:59:59"
```

and change it to whatever you want. Example 01:00:05 am will be:

```
finish_time="01:00:05"
```

Your camera will be able to interact with the Internet from start_time to finish_time.

5. Put microSD into your camera
6. Turn on camera
7. After turnung on a camera use telnet to connect to your camera (login: root, password: 1234qwer):

  ```
  telnet {YOUR_CAMERA_IP_ADDRESS}
  Example: telnet 192.168.0.70
  ```

8. Go to the browser
9. Create your Google Drive application and OAuth keys for Google Drive API (example tutorial: http://www.iperiusbackup.net/en/how-to-enable-google-drive-api-and-get-client-credentials/)
  
  Example:
  
  1. Go to Google Api Console (https://console.developers.google.com/?hl=RU)
  2. Click "Drive API"
  3. Clieck "Create project" and create it (if don't have one)
  4. Click "Enable"
  5. Go to Credentials and add credentials to your project
    1. Where will you be calling the API from? : Other UI (e.g. Windows, CLI tool)
    2. What data will you be accessing? : User data
    3. Click "What credentials do I need?"
    4. Name your credentials as you want
    5. Product name shown to users - use any name
    6. Click "Done"
  6. Click on your credentials
  7. Save your client id and client secret

10. Go to your console back
11. Run GDriveConf to configure your Google Drive access:

  ```
  sh /home/hd1/gdrive/GDriveConf
  ```

12. Paste your client id and press enter
13. Paste your client secret and press enter
14. Copy link which you see and paste into your browser
15. Click "Accept"
16. Copy code which you see
17. Go to your console back
18. Paste your code and press enter
19. You will be suggested to see the folders. Press Enter if you want to see all folders. If you want to see only root folders type `root` and press Enter.
//Folders showing isn't fast. Wait for 5-10 seconds to see your directories.
20. You will see your folders (number of folder is on the left side)
21. Type the number of a folder and press Enter. (If you want to save videos in the root dir then just press Enter)
22. You will be asked if you want to turn on automatic remove. Press `1` and type Enter if you want. Press `0` and type Enter if you do not want. GDriveAutoremover itself will delete old files in case if your disk space overflows.
23. Reboot your camera:

  ```
  reboot
  ```

23. Done

How it works:
The script in the loop will create the same folders as in the record folder and upload videos into Google Drive. After the reboot, or failure of the Internet script continues normally send files. If you have enabled automatic remove, GDriveAutoremover will check your free space every 45 minutes. In case when disk space is not enough, the script will erase old videos (IMPORTANT: do not put anything extra in the folder which is designed for video because GDriveAutoremover can remove it if it considers that the disk space is not enough).

This scripts were tested under 1.8.5.1L firmware

Troubleshooting:

1. Your camera starts reboot from time to time. Your RAM is likely not enough. Turn off additional features which you have installed.
  1. Turn off ftp server:
  
    ```
    rm /etc/init.d/S89ftp
    ```
  
  2. Turn off HTTP server
    ```
    rm /home/web/server
    rm /home/web/record
    ```
  
  3. Turn off RTSP server
  
    ```
    rm /home/rtspsvr
    mv /home/recv_X.726 /home/recv.726
    ```
  
  4. Reboot your camera
  
    ```
    reboot
    ```

2. Check if camera can send requests to the Internet.
  
  ```
  ping -q -c2 8.8.8.8
  ping -q -c2 google.com
  ```

  if it isn't pingable then check your route table:

  ```
  route -n
  ```
  
  1. If your gateway isn't correct then add your gateway (Where 192.168.0.1 is your router IP address):
  
    ```
    my_router_ip="192.168.0.1"
    route add default gw ${my_router_ip} ra0
    ```
  
  2. To have normal gateway after reboot run all next commands:
  
    ```
    echo "#!/bin/sh" > /etc/init.d/S65route
    echo "change_def_route(){" >> /etc/init.d/S65route
    echo "route add default gw ${my_router_ip} ra0" >> /etc/init.d/S65route
    echo "}" >> /etc/init.d/S65route
    echo "change_def_route &" >> /etc/init.d/S65route
    echo "exit 0" >> /etc/init.d/S65route
    chmod +x vi /etc/init.d/S65route
    echo "${my_router_ip}" > /tmp/gw1
    ```
  
  3. Add public DNS
    
    ```
    echo "nameserver 8.8.8.8" > /var/run/dhcpcd/resolv.conf/resolv.conf
    echo "nameserver 8.8.8.8" > /etc/resolv.conf
    ```
  
  4. Reboot your camera
  
    ```
    reboot
    ```

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=HTPAA8RYN7APE&lc=UA&item_name=Developing%20open%20source%20projects&item_number=porunov_xiaomi_gdrive&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted)
