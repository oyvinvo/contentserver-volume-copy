#!/usr/bin/env bash

if [ $# -lt 1 ]
then
	echo "Usage: copy-content-server-volumes.sh username@source-server "
	exit 1
fi

# backup content server volumes (container name is csubuntu.)
ssh $1 << EOF
	mkdir backup
	docker run --rm -v ~/backup:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/thumbsrv.tar.gz /opt/dctm/product/7.3/thumbsrv/conf
	docker run --rm -v ~/backup:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/data.tar.gz /opt/dctm/data
	docker run --rm -v ~/backup:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/share.tar.gz /opt/dctm/share
	docker run --rm -v ~/backup:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/mdserverlogs.tar.gz /opt/dctm/wildfly9.0.1/server/DctmServer_MethodServer/logs
	docker run --rm -v ~/backup:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/obdc.tar.gz /opt/dctm/odbc
	docker run --rm -v ~/backup:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/xhiveconnector.tar.gz /opt/dctm/wildfly9.0.1/server/DctmServer_MethodServer/deployments/XhiveConnector.ear
	docker run --rm -v ~/backup:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/mdserverlog.tar.gz /opt/dctm/wildfly9.0.1/server/DctmServer_MethodServer/log
	docker run --rm -v ~/backup:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/dfc.tar.gz /opt/dctm/config
	docker run --rm -v ~/backup:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/mdserverconf.tar.gz /opt/dctm/mdserver_conf
	docker run --rm -v ~/backup:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/thumbwebinf.tar.gz /opt/dctm/product/7.3/thumbsrv/container/webapps/thumbsrv/WEB-INF
	docker run --rm -v ~/backup:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/dba.tar.gz /opt/dctm/dba
	docker run --rm -v ~/backup:/backup --volumes-from csubuntu debian:jessie tar -czvf /backup/xhivestorage.tar.gz /opt/dctm/xhive_storage
EOF
