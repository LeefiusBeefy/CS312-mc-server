# Minecraft Server Deployment Pipeline

## Background
This tutorial walks through the process of automating the deployment of a Minecraft server using AWS, Terraform, Ansible, and Docker.

We'll use:
- **Terraform** to provision AWS infrastructure
- **Ansible** to configure the EC2 instance with Docker
- **Docker Compose** to run the Minecraft server container
- **GitHub Actions** to fully automate the pipeline on push

---

## Requirements

### Software to Install
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### Configuration Required
- AWS account with a valid IAM user or temporary credentials
- SSH key pair created in AWS EC2 console (e.g., `Minecraft.pem`)
- Store AWS credentials and SSH private key in GitHub repo secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_SESSION_TOKEN`
  - `KEY_PAIR_NAME`
  - `SSH_PRIVATE_KEY = <your_private_key_contents>`

### Optional Environment Variables
For local runs:
```bash
export AWS_ACCESS_KEY_ID=<your_access_key_id>
export AWS_SECRET_ACCESS_KEY=<your_secret_access_key>
export AWS_SESSION_TOKEN <your_session_token>
```

---

## Pipeline Overview Diagram

```text
[GitHub Push] → [GitHub Actions Workflow]
                ↓
terraform init + apply
                ↓
[EC2 Instance w/ Public IP]
                ↓
ansible-playbook
                ↓
docker-compose up
                ↓
Minecraft Server @ port 25565
```
---

## Commands to Run (If Running Manually)
Start by cloning the repo:
```git
git clone https://github.com/LeefiusBeefy/CS312-mc-server.git
cd CS312CP2
```
Update `KEY_NAME` in `deploy.sh` to your Key Pair name.

Then run `deploy.sh` using
```bash
./deploy.sh
```
## 3. Deploy via GitHub Actions (CI/CD) (Automated Run)
Start by cloning the repo:
```git
git clone https://github.com/LeefiusBeefy/CS312-mc-server.git
cd CS312CP2
```
On push to `main`, the workflow will:
- Run Terraform to provision EC2
- Configure it using Ansible
- Start the Minecraft container

---

## Connecting to the Minecraft Server
Once deployed, connect using the public IP:
```
<instance_ip>:25565
```
You can verify it’s live with:
```bash
nmap -sV -Pn -p T:25565 <instance_ip>
```

---

## Helpful Links
- [itzg/minecraft-server Docker Hub](https://hub.docker.com/r/itzg/minecraft-server)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Ansible Documentation](https://docs.ansible.com/ansible/latest/index.html)