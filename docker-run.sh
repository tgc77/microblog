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

echo "Starting Redis..."
docker run --name redis -d -p 6379:6379 redis:3-alpine
echo "...done!"

echo "Starting up microblog app..."
docker run --name microblog -d -p 8000:5000 --rm --link mysql:localhost \
    --link redis:redis-server -e REDIS_URL=redis://redis-server:6379/0 \
    -e DATABASE_URL=mysql+pymysql://microblog:db@teste@localhost/microblog \
    --link elasticsearch:elasticsearch \
    microblog:latest
echo "...done!"

echo "Running RQ Workers..."
docker run --name rq-worker -d --rm --link mysql:localhost \
    --link redis:redis-server -e REDIS_URL=redis://redis-server:6379/0 \
    -e DATABASE_URL=mysql+pymysql://microblog:db@teste@localhost/microblog \
    --link elasticsearch:elasticsearch \
    --entrypoint venv/bin/rq \
    microblog:latest worker -u redis://redis-server:6379/0 microblog-tasks
echo "...done!"