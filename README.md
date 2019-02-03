# Docker Image Content

- Alpine 3.9
- dumb-init 1.2.2
- glibc 2.28.r0
- resilio-sync 2.6.3

### For security Runs Under UID/GID 1000:1000

# Volume

- /mnt/sync - State files and Sync folders

# Ports

- 8888 - Web Gui
- 55555 - Listening port For Sync Traffic
