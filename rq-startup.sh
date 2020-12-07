#!/bin/sh

echo "Starting RQ Server..."
redis-server > redis_server.log &
echo "...done!"

echo "Starting RQ Workers..."
rq worker microblog-tasks > rq_workers.log &
echo "...done!"