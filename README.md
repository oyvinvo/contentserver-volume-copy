# Migration of the docker volumes of the Content Server to a new host
This script assumes that the offical Documentum docker images is used, or atleast the naming of the volumes are the same as the official image names them.

## Requirements
- The users of the source and target servers are members of the docker group.
- rsync is installed on the the computer running the script.
- Your public key is installed in the source and target server. [ssh-copy-id manual](https://linux.die.net/man/1/ssh-copy-id)

## Description
This script migrates the docker volumes of the Documentum Content Server to a new host.

## What this script does not do.
The script copies the docker volumes. Stopping the src content server and copying the image and starting it on the new server is not part of the script. Yet.
The script does not delete the volumes or content server image/container on the source server.

## Usage
```
./copy-content-server-volumes.sh username@source-server username@target-server name-of-the-dctm-repo
```
