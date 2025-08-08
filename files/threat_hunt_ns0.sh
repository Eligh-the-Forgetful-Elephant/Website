#!/bin/bash

echo "🔍 Threat Hunting on ns0"
echo "========================"

echo "📊 Process Analysis:"
echo "==================="
echo "🔍 Suspicious processes:"
ps aux | grep -E "(nc|netcat|nmap|masscan|hydra|john|hashcat|aircrack|wireshark|tcpdump|ettercap|dnsmasq|bind|named)" | grep -v grep
echo ""

echo "🔍 High CPU/Memory processes:"
ps aux --sort=-%cpu | head -10
echo ""
ps aux --sort=-%mem | head -10
echo ""

echo "🌐 Network Analysis:"
echo "=================="
echo "🔍 Active connections:"
sudo netstat -tulpn | grep -E "(LISTEN|ESTABLISHED)"
echo ""

echo "🔍 DNS queries (if tcpdump available):"
sudo tcpdump -i any -n port 53 -c 10 2>/dev/null || echo "tcpdump not available"
echo ""

echo "🔍 DNS cache analysis:"
sudo rndc dumpdb -cache 2>/dev/null
if [ -f /var/cache/bind/named_dump.db ]; then
    echo "DNS cache dump created"
    grep -E "(A|AAAA|PTR)" /var/cache/bind/named_dump.db | head -20
else
    echo "No DNS cache dump available"
fi
echo ""

echo "📁 File System Analysis:"
echo "======================="
echo "🔍 Recent file modifications:"
find /home -type f -mtime -1 -ls 2>/dev/null | head -10
echo ""

echo "🔍 Hidden files:"
find /home -name ".*" -type f -ls 2>/dev/null | head -10
echo ""

echo "🔍 Large files:"
find /home -type f -size +10M -ls 2>/dev/null | head -10
echo ""

echo "🔍 Executable files in home directories:"
find /home -type f -executable -ls 2>/dev/null | head -10
echo ""

echo "📋 User Analysis:"
echo "================"
echo "🔍 Current logged in users:"
who
echo ""

echo "🔍 Failed login attempts:"
sudo grep "Failed password" /var/log/auth.log | tail -10 2>/dev/null || echo "No auth.log found"
echo ""

echo "🔍 SSH connections:"
sudo grep "sshd" /var/log/auth.log | tail -10 2>/dev/null || echo "No auth.log found"
echo ""

echo "🔧 Service Analysis:"
echo "=================="
echo "🔍 Running services:"
sudo systemctl list-units --type=service --state=running | head -20
echo ""

echo "🔍 Failed services:"
sudo systemctl list-units --type=service --state=failed
echo ""

echo "🔍 DNS service status:"
sudo systemctl status bind9 --no-pager -l
echo ""

echo "📊 System Resources:"
echo "=================="
echo "🔍 Disk usage:"
df -h
echo ""

echo "🔍 Memory usage:"
free -h
echo ""

echo "🔍 Load average:"
uptime
echo ""

echo "🔍 Open files:"
lsof | wc -l
echo "Total open files: $(lsof | wc -l)"
echo ""

echo "🔍 DNS-specific analysis:"
echo "========================"
echo "🔍 DNS zone files:"
ls -la /etc/bind/zones/ 2>/dev/null || echo "No zone files found"
echo ""

echo "🔍 DNS configuration:"
sudo named-checkconf /etc/bind/named.conf 2>/dev/null || echo "DNS config check failed"
echo ""

echo "🔍 DNS query log (if available):"
sudo tail -20 /var/log/bind/query.log 2>/dev/null || echo "No query log found"
echo ""

echo "🔍 DNS statistics:"
sudo rndc stats 2>/dev/null || echo "rndc stats failed"
echo ""

echo "🔍 Suspicious DNS queries:"
sudo grep -E "(\.(tk|ml|ga|cf|gq)|bitcoin|wallet|mining)" /var/log/bind/query.log 2>/dev/null || echo "No suspicious queries found"
echo ""

echo "✅ Threat hunting complete!"
echo "📋 Summary: Check for suspicious processes, network connections, and DNS anomalies" 