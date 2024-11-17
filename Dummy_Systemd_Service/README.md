# Dummy Systemd Service

## Step 1: The `dummy.sh` Script
1. Create
```
sudo vim /usr/local/bin/dummy.sh
```
2. Add the following content
```
#!/bin/bash

while true; do
  echo "Dummy service is running..." >> /var/log/dummy-service.log
  sleep 10
done
```
3. Make the script executable
```
sudo chmod +x /usr/local/bin/dummy.sh
```

## Step 2: Create the Systemd Service File
1. Create
```
sudo vim /etc/systemd/system/dummy.service
```
2. Add the following content
```
[Unit]
Description=Dummy Service
After=network.target

[Service]
ExecStart=/usr/local/bin/dummy.sh
Restart=always
RestartSec=5
User=root
StandardOutput=append:/var/log/dummy-service.log
StandardError=append:/var/log/dummy-service.log

[Install]
WantedBy=multi-user.target
```

A short description of what the service does. Used for identification when checking the service status
`Description=Dummy Service`
Specify that the service should only start after the network has been initialized
`After=network.target`
Command to be executed to start the service
`ExecStart=/usr/local/bin/dummy.sh`
Tell systemd to automatically restart the service if it stops for any reason
`Restart=always`
Specify service to run as root user
`User=root`
Indicate that the service should be started when the system reaches the multi-user (a common system state where most non-graphical services are active)
`WantedBy=multi-user.target`

## Step 3: Enable and Start the Service
1. Reload systemd to recognize the new service
```
sudo systemctl daemon-reload
```
2. Enable the service to start on boot
```
sudo systemctl enable dummy
```
3. Start the service
```
sudo systemctl start dummy
```

## Step 4: Verify the Service
1. Check the service status
```
sudo systemctl status dummy
```
2. View the log file directly
```
sudo tail -f /var/log/dummy-service.log
```
3. Use `[journalctl](https://man7.org/linux/man-pages/man1/journalctl.1.html)` to view service logs
```
sudo journalctl -u dummy -f
```
4. Open the log file to verify that messages are being written every 10 seconds
```
sudo tail -f /var/log/dummy-service.log
```

## Step 5: Control the Service
Stop/Restart/Disable
```
sudo systemctl stop dummy
sudo systemctl restart dummy
sudo systemctl disable dummy
```

## Step 6: Test Automatic Restart
1. Simulate a failure by killing the process
```
sudo pkill -f dummy.sh
```
2. Verify that the service restarts automatically
```
sudo systemctl status dummy
```

