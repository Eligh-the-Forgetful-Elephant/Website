#!/bin/bash

# Day 1 Service Monitor - Keep All Scored Services Running
# Critical for Blue Team scoring in PVJ

echo "🛡️  Day 1 Service Monitor Starting..."
echo "======================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration - UPDATE THESE FOR YOUR ENVIRONMENT
SCORED_SERVICES=(
    "http://your-web-server:80"
    "https://your-web-server:443"
    "ssh://your-ssh-server:22"
    "ftp://your-ftp-server:21"
    "dns://your-dns-server:53"
)

SCORED_HOSTS=(
    "your-web-server"
    "your-ssh-server"
    "your-ftp-server"
    "your-dns-server"
)

# Function to check service
check_service() {
    local service=$1
    local protocol=$(echo $service | cut -d: -f1)
    local host=$(echo $service | cut -d: -f2 | sed 's|//||')
    local port=$(echo $service | cut -d: -f3)
    
    case $protocol in
        "http")
            if curl -s -I --connect-timeout 5 "$service" >/dev/null 2>&1; then
                echo -e "${GREEN}✅ HTTP: $host:$port${NC}"
                return 0
            else
                echo -e "${RED}❌ HTTP: $host:$port${NC}"
                return 1
            fi
            ;;
        "https")
            if curl -s -I --connect-timeout 5 -k "$service" >/dev/null 2>&1; then
                echo -e "${GREEN}✅ HTTPS: $host:$port${NC}"
                return 0
            else
                echo -e "${RED}❌ HTTPS: $host:$port${NC}"
                return 1
            fi
            ;;
        "ssh")
            if timeout 5 bash -c "</dev/tcp/$host/$port" 2>/dev/null; then
                echo -e "${GREEN}✅ SSH: $host:$port${NC}"
                return 0
            else
                echo -e "${RED}❌ SSH: $host:$port${NC}"
                return 1
            fi
            ;;
        "ftp")
            if timeout 5 bash -c "</dev/tcp/$host/$port" 2>/dev/null; then
                echo -e "${GREEN}✅ FTP: $host:$port${NC}"
                return 0
            else
                echo -e "${RED}❌ FTP: $host:$port${NC}"
                return 1
            fi
            ;;
        "dns")
            if nslookup google.com $host >/dev/null 2>&1; then
                echo -e "${GREEN}✅ DNS: $host:$port${NC}"
                return 0
            else
                echo -e "${RED}❌ DNS: $host:$port${NC}"
                return 1
            fi
            ;;
    esac
}

# Function to check host connectivity
check_host() {
    local host=$1
    if ping -c 1 -W 5 "$host" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ PING: $host${NC}"
        return 0
    else
        echo -e "${RED}❌ PING: $host${NC}"
        return 1
    fi
}

# Function to restart service
restart_service() {
    local service_name=$1
    echo -e "${YELLOW}🔄 Attempting to restart $service_name...${NC}"
    
    case $service_name in
        "apache2"|"httpd")
            systemctl restart apache2 2>/dev/null || systemctl restart httpd 2>/dev/null
            ;;
        "nginx")
            systemctl restart nginx 2>/dev/null
            ;;
        "ssh"|"sshd")
            systemctl restart ssh 2>/dev/null || systemctl restart sshd 2>/dev/null
            ;;
        "vsftpd"|"proftpd")
            systemctl restart vsftpd 2>/dev/null || systemctl restart proftpd 2>/dev/null
            ;;
        "bind9"|"named")
            systemctl restart bind9 2>/dev/null || systemctl restart named 2>/dev/null
            ;;
        *)
            echo -e "${YELLOW}⚠️  Unknown service: $service_name${NC}"
            ;;
    esac
}

# Main monitoring loop
echo -e "\n${BLUE}🔍 Checking scored services...${NC}"
failed_services=0

for service in "${SCORED_SERVICES[@]}"; do
    if ! check_service "$service"; then
        failed_services=$((failed_services + 1))
    fi
done

echo -e "\n${BLUE}🔍 Checking host connectivity...${NC}"
failed_hosts=0

for host in "${SCORED_HOSTS[@]}"; do
    if ! check_host "$host"; then
        failed_hosts=$((failed_hosts + 1))
    fi
done

# Check DNS resolution (critical for scoring)
echo -e "\n${BLUE}🔍 Checking DNS resolution...${NC}"
if nslookup google.com >/dev/null 2>&1; then
    echo -e "${GREEN}✅ DNS resolution working${NC}"
else
    echo -e "${RED}❌ DNS resolution failed${NC}"
    failed_services=$((failed_services + 1))
fi

# Check ICMP (required for scoring)
echo -e "\n${BLUE}🔍 Checking ICMP...${NC}"
if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    echo -e "${GREEN}✅ ICMP working${NC}"
else
    echo -e "${RED}❌ ICMP failed${NC}"
    failed_services=$((failed_services + 1))
fi

# Summary
echo -e "\n${YELLOW}=================================="
echo "📊 SERVICE MONITOR SUMMARY"
echo "==================================${NC}"

if [ $failed_services -eq 0 ] && [ $failed_hosts -eq 0 ]; then
    echo -e "${GREEN}🎉 All services are running!${NC}"
    echo -e "${GREEN}✅ Your team should be scoring points${NC}"
else
    echo -e "${RED}⚠️  Found $failed_services failed services and $failed_hosts failed hosts${NC}"
    echo -e "${YELLOW}🔄 Consider restarting failed services${NC}"
fi

# Quick fixes for common issues
echo -e "\n${BLUE}🔧 Quick Fixes:${NC}"
echo "1. Restart web server: sudo systemctl restart apache2"
echo "2. Restart SSH: sudo systemctl restart ssh"
echo "3. Restart DNS: sudo systemctl restart bind9"
echo "4. Check firewall: sudo ufw status"
echo "5. Check network: ip addr show"

# Continuous monitoring
echo -e "\n${BLUE}🔄 Starting continuous monitoring...${NC}"
echo "Press Ctrl+C to stop"

while true; do
    sleep 30  # Check every 30 seconds
    echo -e "\n${BLUE}[$(date)] Checking services...${NC}"
    
    for service in "${SCORED_SERVICES[@]}"; do
        check_service "$service" >/dev/null
    done
done 