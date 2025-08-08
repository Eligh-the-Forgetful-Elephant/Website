#!/bin/bash

# ThunderStorm C2 Threat Hunter
# Based on analysis of ThunderStorm-main codebase
# Hunt for Red Team ThunderStorm implants and persistence

echo "⚡ ThunderStorm C2 Threat Hunter Starting..."
echo "============================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Function to log findings
log_finding() {
    echo -e "${RED}[THUNDERSTORM]${NC} $1"
    echo "$(date): [THUNDERSTORM] $1" >> /tmp/thunderstorm_hunt.log
}

log_clean() {
    echo -e "${GREEN}[CLEAN]${NC} $1"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# 1. Check for ThunderStorm Bolt Implants
echo -e "\n${YELLOW}[1/8] Checking for ThunderStorm Bolt Implants...${NC}"

# Check for Bolt processes (from bolt.go)
BOLT_PROCESSES=("bolt" "cirrus" "doppler" "jetstream" "cloudseed" "flurry")
FOUND_BOLTS=()

for proc in "${BOLT_PROCESSES[@]}"; do
    if pgrep -f "$proc" >/dev/null; then
        log_finding "Found ThunderStorm Bolt process: $proc"
        FOUND_BOLTS+=("$proc")
        ps aux | grep "$proc" >> /tmp/thunderstorm_bolts.txt
    fi
done

if [ ${#FOUND_BOLTS[@]} -eq 0 ]; then
    log_clean "No ThunderStorm Bolt processes found"
fi

# 2. Check for Guardian Persistence (from bolt.go, flurry.go)
echo -e "\n${YELLOW}[2/8] Checking for Guardian Persistence...${NC}"

# Check for Guardian pipes (default linker type)
if find /tmp -name "*guard*" -type p 2>/dev/null | grep -q .; then
    log_finding "Found Guardian pipes in /tmp"
    find /tmp -name "*guard*" -type p 2>/dev/null >> /tmp/thunderstorm_guardians.txt
fi

# Check for Guardian processes
if pgrep -f "guard" >/dev/null; then
    log_finding "Found Guardian processes"
    ps aux | grep "guard" >> /tmp/thunderstorm_guardians.txt
fi

# 3. Check for Flurry Persistence (from flurry.go)
echo -e "\n${YELLOW}[3/8] Checking for Flurry Persistence...${NC}"

# Check for Flurry processes
if pgrep -f "flurry" >/dev/null; then
    log_finding "Found Flurry processes"
    ps aux | grep "flurry" >> /tmp/thunderstorm_flurries.txt
fi

# Check for encrypted files that Flurry might use
if find /tmp /var/tmp /home -name "*.enc" -o -name "*.xor" 2>/dev/null | grep -q .; then
    log_finding "Found potential Flurry encrypted files"
    find /tmp /var/tmp /home -name "*.enc" -o -name "*.xor" 2>/dev/null >> /tmp/thunderstorm_encrypted_files.txt
fi

# 4. Check for Cirrus C2 Server (from cirrus/)
echo -e "\n${YELLOW}[4/8] Checking for Cirrus C2 Server...${NC}"

# Check for Cirrus server processes
if pgrep -f "cirrus" >/dev/null; then
    log_finding "Found Cirrus C2 server process"
    ps aux | grep "cirrus" >> /tmp/thunderstorm_cirrus.txt
fi

# Check for Cirrus web interface (default port 7777)
if netstat -tuln 2>/dev/null | grep ":7777" >/dev/null; then
    log_finding "Found Cirrus web interface on port 7777"
    netstat -tuln 2>/dev/null | grep ":7777" >> /tmp/thunderstorm_cirrus.txt
fi

# Check for Cirrus configuration files
if find /etc /home /root -name "*cirrus*" -o -name "*thunderstorm*" 2>/dev/null | grep -q .; then
    log_finding "Found potential Cirrus configuration files"
    find /etc /home /root -name "*cirrus*" -o -name "*thunderstorm*" 2>/dev/null >> /tmp/thunderstorm_configs.txt
fi

# 5. Check for Doppler CLI Client (from doppler/)
echo -e "\n${YELLOW}[5/8] Checking for Doppler CLI Client...${NC}"

# Check for Doppler processes
if pgrep -f "doppler" >/dev/null; then
    log_finding "Found Doppler CLI client process"
    ps aux | grep "doppler" >> /tmp/thunderstorm_doppler.txt
fi

# Check for Doppler configuration files
if find /home /root -name "*doppler*" -o -name "config.json" 2>/dev/null | grep -q .; then
    log_finding "Found potential Doppler configuration files"
    find /home /root -name "*doppler*" -o -name "config.json" 2>/dev/null >> /tmp/thunderstorm_doppler.txt
fi

# 6. Check for JetStream/CloudSeed Build Artifacts
echo -e "\n${YELLOW}[6/8] Checking for Build Artifacts...${NC}"

# Check for Go binaries that might be ThunderStorm implants
if find /tmp /var/tmp /home -name "*.exe" -o -name "*bolt*" -o -name "*flurry*" 2>/dev/null | grep -q .; then
    log_finding "Found potential ThunderStorm binaries"
    find /tmp /var/tmp /home -name "*.exe" -o -name "*bolt*" -o -name "*flurry*" 2>/dev/null >> /tmp/thunderstorm_binaries.txt
fi

# Check for Go source files
if find /tmp /var/tmp /home -name "*.go" 2>/dev/null | grep -q .; then
    log_finding "Found Go source files (potential ThunderStorm source)"
    find /tmp /var/tmp /home -name "*.go" 2>/dev/null >> /tmp/thunderstorm_sources.txt
fi

# 7. Check for Network Communication Patterns
echo -e "\n${YELLOW}[7/8] Checking Network Communication...${NC}"

# Check for suspicious outbound connections (ThunderStorm C2)
if netstat -tuln 2>/dev/null | grep -E "(7777|8080|443|80)" | grep -v "127.0.0.1" >/dev/null; then
    log_finding "Found suspicious outbound connections (potential C2)"
    netstat -tuln 2>/dev/null | grep -E "(7777|8080|443|80)" | grep -v "127.0.0.1" >> /tmp/thunderstorm_network.txt
fi

# Check for WebSocket connections (Cirrus uses WebSocket)
if ss -tuln 2>/dev/null | grep "ws" >/dev/null; then
    log_finding "Found WebSocket connections (potential Cirrus)"
    ss -tuln 2>/dev/null | grep "ws" >> /tmp/thunderstorm_network.txt
fi

# 8. Check for Service/Daemon Persistence
echo -e "\n${YELLOW}[8/8] Checking Service Persistence...${NC}"

# Check for ThunderStorm services
THUNDERSTORM_SERVICES=("thunderstorm" "cirrus" "bolt" "flurry" "doppler")
FOUND_SERVICES=()

for service in "${THUNDERSTORM_SERVICES[@]}"; do
    if systemctl list-units --type=service 2>/dev/null | grep -i "$service" >/dev/null; then
        log_finding "Found ThunderStorm service: $service"
        FOUND_SERVICES+=("$service")
        systemctl status "$service" 2>/dev/null >> /tmp/thunderstorm_services.txt
    fi
done

if [ ${#FOUND_SERVICES[@]} -eq 0 ]; then
    log_clean "No ThunderStorm services found"
fi

# Check for cron jobs that might launch ThunderStorm components
if crontab -l 2>/dev/null | grep -E "(bolt|flurry|cirrus|thunderstorm)" >/dev/null; then
    log_finding "Found ThunderStorm-related cron jobs"
    crontab -l 2>/dev/null | grep -E "(bolt|flurry|cirrus|thunderstorm)" >> /tmp/thunderstorm_cron.txt
fi

# Summary
echo -e "\n${PURPLE}=================================="
echo "⚡ THUNDERSTORM C2 HUNT SUMMARY"
echo "==================================${NC}"

if [ -f "/tmp/thunderstorm_hunt.log" ]; then
    echo -e "${RED}Found $(wc -l < /tmp/thunderstorm_hunt.log) ThunderStorm threats${NC}"
    echo -e "${BLUE}Full log: /tmp/thunderstorm_hunt.log${NC}"
else
    echo -e "${GREEN}No ThunderStorm threats detected!${NC}"
fi

# Show specific findings
echo -e "\n${YELLOW}Detailed Findings:${NC}"
if [ -f "/tmp/thunderstorm_bolts.txt" ]; then
    echo -e "${RED}⚡ Bolt implants: $(wc -l < /tmp/thunderstorm_bolts.txt)${NC}"
fi
if [ -f "/tmp/thunderstorm_guardians.txt" ]; then
    echo -e "${RED}🛡️  Guardians: $(wc -l < /tmp/thunderstorm_guardians.txt)${NC}"
fi
if [ -f "/tmp/thunderstorm_flurries.txt" ]; then
    echo -e "${RED}❄️  Flurries: $(wc -l < /tmp/thunderstorm_flurries.txt)${NC}"
fi
if [ -f "/tmp/thunderstorm_cirrus.txt" ]; then
    echo -e "${RED}☁️  Cirrus C2: $(wc -l < /tmp/thunderstorm_cirrus.txt)${NC}"
fi
if [ -f "/tmp/thunderstorm_doppler.txt" ]; then
    echo -e "${RED}📡 Doppler CLI: $(wc -l < /tmp/thunderstorm_doppler.txt)${NC}"
fi

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Review findings in /tmp/thunderstorm_hunt.log"
echo "2. Kill any found ThunderStorm processes"
echo "3. Remove Guardian pipes and services"
echo "4. Block C2 communication"
echo "5. Monitor for re-infection"

echo -e "\n${GREEN}✅ ThunderStorm C2 Threat Hunter Complete!${NC}" 