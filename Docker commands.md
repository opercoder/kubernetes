**Images**
docker build -t kubia . // Create image
docker images           // Print a list of images
docker rmi <image name> // Delete image  
**Containers**
docker run --name kubia-container -p 8080:8080 -d kubia
docker ps
