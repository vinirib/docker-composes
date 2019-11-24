docker container rm $(docker container ls -aq)
docker container stop $(docker container ls -aq)
#docker rm -vf $(docker ps -a -q)
#docker rmi -f $(docker images -a -q)