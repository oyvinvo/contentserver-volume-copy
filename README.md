# Migration of the docker volumes of the Content Server to a new host
This script assumes that the offical Documentum docker images is used, or atleast the naming of the volumes are the same as the official image names them.

## Description
This script migrates the docker volumes of the Documentum Content Server to a new host.

## Requirements
- The users of the source and target servers are members of the docker group.
- rsync is installed on the the computer running the script.
- Your public key is installed in the source and target server. [ssh-copy-id manual](https://linux.die.net/man/1/ssh-copy-id)

## What this script does not do
The script stops the source Content Server docker container and copies the docker volumes. The Content Server image and compose file used must be copied manually. Modifications to the compose file are probably necessary. 
The script does not delete the volumes or content server image/container on the source server.

## Usage
```
./copy-content-server-volumes.sh username@source-server username@target-server container-name repo-name
```
- username@source-server: username of a user who is member of the docker group, and name of the server running content server.
- username@target-server: username of a user who is member of the docker group, and the name of the server you want to move the content server to.
- container-name: the name of the docker container running content server today.
- repo-name: The name of the documentum repository. The name is used in the docker volumes.

