docker container rm $(docker container ls -aq)
docker container stop $(docker container ls -aq)