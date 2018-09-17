FROM grafana/grafana:latest

USER root
RUN apt-get update && apt-get install -y unzip wget

RUN apt-get install -y gnupg

# Install Nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x -o /tmp/nodesource_setup.sh
RUN bash /tmp/nodesource_setup.sh
RUN apt-get install -y nodejs

# Download the mongo plugin
RUN wget https://github.com/JamesOsgood/mongodb-grafana/archive/master.zip -O /var/lib/grafana/plugins/grafana-mongodb.zip
RUN (cd /var/lib/grafana/plugins/; unzip /var/lib/grafana/plugins/grafana-mongodb.zip)

# Install dependencies
RUN (cd /var/lib/grafana/plugins/mongodb-grafana-master; npm install)

# Installing supervisord
RUN apt-get install -y supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" && \
    chmod 777 "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS"

# COPY run.sh /run.sh
# USER grafana
ENTRYPOINT ["/usr/bin/supervisord"]