FROM jenkins/jenkins:lts

USER root

RUN apt-get update

RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER jenkins