** Images **
docker build -t kubia .
docker images
docker rmi <image name>
docker run --name kubia-container -p 8080:8080 -d kubia
docker ps
