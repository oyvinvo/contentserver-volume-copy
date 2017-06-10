# Migration of the docker volumes of the Content Server to a new host
This script assumes that the offical Documentum docker images is used, or atleast the naming of the volumes are the same as the officla image names them.
I recommend copying your ssh keys to the source and target servers.

## Requirements
- The users of the source and target servers need to members of docker.
- rsync must be installed on the the computer running the script.

## Description
This script migrates the docker volumes of the Documentum Content Server to a new host.

## What this script does not do.
The script copies the docker volumes. Stopping the src content server and copying the image and starting it on the new server is not part of the script. Yet.
The script does not delete the volumes or content server image/container on the source server.

## Usage
```
./copy-content-server-volumes.sh username@source-server username@target-server name-of-the-dctm-repo
```
