### Pgsql
``` bash 
# Make backup
kubectl exec [pod-name] -- bash -c "pg_dump -U [postgres-user] [database-name]" > database.sql
# Restore backup
cat database.sql | kubectl exec -i [pod-name] -- psql -U [postgres-user] -d [database-name]
```
