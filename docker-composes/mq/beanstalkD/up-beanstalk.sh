#!/bin/bash

#10 MB max job
docker run -d -p 11300:11300 --name beanstalkd wolfdeng/beanstalkd
docker run -d -p 2080:2080 --link beanstalkd:beanstalkd schickling/beanstalkd-console

docker exec -it beanstalkd beanstalkd -h