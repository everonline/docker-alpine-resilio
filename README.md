# Docker Image Content

- Alpine 3.11
- dumb-init 1.2.2-r1
- glibc 2.28-r0
- resilio-sync 2.6.4

### For security Runs Under UID/GID 1000:1000
### Configuration Under Host Volume

# Volume

- /mnt/sync - State Files / Sync Folders

# Ports

- 8888 - WebUI
- 55555 - Listening Port For Sync Traffic

# Run

    DATA_FOLDER=/path/to/data/folder/on/the/host
    WEBUI_PORT=[ port to access the webui on the host ]

    mkdir -p $DATA_FOLDER
    chown -R 1000:1000 $DATA_FOLDER

    docker run -d --name resilio \
      -p $WEBUI_PORT:8888 -p 55555:55555 \
      -v $DATA_FOLDER:/mnt/sync \
      --restart on-failure \
      tduk/resilio

# CentOS 8 SELinux 

    docker run -d --name resilio \
      -p $WEBUI_PORT:8888 -p 55555:55555 \
      -v $DATA_FOLDER:/mnt/sync:Z \
      --restart on-failure \
      tduk/resilio
