# Docker Image Content

- Alpine 3.9
- dumb-init 1.2.2
- glibc 2.28.r0
- resilio-sync 2.6.3

### For security Runs Under UID/GID 1000:1000

# Volume

- /mnt/sync - State Files / Sync Folders

# Ports

- 8888 - Web Gui
- 55555 - Listening Port For Sync Traffic

# Run 

> docker run -d --name $name -p 8888:8888 -p 55555:55555 -v $datafolder:/mnt/sync:Z --restart on-failure resilio

- chown -R 1000:1000 $datafolder (Host Folder)
- :Z - SELinux Permission (CentOS 7 Host)
