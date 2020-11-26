#!/bin/sh

echo "Starting up mysql..."
docker run --name mysql -d -e MYSQL_RANDOM_ROOT_PASSWORD=yes \
    -e MYSQL_DATABASE=microblog -e MYSQL_USER=microblog \
    -e MYSQL_PASSWORD=db@teste \
    mysql/mysql-server:latest
echo "...done!"

echo "Starting up searchengine..."
docker run --name elasticsearch -d -p 9200:9200 -p 9300:9300 --rm \
    -e "discovery.type=single-node" \
    docker.elastic.co/elasticsearch/elasticsearch-oss:7.6.2
echo "...done!"

echo "Starting up microblog app..."
docker run --name microblog -d -p 8000:5000 --rm --link mysql:localhost \
    -e DATABASE_URL=mysql+pymysql://microblog:db@teste@localhost/microblog \
    --link elasticsearch:elasticsearch \
    microblog:latest
echo "...done!"