### If you can't get access to your pods by service:
1. Check connect to the ClusterIP from inside, not outside.
2. Don't try to ping the IP-address of your service for checking it access.  
Service's IP is a virtual address. Ping doesn't work with it.
