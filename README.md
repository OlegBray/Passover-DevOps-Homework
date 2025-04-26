# 🎯 Passover DevOps Homework

## 📄 Overview

This repository contains a DevOps project developed as part of a Passover homework assignment.  
It combines several key technologies including **Docker**, **Docker Compose**, **Jenkins**, **Vault**, **Consul**, **Ansible**, **Artifactory**, and **AWS EC2** to demonstrate infrastructure management, CI/CD pipeline setup, and secure secret management.

All Ansible operations in this project are executed remotely on AWS EC2 instances, enabling real-world cloud automation.

---

## 🗂️ Table of Contents

- [Technologies and Tools Used](#-technologies-and-tools-used)
- [Project Structure](#-project-structure)
- [Default Service Ports](#-default-service-ports)
- [Prerequisites](#-prerequisites)
- [How to Run](#-how-to-run)
- [Ansible Configuration](#-ansible-configuration)
- [Vault Jenkinsfile Configuration](#-vault-jenkinsfile-configuration)
- [Consul Jenkinsfile Configuration](#-consul-jenkinsfile-configuration)
- [Notes](#-notes)
- [⚠️ WARNING!](#️-warning)

---

## 🛠️ Technologies and Tools Used

- **Docker**: Containerization of applications and services.
- **Docker Compose**: Multi-container orchestration.
- **Jenkins**: Continuous Integration / Continuous Deployment (CI/CD) server.
- **HashiCorp Vault**: Secret management and data protection.
- **HashiCorp Consul**: Service discovery and configuration.
- **JFrog Artifactory OSS**: Artifact repository management.
- **Ansible**: Automation tool for configuration management.
- **AWS EC2**: Cloud servers where Ansible tasks are executed.
- **AWS S3**: Object storage for Artifactory packages.
- **AWS Route53**: DNS management.
- **Nginx**: Reverse proxy and load balancer.

---

## 🏗️ Project Structure

- `docker-compose.yml`: Compose file to spin up services.
- `ansible/`: Playbooks and roles for AWS EC2 configuration.
- `jenkins/`: Jenkins setup and pipelines.
- `vault/`: Vault configuration and Jenkins secret pipelines.
- `consul/`:  
  - `docker-compose.yml` for **both Consul and Vault combined**.
  - Jenkins pipeline for storing KV secrets.
- `artifactory/`: Artifactory Ansible configurations, using AWS S3.
- `files/`: Scripts for DNS updates via Route53.

---

## 🔌 Default Service Ports

| Service        | Port Mapping                     |
| -------------- | --------------------------------- |
| Jenkins        | **8080**                         |
| Vault          | **8200**                         |
| Consul         | **8500**                         |
| Artifactory    | **8081**                         |
| Nginx          | **9090 (external) ➔ 8080 (internal)** |

> Example:  
> - Jenkins: `http://localhost:8080`
> - Nginx (proxy): `http://localhost:9090`

---

## 🚀 Prerequisites

Make sure you have:

- [Docker](https://docs.docker.com/get-docker/) installed.
- [Docker Compose](https://docs.docker.com/compose/install/) installed.
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installed.
- AWS credentials configured locally.

---

## 🏃 How to Run

1. **Clone the repository**
   ```bash
   git clone https://github.com/OlegBray/Passover-DevOps-Homework.git
   cd Passover-DevOps-Homework
   ```

2. **Create the required Docker network**
   ```bash
   docker network create jenkins
   ```

3. **Build and start services**

   If using local `Dockerfile`s:

   ```bash
   docker-compose up -d --build
   ```

   Otherwise:

   ```bash
   docker-compose up -d
   ```

4. **Verify containers are running**
   ```bash
   docker ps
   ```

5. **Access your services** using the ports listed above!

---

## ⚙️ Ansible Configuration

Inside inventories and configs, look for placeholders like:

```bash
<Your server>
```

You must replace these with your actual server's public IP or domain.

For Artifactory-specific deployment, edit:
```yaml
s3_bucket: "<Your S3 bucket>"
s3_key: "<Your tar.gz path>"
```

For Route53 updates (`files/` scripts):
```bash
DOMAIN_NAME="<Your domain/sub-domain>"
TAG_NAME="<Your tag of the machine>"
SUB_DOMAIN_PREFIX="<Your Subdomain Prefix>"
```

Make sure all placeholders are properly filled before executing playbooks.

---

## 🔒 Vault Jenkinsfile Configuration

In `vault/Jenkinsfile`, find:
```groovy
<Your secret path, make sure it's v1 or v2>
```
➔ Replace with your Vault secret path (make sure your Vault engine is **KV v1** or **KV v2**).

---

## 📚 Consul Jenkinsfile Configuration

In `consul/Jenkinsfile`, you will find:

```groovy
string(name: 'VALUE', defaultValue: '<Your parameter value>', description: 'Value to store in Consul')
string(name: 'KEY', defaultValue: 'http://<Your Machine>:8500/v1/kv/<Your Desired Path>', description: 'Consul KV key URL')
```

➔ Replace the placeholders as follows:

- `<Your Machine>` ➔ Consul server address (IP or DNS).
- `<Your parameter value>` ➔ Value you want to store.
- `<Your Desired Path>` ➔ KV path (key name) inside Consul.

---

## 📝 Notes

- Always double-check your environment-specific configurations.
- Secure Jenkins and Vault properly before exposing to production.
- Secure secrets properly using Vault, environment variables, or AWS Secrets Manager.

---

## ⚠️ WARNING!

> **No matter what happens, DO NOT upload any types of keys, secrets, passwords, or sensitive information into your repositories!**  
> Always use Vault or proper secure solutions.

---