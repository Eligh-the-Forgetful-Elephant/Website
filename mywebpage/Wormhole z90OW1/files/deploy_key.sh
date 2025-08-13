#!/bin/bash
# Universal SSH Key Deployment Script for mail0

echo "🔑 Deploying universal SSH key to mail0..."

# Create the public key content
PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqRyM+M9ff/bYyQP/ycDPYL5nPtbfxbb5MJkKezzior universal_linux_access"

# Deploy to mail0 using current access
echo "📤 Copying key to mail0..."
echo "$PUBLIC_KEY" | ssh icanhasaccess@mail0 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

# Test connection with new key
echo "🧪 Testing connection with universal key..."
ssh -i ~/.ssh/universal_key icanhasaccess@mail0 "echo '✅ Universal key access successful!' && whoami && hostname"

# Create backup admin user
echo "👤 Creating backup admin user..."
ssh -i ~/.ssh/universal_key icanhasaccess@mail0 "sudo useradd -m -s /bin/bash backup_admin && echo 'backup_admin:SecurePass123!' | sudo chpasswd && sudo usermod -aG sudo backup_admin"

# Deploy key to backup user
echo "🔑 Deploying key to backup user..."
echo "$PUBLIC_KEY" | ssh -i ~/.ssh/universal_key icanhasaccess@mail0 "sudo mkdir -p /home/backup_admin/.ssh && sudo tee /home/backup_admin/.ssh/authorized_keys > /dev/null && sudo chown -R backup_admin:backup_admin /home/backup_admin/.ssh && sudo chmod 600 /home/backup_admin/.ssh/authorized_keys"

echo "✅ Universal key deployment complete!"
echo "🔑 You can now connect with: ssh -i ~/.ssh/universal_key icanhasaccess@mail0"
echo "🔑 Or backup user: ssh -i ~/.ssh/universal_key backup_admin@mail0" 