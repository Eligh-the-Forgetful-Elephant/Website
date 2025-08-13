#!/bin/bash

# Day 1 Defense Setup Script
# Run this before the game starts

echo "🛡️  Setting up Day 1 Defense Tools..."
echo "======================================"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Make scripts executable
echo -e "\n${BLUE}Making scripts executable...${NC}"
chmod +x threat_hunter.sh
chmod +x service_monitor.sh

# Create log directories
echo -e "\n${BLUE}Creating log directories...${NC}"
mkdir -p /tmp/defense_logs
touch /tmp/threat_hunt.log
touch /tmp/incident_response.log
touch /tmp/service_uptime.log

# Test threat hunter
echo -e "\n${BLUE}Testing threat hunter...${NC}"
./threat_hunter.sh

# Test service monitor (will show configuration needed)
echo -e "\n${BLUE}Testing service monitor...${NC}"
echo -e "${YELLOW}⚠️  You need to update SCORED_SERVICES in service_monitor.sh${NC}"
echo -e "${YELLOW}⚠️  Update with your actual server IPs/hostnames${NC}"

# Create monitoring cron job
echo -e "\n${BLUE}Setting up monitoring cron job...${NC}"
(crontab -l 2>/dev/null; echo "*/5 * * * * $(pwd)/threat_hunter.sh >> /tmp/defense_logs/threat_hunt.log") | crontab -

echo -e "\n${GREEN}✅ Day 1 Defense Setup Complete!${NC}"
echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Edit service_monitor.sh with your actual server details"
echo "2. Test service_monitor.sh"
echo "3. Review day1_checklist.md"
echo "4. Keep quick_response_guide.md handy"

echo -e "\n${BLUE}Good luck, Blue Team! 🛡️${NC}" 