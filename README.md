# wildfly-datasource

## Serveur Applicatif Wildfly avec datasource Postgresql

Cette image est basée sur Wildfly 20.0.1.Final  avec driver PostgreSQL et datasource pré-configurée. 

 Au moment du build vous pouvez définir, ou surcharger au démarrage les variables suivantes :

* DB_HOST - hostname ou adresse IP
* DB_PORT - port de la base de donnée
* DB_NAME - nom de la base de donnée
* DB_USER - nom de l'utilisateur de connection à la base de donnée
* DB_PASS - mot de passe de l'utilisateur
La chaine de connection est crée sur le template suivant :`jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME` 

### Lancement
Les conteneurs peuvent être lancés individuellement avec Docker :
```
docker network create wf_pg_res
docker run -d --name postgres -p 5432:5432 --net=wf_pg_res -e POSTGRES_USER=<user> -e POSTGRES_PASSWORD=<password> postgres:<version>
docker run -d --name wildfly -p 8080:8080 --net=wf_pg_res -e DB_HOST=<fqdn-or-ip> -e DB_NAME=<postgres> -e DB_USER=<postgres> -e DB_PASS=<password> jboss/wildfly-datasource
```
 ou avec Docker-Compose :

```
# Pour demarrer :
docker-compose up -d

# Pour arrêter :
docker-compose down
```

