#!/bin/bash
# init script updates the my.cnf thats a volume mounted file from host and needs to get synced via rsync if cross host
# wsrep_cluster_address=gcomm://172.17.0.27,172.17.0.28,172.17.0.30 > in my.cnf
# master:
# service mysql stop 
# service mysql start --wsrep-new-cluster
# slave service mysql restart
##############################
GIPS=172.17.0.27,172.17.0.28,172.17.0.30
cat <<HERE > /etc/mysql/conf.d/cluster.cnf
[mysqld]
query_cache_size=0
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
query_cache_type=0
bind-address=$(hostname --ip-address)

# Galera Provider Configuration
wsrep_provider=/usr/lib/galera/libgalera_smm.so
#wsrep_provider_options="gcache.size=32G"

# Galera Cluster Configuration
wsrep_cluster_name="test_cluster"
wsrep_cluster_address="gcomm://$IPS,$(hostname --ip-address)"

# Galera Synchronization Congifuration
wsrep_sst_method=rsync
#wsrep_sst_auth=user:pass

# Galera Node Configuration
wsrep_node_address="$(hostname --ip-address)"
wsrep_node_name="$(hostname)"
HERE
service mysql start --wsrep-new-cluster
