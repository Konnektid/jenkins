FROM jenkinsci/jenkins

RUN install-plugins.sh ansible

USER root
RUN apt-get update && apt-get install -y ansible

USER jenkins
