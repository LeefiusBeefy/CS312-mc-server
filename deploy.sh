#!/bin/bash

set -e  # Exit on error
set -u  # Exit on undefined variables

KEY_NAME="Minecraft"  # Set your key pair name here

echo "🛠  Running Terraform to provision EC2 instance..."
cd terraform
terraform init
terraform apply -auto-approve -var="key_pair_name=$KEY_NAME"

echo "🔍  Getting public IP from Terraform output..."
IP=$(terraform output -raw instance_ip)
cd ..

echo "💾  Writing Ansible inventory file..."
cat > ansible/inventory.ini <<EOF
[minecraft]
$IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/${KEY_NAME}.pem
EOF

echo "⏳  Waiting for instance to become SSH-ready..."

# Wait for port 22 to be open (timeout after 90 seconds)
for i in {1..30}; do
  nc -z -w1 "$IP" 22 && echo "✅ SSH is ready!" && break
  echo "⏳ Waiting for SSH on $IP (attempt $i)..."
  sleep 3
done
echo "🚀  Running Ansible playbook to configure server..."
cd ansible
ansible-playbook -i inventory.ini playbook.yml

echo "✅  Done! Connect in Minecraft using: $IP:25565"
