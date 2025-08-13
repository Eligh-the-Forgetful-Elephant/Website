#!/bin/bash

echo "🔍 DNS Anomaly Detector - ns0"
echo "=============================="

echo "📊 DNS Service Status:"
sudo systemctl status bind9 --no-pager -l | head -10
echo ""

echo "🌐 DNS Listening Ports:"
sudo netstat -tulpn | grep :53
echo ""

echo "🔍 DNS Zone Analysis:"
echo "===================="
if [ -d /etc/bind/zones ]; then
    echo "📁 Zone files found:"
    ls -la /etc/bind/zones/
    echo ""
    
    echo "📋 Forward zone entries:"
    if [ -f /etc/bind/zones/db.localdomain ]; then
        grep "IN.*A" /etc/bind/zones/db.localdomain | grep -v "@"
    else
        echo "No forward zone file found"
    fi
    echo ""
    
    echo "📋 Reverse zone entries:"
    if [ -f /etc/bind/zones/db.192.168.0 ]; then
        grep "PTR" /etc/bind/zones/db.192.168.0
    else
        echo "No reverse zone file found"
    fi
else
    echo "❌ No zone directory found"
fi
echo ""

echo "🔍 DNS Query Analysis:"
echo "====================="
echo "📊 Recent DNS queries (if logging enabled):"
sudo tail -20 /var/log/bind/query.log 2>/dev/null || echo "No query log found"
echo ""

echo "🔍 DNS cache analysis:"
sudo rndc dumpdb -cache 2>/dev/null
if [ -f /var/cache/bind/named_dump.db ]; then
    echo "📊 DNS cache entries:"
    grep -E "(A|AAAA|PTR)" /var/cache/bind/named_dump.db | head -20
else
    echo "No DNS cache dump available"
fi
echo ""

echo "🔍 Suspicious DNS Patterns:"
echo "=========================="
echo "🔍 High-frequency queries:"
sudo grep -o '[^[:space:]]*' /var/log/bind/query.log 2>/dev/null | sort | uniq -c | sort -nr | head -10 || echo "No query log available"
echo ""

echo "🔍 Suspicious TLD queries:"
sudo grep -E "\.(tk|ml|ga|cf|gq|xyz|top|club|site|online)" /var/log/bind/query.log 2>/dev/null || echo "No suspicious TLD queries found"
echo ""

echo "🔍 Cryptocurrency-related queries:"
sudo grep -E "(bitcoin|wallet|mining|pool|coin)" /var/log/bind/query.log 2>/dev/null || echo "No crypto-related queries found"
echo ""

echo "🔍 Command & Control patterns:"
sudo grep -E "(\.(tk|ml|ga|cf|gq)|bitcoin|wallet|mining)" /var/log/bind/query.log 2>/dev/null || echo "No C2 patterns found"
echo ""

echo "🔍 DNS Tunneling Detection:"
echo "=========================="
echo "🔍 Long domain names (potential DNS tunneling):"
sudo grep -E "[a-zA-Z0-9]{50,}" /var/log/bind/query.log 2>/dev/null || echo "No long domain queries found"
echo ""

echo "🔍 Base64 encoded queries:"
sudo grep -E "[A-Za-z0-9+/]{20,}={0,2}" /var/log/bind/query.log 2>/dev/null || echo "No base64 patterns found"
echo ""

echo "🔍 DNS Amplification Detection:"
echo "=============================="
echo "🔍 Large response queries:"
sudo grep -E "(ANY|AXFR)" /var/log/bind/query.log 2>/dev/null || echo "No amplification queries found"
echo ""

echo "🔍 DNS Zone Transfer Attempts:"
sudo grep -E "AXFR" /var/log/bind/query.log 2>/dev/null || echo "No zone transfer attempts found"
echo ""

echo "🔍 DNS Configuration Security:"
echo "============================"
echo "🔍 DNS recursion settings:"
sudo grep -E "(allow-recursion|allow-query)" /etc/bind/named.conf.options 2>/dev/null || echo "No recursion settings found"
echo ""

echo "🔍 DNS forwarding settings:"
sudo grep -E "forwarders" /etc/bind/named.conf.options 2>/dev/null || echo "No forwarding settings found"
echo ""

echo "🔍 DNS DNSSEC settings:"
sudo grep -E "dnssec" /etc/bind/named.conf.options 2>/dev/null || echo "No DNSSEC settings found"
echo ""

echo "📊 DNS Statistics:"
echo "================"
echo "🔍 DNS server statistics:"
sudo rndc stats 2>/dev/null || echo "rndc stats failed"
echo ""

echo "🔍 DNS server version:"
sudo named -v 2>/dev/null || echo "Could not get named version"
echo ""

echo "✅ DNS anomaly detection complete!"
echo "📋 Summary: Check for suspicious queries, C2 patterns, and DNS tunneling attempts" 