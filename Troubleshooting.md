### If you can't get access to your pods by service:
1. Check connect to the ClusterIP from inside, not outside.
2. Don't try to ping the IP-address of your service for checking it access.  
Service's IP is a virtual address. Ping doesn't work with it.
3. Inspect that check of readiness is done successful. Otherwise the pod isn't a part of the service.
4. For checking thap the pod is a part of a service inspect an appropriative object Endpoints with the commands: *kubectl get endpoints*.
5. If you can't get access to a service with FQDN, check can you get access to the service  with his ClusterIP instead of FQDN.
6. Check that you connect to the port provided by a service, not a pod's port.
7. Try to connect directly to a pod's IP-address. Thus you will check that the pod get connections on a right port.
8. If you can't get acces to your application even by the IP-address, check that your application doesn't open only for localhost.
