#!/bin/bash

echo "🔧 Setting up SSH and Mail Services on mail0"
echo "============================================="

echo "📡 Configuring SSH (Port 22)..."
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

sudo tee /etc/ssh/sshd_config << 'EOF'
Port 22
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

LoginGraceTime 120
PermitRootLogin no
StrictModes yes
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePrivilegeSeparation yes
EOF

sudo systemctl restart sshd
sudo systemctl enable sshd
echo "✅ SSH configured"

echo "📧 Fixing Postfix (Port 25)..."
sudo systemctl unmask postfix
sudo systemctl daemon-reload

sudo apt-get update
sudo apt-get install -y sasl2-bin libsasl2-modules

sudo postconf -e "inet_interfaces = all"
sudo postconf -e "mynetworks = 127.0.0.0/8, 192.168.0.0/16"
sudo postconf -e "myhostname = mail0"
sudo postconf -e "mydomain = localdomain"
sudo postconf -e "myorigin = \$mydomain"
sudo postconf -e "smtpd_sasl_auth_enable = no"
sudo postconf -e "smtpd_sasl_security_options = noanonymous"
sudo postconf -e "smtpd_sasl_local_domain ="
sudo postconf -e "broken_sasl_auth_clients = yes"
sudo postconf -e "smtpd_recipient_restrictions = permit_mynetworks,reject_unauth_destination"

sudo systemctl restart postfix
sudo systemctl enable postfix
echo "✅ Postfix configured"

echo "🔍 Testing services..."
echo "📡 SSH Status:"
sudo systemctl status sshd --no-pager -l | head -5

echo "📧 Postfix Status:"
sudo systemctl status postfix --no-pager -l | head -5

echo "🌐 Network Ports:"
sudo netstat -tulpn | grep -E ":(22|25)"

echo "📧 Testing mail service..."
echo "Test mail from $(hostname)" | mail -s "Service Test" admin_clean@localhost

echo "✅ Service setup complete!"
echo "🔑 Test SSH: ssh -i ~/.ssh/universal_key admin_clean@mail0"
echo "📧 Test Mail: echo 'Test' | mail -s 'Test' admin_clean@localhost" 