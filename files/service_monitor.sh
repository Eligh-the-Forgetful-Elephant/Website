#!/bin/bash

echo "🔍 Service Monitor - mail0"
echo "=========================="

echo "📡 SSH Service (Port 22):"
sudo systemctl status sshd --no-pager -l
echo ""

echo "📧 Mail Service (Port 25):"
sudo systemctl status postfix --no-pager -l
echo ""

echo "🌐 Network Connections:"
sudo netstat -tulpn | grep -E ":(22|25)"
echo ""

echo "📊 Process Check:"
ps aux | grep -E "(sshd|postfix)" | grep -v grep
echo ""

echo "🔑 SSH Key Test:"
ssh -i ~/.ssh/universal_key -o ConnectTimeout=5 admin_clean@localhost "echo 'SSH key auth working'" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ SSH key authentication working"
else
    echo "❌ SSH key authentication failed"
fi
echo ""

echo "📧 Mail Test:"
echo "Test mail from $(hostname)" | mail -s "Service Test" admin_clean@localhost 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Mail service working"
else
    echo "❌ Mail service failed"
fi 