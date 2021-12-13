# Images  
1. **Create an image:**  
docker build -t kubia <path_to_Dockerfile>
2. **Print a list of images:**  
docker images           
3. **Delete the image:**  
docker rmi <image name>
4. **To make a new tag for image:**  
docker tag <old_tag> <new_image_tag>
# Containers  
1. **Run a container from the image:**  
docker run --name kubia-container -p 8080:8080 -d kubia  
2. **Print running containers:**  
docker ps  
3. **Print all containers, include stopped:**  
docker ps -a
4. **Show additional information about container:**  
docker inspect <container name>
5. **Run bash into the existing container:**  
docker exec -ti <container name> bash
6. **Stop the container:**  
docker stop <container name>
7. **Delete the container:**  
docker rm <container name>
# Docker Hub
1. **Login to Docker Hub:**  
docker login
2. **Send the image to Docker Hub:**  
docker push <image_tag>
