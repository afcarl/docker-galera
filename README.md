docker-galera-controller
========================

A MYSQL Galera Cluster Controller

for n in {1..3}; do sudo docker run -name galera$n -i -t -d dockerimages/docker-galera:latest /bin/bash; done
