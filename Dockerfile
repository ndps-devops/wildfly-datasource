FROM jboss/wildfly:20.0.1.Final

LABEL maintainer="ndps.devops@gmail.com"
LABEL version="1.0.0"
LABEL description="Image Docker pour Wildfly avec parametrage datasource pour PostgreSQL."

ENV WILDFLY_HOME /opt/jboss/wildfly
ENV DEPLOY_DIR ${WILDFLY_HOME}/standalone/deployments/

# Setup de la Timezone pour le serveur
ENV FR=Europe/Paris
USER root
RUN ln -snf /usr/share/zoneinfo/$FR /etc/localtime && echo $FR > /etc/timezone
USER jboss

ENV DATASOURCE_NAME PostgrePool
ENV DATASOURCE_JNDI java:jboss/datasources/PostGreDS

ENV DB_HOST localhost
ENV DB_PORT 5432
ENV DB_USER postgres
ENV DB_PASS postgres
ENV DB_NAME postgres
ENV WF_ADM_NAME admin
ENV WF_ADM_PASS admin

RUN /opt/jboss/wildfly/bin/add-user.sh -u $WF_ADM_NAME -p $WF_ADM_PASS

# Creation d'un répertoire temporaire de deploiement pour deployer les wars après la création de la source de donnée.
RUN mkdir /tmp/deployments
ENV DEPLOY_DIR /tmp/deployments

# Creation d'un repertoire temporaire pour les fichiers de configuration de Wildlfy 
RUN mkdir /tmp/jboss-cli
ENV CLI_DIR /tmp/jboss-cli

# Le script "entryPoint"
COPY startWildFlyPostgresDS.sh $WILDFLY_HOME/bin/

USER root
RUN chown jboss:jboss $WILDFLY_HOME/bin/startWildFlyPostgresDS.sh
RUN chmod 755 $WILDFLY_HOME/bin/startWildFlyPostgresDS.sh
USER jboss

# Copie du driver dans tmp
COPY postgresql-42.2.16.jar /tmp

EXPOSE 9990

ENTRYPOINT $WILDFLY_HOME/bin/startWildFlyPostgresDS.sh
