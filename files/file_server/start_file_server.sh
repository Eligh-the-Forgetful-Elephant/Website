#!/bin/bash

echo "🚀 Starting File Server"
echo "======================"

# Get your IP address
IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
echo "📡 Your IP: $IP"

echo "📁 Current directory: $(pwd)"
echo "📋 Files available:"
ls -la

echo ""
echo "🌐 Starting HTTP server on port 8080..."
echo "📥 Download URLs for Windows boxes:"
echo "   http://$IP:8080/triage-collector-main.zip"
echo "   http://$IP:8080/cleanup_ns0_users.sh"
echo "   http://$IP:8080/threat_hunt_ns0.sh"
echo "   http://$IP:8080/dns_anomaly_detector.sh"
echo "   http://$IP:8080/setup_dns_ns0.sh"
echo ""

echo "💡 Windows PowerShell download commands:"
echo "   Invoke-WebRequest -Uri 'http://$IP:8080/triage-collector-main.zip' -OutFile 'triage-collector-main.zip'"
echo "   Invoke-WebRequest -Uri 'http://$IP:8080/cleanup_ns0_users.sh' -OutFile 'cleanup_ns0_users.sh'"
echo ""

echo "🔄 Starting server... (Ctrl+C to stop)"
python3 -m http.server 8080 