#!/bin/sh
#
# prefix sudo if user requires root access
#

#
# variable
# sleep in seconds
intSleep=5

#
# assert network
docker network ls | grep -q "objNet"
if [ $? -ne 0 ]; then
  echo 'network not found. Add network'
  docker network create objNet
else
  echo 'network found. No changes made.'
fi

#
# assert db exists
docker ps -a | grep -q "mysql"
if [ $? -ne 0 ]; then
	echo 'db not found. Add db.'
  #
  # mandatory --env MYSQL_ROOT_PASSWORD=my-secret-pw (unless MYSQL_ALLOW_EMPTY_PASSWORD=yes)
  docker run --name mysql -v /root/tinode/mysql:/var/lib/mysql:rw --network objNet --restart always --env MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql:5.7
  #
  # assert db is running
  until docker exec -it mysql mysqladmin ping --silent | grep -q "mysqld is alive"
  do
    echo "waiting for db container..."
    sleep ${intSleep}
  done
else
	echo 'db found. No changes made.'
fi

#
# output
echo '------------------------------------------'
echo 'Check whether the database created or not?'
echo '------------------------------------------'
docker exec -it mysql mysqladmin ping --silent
