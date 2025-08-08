#!/bin/bash

echo "🔍 DNS Server Monitor - ns0"
echo "============================"

echo "📡 BIND9 Service Status:"
sudo systemctl status bind9 --no-pager -l
echo ""

echo "🌐 Network Ports:"
sudo netstat -tulpn | grep :53
echo ""

echo "📊 Process Check:"
ps aux | grep -E "(named|bind)" | grep -v grep
echo ""

echo "🧪 DNS Resolution Tests:"
echo "Testing ns0.localdomain..."
nslookup ns0.localdomain 127.0.0.1 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ ns0.localdomain resolves"
else
    echo "❌ ns0.localdomain failed"
fi

echo "Testing mail0.localdomain..."
nslookup mail0.localdomain 127.0.0.1 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ mail0.localdomain resolves"
else
    echo "❌ mail0.localdomain failed"
fi

echo "Testing reverse lookup..."
nslookup 192.168.1.10 127.0.0.1 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ Reverse lookup works"
else
    echo "❌ Reverse lookup failed"
fi
echo ""

echo "📋 Zone Information:"
sudo rndc status 2>/dev/null
echo ""

echo "📝 Zone Files Check:"
ls -la /etc/bind/zones/
echo ""

echo "🔍 Configuration Check:"
sudo named-checkconf /etc/bind/named.conf
echo ""

echo "✅ DNS monitoring complete!" 