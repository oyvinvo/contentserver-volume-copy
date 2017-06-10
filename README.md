# contentserver-volume-copy
This script assumes that the offical Documentum docker images is used, or atleast the naming of the volumes are the same as the officla image names them.
I recommend copying your ssh keys to the source and target servers.
## Requirements
- The users of the source and target servers need to members of docker.
- rsync must be installed on the the computer running the script.

## Description
Script that migrates the docker volumes of the Documentum Content Server to a new host.


## Usage
./copy-content-server-volumes.sh username@source-server username@target-server 
