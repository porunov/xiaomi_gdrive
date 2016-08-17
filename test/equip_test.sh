#!/bin/sh

# Open Telnet

if [ ! -f "/etc/init.d/S88telnet" ]; then
    echo "#!/bin/sh" > /etc/init.d/S88telnet
    echo "telnetd &" >> /etc/init.d/S88telnet
    chmod 755 /etc/init.d/S88telnet
    /etc/init.d/S88telnet
fi

/bin/rm -R /home/hd1/test
reboot