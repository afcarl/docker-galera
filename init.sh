#!/bin/bash
# init script updates the my.cnf thats a volume mounted file from host and needs to get synced via rsync if cross host
# wsrep_cluster_address=gcomm://172.17.0.27,172.17.0.28,172.17.0.30 > in my.cnf
# master:
# service mysql stop 
# service mysql start --wsrep-cluster-address=gcomm://
# slave service mysql restart
##############################
