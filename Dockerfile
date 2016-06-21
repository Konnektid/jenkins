FROM jenkinsci/jenkins

# Install tools
USER root

RUN \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs build-essential

RUN \
    apt-get update && \
    apt-get install -y software-properties-common gcc make build-essential libssl-dev libffi-dev python-dev && \
    apt-get install -y python-setuptools && \
    easy_install pip && \
    pip install ansible

# Fix a bug in Ansible pip install => https://github.com/ansible/ansible/issues/16015
RUN pip install -U distribute

USER jenkins

# Install plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
