# Images  
1. **Create an image:**  
docker build -t kubia <path_to_Dockerfile>
2. **Print a list of images:**  
docker images           
3. **Delete the image:**  
docker rmi <image name>  
# Containers  
1. **Run a container from the image:**  
docker run --name kubia-container -p 8080:8080 -d kubia  
2. **Print running containers:**  
docker ps  
3. **Show additional information about container:**  
docker inspect <container name>
