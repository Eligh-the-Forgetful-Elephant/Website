#!/bin/bash

echo "🔧 Final Fix for mail0 Services"
echo "==============================="

echo "📧 Installing mailutils..."
sudo apt-get update
sudo apt-get install -y mailutils

echo "📧 Configuring Postfix to listen on port 25..."
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

echo "🌐 Checking port 25..."
sudo netstat -tulpn | grep :25

echo "📧 Testing mail service..."
echo "Test mail from $(hostname)" | mail -s "Final Test" admin_clean@localhost

echo "🔍 Checking mail queue..."
sudo postqueue -p

echo "✅ Final fix complete!"
echo "📧 Test mail: echo 'Test' | mail -s 'Test' admin_clean@localhost" 