#!/usr/bin/env bash

cd /mongodb-charts/volumes && \
  mkdir {keys,logs,db-certs,web-certs} 2>/dev/null

charts-cli startup &

pid=$!

until $(curl --output /dev/null --silent --head --fail http://localhost); do   
  printf '.'
  sleep 3
done 

stich_pid=$(pidof /mongodb-charts/bin/stitch_server)
nginx=$(pidof nginx)
supervisor=$(pidof /usr/bin/python)
node=$(pidof node)

function addUser() {
  result=$(charts-cli add-user --first-name "admin" --last-name "admin" \
  --email "${EMAIL}" --password "${PASSWORD}" \
  --role "UserAdmin")
}

addUser

until [[ "${result}" =~ "has been added with role UserAdmin" ]] ; do
  printf '.'
  sleep 1
  addUser
done

echo 'Killing startup processes...'

for p in $pid $stich_pid $nginx $supervisor $node; do
  kill $p &>/dev/null
  while kill -0 $p; do 
      sleep 1
  done
done

exec node --no-deprecation /mongodb-charts/bin/charts-cli.js startup