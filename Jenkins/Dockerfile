FROM jenkins/jenkins:2.506

USER root

# Install sudo + Python venv tooling
RUN apt-get update && \
    apt-get install -y sudo python3-venv

# Create isolated venv for latest Ansible
RUN python3 -m venv /opt/ansible && \
    /opt/ansible/bin/pip install --upgrade pip && \
    /opt/ansible/bin/pip install ansible && \
    ln -s /opt/ansible/bin/ansible* /usr/local/bin/

# Allow Jenkins user to sudo without a password (optional)
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER jenkins
