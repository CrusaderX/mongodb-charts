#!/usr/bin/env bash

mongod --fork --syslog --replSet rs0

mongo --quiet --eval "rs.initiate({_id:'rs0', members: [{'_id':1, 'host':'mongo:27017'}]});"
mongo --quiet --eval "while(true) { if (rs.status().ok) break; sleep(1000) };"

mongod --shutdown

exec mongod --replSet rs0 --smallfiles --bind_ip_all --quiet