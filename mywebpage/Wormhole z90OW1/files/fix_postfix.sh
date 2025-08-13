#!/bin/bash

echo "🔧 Fixing Postfix on mail0"
echo "=========================="

echo "📡 Unmasking Postfix..."
sudo systemctl unmask postfix
sudo systemctl daemon-reload

echo "📧 Installing SASL dependencies..."
sudo apt-get update
sudo apt-get install -y sasl2-bin libsasl2-modules

echo "🔧 Configuring Postfix for basic mail service..."
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

echo "🔄 Restarting Postfix..."
sudo systemctl restart postfix
sudo systemctl enable postfix

echo "🔍 Checking Postfix status..."
sudo systemctl status postfix --no-pager -l

echo "🌐 Checking network ports..."
sudo netstat -tulpn | grep :25

echo "📧 Testing mail service..."
echo "Test mail from $(hostname)" | mail -s "Postfix Test" admin_clean@localhost

echo "✅ Postfix fix complete!" 