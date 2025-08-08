#!/bin/bash

echo "🔧 Configuring Postfix to listen on port 25"
echo "=========================================="

echo "📧 Setting Postfix to listen on all interfaces..."
sudo postconf -e "inet_interfaces = all"
sudo postconf -e "mynetworks = 127.0.0.0/8, 192.168.0.0/16"
sudo postconf -e "myhostname = mail0"
sudo postconf -e "mydomain = localdomain"
sudo postconf -e "myorigin = \$mydomain"

echo "🔄 Reloading Postfix..."
sudo systemctl reload postfix

echo "🌐 Checking port 25..."
sudo netstat -tulpn | grep :25

echo "📧 Testing mail service..."
echo "Test mail from $(hostname)" | mail -s "Port 25 Test" admin_clean@localhost

echo "✅ Port 25 configuration complete!" 