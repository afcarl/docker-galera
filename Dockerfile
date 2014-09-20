FROM ubuntu:14.04
MAINTAINER http://github.com/dockerimages/docker-galera
# dockerimages/docker-galera-controller:latest git://github.com/dockerimages/docker-galera-controller
RUN sudo apt-get update \
 && sudo apt-get install python-software-properties \
 && apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A \
 && sed -i '/repo.percona.com/d'  /etc/apt/sources.list \
 && sh -c 'echo "deb http://repo.percona.com/apt trusty main" >> /etc/apt/sources.list' \
 && sh -c 'echo "deb-src http://repo.percona.com/apt trusty main" >> /etc/apt/sources.list' \
 && apt-get -q -y update
RUN LC_ALL=en_US.utf8 DEBIAN_FRONTEND=noninteractive apt-get \
    -o Dpkg::Options::='--force-confnew' -qqy \
    install nano wget psmisc libdbi-perl libdbd-mysql-perl \
    libwrap0 perl libaio1 mysql-client percona-xtrabackup \
    libssl0.9.8 libssl1.0.0 rsync netcat
RUN wget --no-check-certificate https://launchpad.net/codership-mysql/5.5/5.5.34-25.9/+download/mysql-server-wsrep-5.5.34-25.9-amd64.deb \
 && wget --no-check-certificate https://launchpad.net/galera/2.x/25.2.8/+download/galera-25.2.8-amd64.deb
RUN dpkg -i galera-25.2.8-amd64.deb
RUN dpkg -i mysql-server-wsrep-5.5.34-25.9-amd64.deb \
 && echo "[mysqld] \n\
wsrep_provider=/usr/lib/galera/libgalera_smm.so \n\
wsrep_cluster_address=gcomm:// \n\
wsrep_sst_method=rsync \n\
wsrep_cluster_name=galera_cluster \n\
binlog_format=ROW \n\
default_storage_engine=InnoDB \n\
innodb_autoinc_lock_mode=2 \n\
innodb_locks_unsafe_for_binlog=1" > /etc/mysql/my.cnf
EXPOSE 3306 4444 4567 4568
