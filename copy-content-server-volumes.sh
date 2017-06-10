#!/usr/bin/env bash

if [ $# -lt 3 ]
then
	echo "Usage: copy-content-server-volumes.sh username@source-server username@target-server dctm-repo-name"
	exit 1
fi

# create uuid for tmp folder
UUID=$(cat /proc/sys/kernel/random/uuid)

# backup content server volumes (container name is csubuntu.)
ssh $1 << EOF
	mkdir $UUID
	docker run --rm -v ~/$UUID:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/thumbsrv.tar.gz /opt/dctm/product/7.3/thumbsrv/conf
	docker run --rm -v ~/$UUID:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/data.tar.gz /opt/dctm/data
	docker run --rm -v ~/$UUID:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/share.tar.gz /opt/dctm/share
	docker run --rm -v ~/$UUID:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/mdserverlogs.tar.gz /opt/dctm/wildfly9.0.1/server/DctmServer_MethodServer/logs
	docker run --rm -v ~/$UUID:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/obdc.tar.gz /opt/dctm/odbc
	docker run --rm -v ~/$UUID:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/xhiveconnector.tar.gz /opt/dctm/wildfly9.0.1/server/DctmServer_MethodServer/deployments/XhiveConnector.ear
	docker run --rm -v ~/$UUID:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/mdserverlog.tar.gz /opt/dctm/wildfly9.0.1/server/DctmServer_MethodServer/log
	docker run --rm -v ~/$UUID:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/dfc.tar.gz /opt/dctm/config
	docker run --rm -v ~/$UUID:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/mdserverconf.tar.gz /opt/dctm/mdserver_conf
	docker run --rm -v ~/$UUID:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/thumbwebinf.tar.gz /opt/dctm/product/7.3/thumbsrv/container/webapps/thumbsrv/WEB-INF
	docker run --rm -v ~/$UUID:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/dba.tar.gz /opt/dctm/dba
	docker run --rm -v ~/$UUID:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/xhivestorage.tar.gz /opt/dctm/xhive_storage
EOF

# copy backups from source to target server
rsync -r -P $1:./$UUID ./
rsync -r -P ./$UUID $2:./


# create the empty volumes on the new host
ssh $2 << EOF
	docker volume create --name dctmcs_${3}_Thumbnail_Server_conf
	docker volume create --name dctmcs_${3}_data
	docker volume create --name dctmcs_${3}_share
	docker volume create --name dctmcs_${3}_mdserver_logs
	docker volume create --name dctmcs_${3}_odbc
	docker volume create --name dctmcs_${3}_XhiveConnector
	docker volume create --name dctmcs_${3}_mdserver_log
	docker volume create --name dctmcs_${3}_dfc
	docker volume create --name dctmcs_${3}_mdserver_conf
	docker volume create --name dctmcs_${3}_Thumbnail_Server_webinf
	docker volume create --name dctmcs_${3}_dba
	docker volume create --name dctmcs_${3}_xhive_storage
EOF

# restore the backups into the newly created volumes on the new server.
ssh $2 << EOF
	docker run --rm -v dctmcs_${3}_Thumbnail_Server_conf:/opt -v ~/$UUID:/backup debian:jessie tar zxvf /backup/thumbsrv.tar.gz
	docker run --rm -v dctmcs_${3}_data:/opt -v ~/$UUID:/backup debian:jessie tar zxvf /backup/data.tar.gz
	docker run --rm -v dctmcs_${3}_share:/opt -v ~/$UUID:/backup debian:jessie tar zxvf /backup/share.tar.gz
	docker run --rm -v dctmcs_${3}_mdserver_logs:/opt -v ~/$UUID:/backup debian:jessie tar zxvf /backup/mdserverlogs.tar.gz
	docker run --rm -v dctmcs_${3}_odbc:/opt -v ~/$UUID:/backup debian:jessie tar zxvf /backup/obdc.tar.gz
	docker run --rm -v dctmcs_${3}_XhiveConnector:/opt -v ~/$UUID:/backup debian:jessie tar zxvf /backup/xhiveconnector.tar.gz
	docker run --rm -v dctmcs_${3}_mdserver_log:/opt -v ~/$UUID:/backup debian:jessie tar zxvf /backup/mdserverlog.tar.gz
	docker run --rm -v dctmcs_${3}_dfc:/opt -v ~/$UUID:/backup debian:jessie tar zxvf /backup/dfc.tar.gz
	docker run --rm -v dctmcs_${3}_mdserver_conf:/opt -v ~/$UUID:/backup debian:jessie tar zxvf /backup/mdserverconf.tar.gz
	docker run --rm -v dctmcs_${3}_Thumbnail_Server_webinf:/opt -v ~/$UUID:/backup debian:jessie tar zxvf /backup/thumbwebinf.tar.gz
	docker run --rm -v dctmcs_${3}_dba:/opt -v ~/$UUID:/backup debian:jessie tar zxvf /backup/dba.tar.gz
	docker run --rm -v dctmcs_${3}_xhive_storage:/opt -v ~/$UUID:/backup debian:jessie tar zxvf /backup/xhivestorage.tar.gz
EOF

# clean up local, source and target backups.
rm -rf ./$UUID
ssh $1 rm -rf ./$UUID
ssh $2 rm -rf ./$UUID

echo "phew, I managed to migrate the volmes from ${1} to ${2}. Please verify that everything is a okay before you do something you regret."
