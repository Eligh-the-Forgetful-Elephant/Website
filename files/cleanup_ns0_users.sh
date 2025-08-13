#!/bin/bash

echo "🧹 Cleaning Red Team Users on ns0"
echo "=================================="

PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqRyM+M9ff/bYyQP/ycDPYL5nPtbfxbb5MJkKezzior universal_linux_access"

echo "📊 Current users before cleanup:"
cat /etc/passwd | grep -E ":(/bin/bash|/bin/sh)$"
echo ""

echo "🗑️ Removing red team accounts..."
sudo pkill -u icanhasaccess 2>/dev/null
sudo pkill -u goldteamscoring 2>/dev/null
sudo pkill -f "icanhasaccess" 2>/dev/null
sudo pkill -f "goldteamscoring" 2>/dev/null

sudo userdel -f -r icanhasaccess 2>/dev/null
sudo userdel -f -r goldteamscoring 2>/dev/null
sudo userdel -f -r alice.smith 2>/dev/null
sudo userdel -f -r bob.johnson 2>/dev/null
sudo userdel -f -r carol.williams 2>/dev/null
sudo userdel -f -r carlos.brown 2>/dev/null
sudo userdel -f -r charlie.jones 2>/dev/null
sudo userdel -f -r chuck.garcia 2>/dev/null
sudo userdel -f -r chad.miller 2>/dev/null
sudo userdel -f -r craig.davis 2>/dev/null
sudo userdel -f -r dan.rodriguez 2>/dev/null
sudo userdel -f -r dave.martinez 2>/dev/null
sudo userdel -f -r david.hernandez 2>/dev/null
sudo userdel -f -r erin.lopez 2>/dev/null
sudo userdel -f -r eve.gonzales 2>/dev/null
sudo userdel -f -r yves.wilson 2>/dev/null
sudo userdel -f -r faythe.anderson 2>/dev/null
sudo userdel -f -r frank.thomas 2>/dev/null
sudo userdel -f -r grace.taylor 2>/dev/null
sudo userdel -f -r heidi.moore 2>/dev/null
sudo userdel -f -r ivan.jackson 2>/dev/null
sudo userdel -f -r judy.martin 2>/dev/null
sudo userdel -f -r mallory.lee 2>/dev/null
sudo userdel -f -r michael.perez 2>/dev/null
sudo userdel -f -r mike.thompson 2>/dev/null
sudo userdel -f -r olivia.white 2>/dev/null
sudo userdel -f -r oscar.harris 2>/dev/null
sudo userdel -f -r peggy.sanchez 2>/dev/null
sudo userdel -f -r rupert.ramirez 2>/dev/null
sudo userdel -f -r sybil.lewis 2>/dev/null
sudo userdel -f -r trent.robinson 2>/dev/null
sudo userdel -f -r ted.walker 2>/dev/null
sudo userdel -f -r trudy.young 2>/dev/null
sudo userdel -f -r victor.allen 2>/dev/null
sudo userdel -f -r walter.king 2>/dev/null

echo "👤 Creating clean admin account..."
sudo useradd -m -s /bin/bash admin_clean
echo "admin_clean:SecurePass123!" | sudo chpasswd
sudo usermod -aG sudo admin_clean

echo "🔑 Deploying SSH key to admin_clean..."
sudo mkdir -p /home/admin_clean/.ssh
echo "$PUBLIC_KEY" | sudo tee /home/admin_clean/.ssh/authorized_keys > /dev/null
sudo chown -R admin_clean:admin_clean /home/admin_clean/.ssh
sudo chmod 600 /home/admin_clean/.ssh/authorized_keys

echo "👤 Creating backup admin account..."
sudo useradd -m -s /bin/bash backup_admin
echo "backup_admin:SecurePass123!" | sudo chpasswd
sudo usermod -aG sudo backup_admin

echo "🔑 Deploying SSH key to backup_admin..."
sudo mkdir -p /home/backup_admin/.ssh
echo "$PUBLIC_KEY" | sudo tee /home/backup_admin/.ssh/authorized_keys > /dev/null
sudo chown -R backup_admin:backup_admin /home/backup_admin/.ssh
sudo chmod 600 /home/backup_admin/.ssh/authorized_keys

echo "📊 Users after cleanup:"
cat /etc/passwd | grep -E ":(/bin/bash|/bin/sh)$"
echo ""

echo "✅ User cleanup complete!"
echo "🔑 New accounts: admin_clean, backup_admin"
echo "🔑 SSH key deployed to both accounts" 