#!/bin/bash

# Day 1 Threat Hunter - Based on Your Malware Knowledge
# Hunt for Red Team persistence using techniques from your workspace

echo "🔍 Day 1 Threat Hunter Starting..."
echo "=================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to log findings
log_finding() {
    echo -e "${RED}[THREAT]${NC} $1"
    echo "$(date): $1" >> /tmp/threat_hunt.log
}

log_clean() {
    echo -e "${GREEN}[CLEAN]${NC} $1"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# 1. Check for SSH Key Persistence (from badscript.cpp)
echo -e "\n${YELLOW}[1/8] Checking SSH Key Persistence...${NC}"
if grep -q "ssh-rsa AAAAB4NzaC1yc2EAAAADAQABAAABAQCl0kIN33IJISIufmqpqg54D7s4J0L7XV2kep0rNzgY1S1IdE8HDAf7z1ipBVuGTygGsq+x4yVnxveGshVP48YmicQHJMCIljmn6Po0RMC48qihm/9ytoEYtkKkeiTR02c6DyIcDnX3QdlSmEqPqSNRQ/XDgM7qIB/VpYtAhK/7DoE8pqdoFNBU5+JlqeWYpsMO+qkHugKA5U22wEGs8xG2XyyDtrBcw10xz+M7U8Vpt0tEadeV973tXNNNpUgYGIFEsrDEAjbMkEsUw+iQmXg37EusEFjCVjBySGH3F+EQtwin3YmxbB9HRMzOIzNnXwCFaYU5JjTNnzylUBp/XB6B user@placeholder_host" /root/.ssh/authorized_keys 2>/dev/null; then
    log_finding "Found malicious SSH key in /root/.ssh/authorized_keys"
    echo "ssh-rsa AAAAB4NzaC1yc2EAAAADAQABAAABAQCl0kIN33IJISIufmqpqg54D7s4J0L7XV2kep0rNzgY1S1IdE8HDAf7z1ipBVuGTygGsq+x4yVnxveGshVP48YmicQHJMCIljmn6Po0RMC48qihm/9ytoEYtkKkeiTR02c6DyIcDnX3QdlSmEqPqSNRQ/XDgM7qIB/VpYtAhK/7DoE8pqdoFNBU5+JlqeWYpsMO+qkHugKA5U22wEGs8xG2XyyDtrBcw10xz+M7U8Vpt0tEadeV973tXNNNpUgYGIFEsrDEAjbMkEsUw+iQmXg37EusEFjCVjBySGH3F+EQtwin3YmxbB9HRMzOIzNnXwCFaYU5JjTNnzylUBp/XB6B user@placeholder_host" >> /tmp/malicious_ssh_keys.txt
else
    log_clean "No malicious SSH keys found"
fi

# 2. Check for Cron Job Persistence (from badscript.cpp)
echo -e "\n${YELLOW}[2/8] Checking Cron Job Persistence...${NC}"
if grep -r "curl -s http://placeholder-domain" /etc/crontab /var/spool/cron/ /etc/cron.d/ 2>/dev/null; then
    log_finding "Found malicious cron job with placeholder-domain"
    grep -r "curl -s http://placeholder-domain" /etc/crontab /var/spool/cron/ /etc/cron.d/ 2>/dev/null >> /tmp/malicious_cron.txt
else
    log_clean "No malicious cron jobs found"
fi

# 3. Check for Specific Malicious Processes (from badscript.cpp)
echo -e "\n${YELLOW}[3/8] Checking for Malicious Processes...${NC}"
MALICIOUS_PROCESSES=("atlas.x86" "dotsh" "nine.x86" "balder" "rtw88_pcied" "cpu_hu" "agettyd" "java" "postmaster")
FOUND_PROCESSES=()

for proc in "${MALICIOUS_PROCESSES[@]}"; do
    if pgrep -f "$proc" >/dev/null; then
        log_finding "Found malicious process: $proc"
        FOUND_PROCESSES+=("$proc")
        ps aux | grep "$proc" >> /tmp/malicious_processes.txt
    fi
done

if [ ${#FOUND_PROCESSES[@]} -eq 0 ]; then
    log_clean "No malicious processes found"
fi

# 4. Check for Modified Configs (from badscript.cpp)
echo -e "\n${YELLOW}[4/8] Checking for Modified Configurations...${NC}"
CONFIG_FINDINGS=0

if grep -q "8.8.8.8" /etc/resolv.conf 2>/dev/null; then
    log_finding "Found malicious DNS entry: 8.8.8.8 in /etc/resolv.conf"
    CONFIG_FINDINGS=$((CONFIG_FINDINGS + 1))
fi

if grep -q "PermitRootLogin yes" /etc/ssh/sshd_config 2>/dev/null; then
    log_finding "Found malicious SSH config: PermitRootLogin yes"
    CONFIG_FINDINGS=$((CONFIG_FINDINGS + 1))
fi

if grep -q "128.90.59.19" /etc/hosts 2>/dev/null; then
    log_finding "Found malicious hosts entry: 128.90.59.19"
    CONFIG_FINDINGS=$((CONFIG_FINDINGS + 1))
fi

if [ $CONFIG_FINDINGS -eq 0 ]; then
    log_clean "No malicious config modifications found"
fi

# 5. Check for Fake Users (from offense/scripts)
echo -e "\n${YELLOW}[5/8] Checking for Fake Users...${NC}"
FAKE_USERS=("mattdamon" "peter" "parker" "yourmom" "gandalf" "tonystark" "batman" "spiderman" "joker" "loki" "frodo" "sauron" "thanos" "deadpool" "drstrange" "neo" "trinity" "morpheus" "johnwick" "yoda" "vader" "obiwan" "skywalker" "terminator" "ragnar" "ezio" "altair" "kratos" "agent47" "geralt")
FOUND_USERS=()

for user in "${FAKE_USERS[@]}"; do
    if id "$user" >/dev/null 2>&1; then
        log_finding "Found fake user: $user"
        FOUND_USERS+=("$user")
        id "$user" >> /tmp/fake_users.txt
    fi
done

if [ ${#FOUND_USERS[@]} -eq 0 ]; then
    log_clean "No fake users found"
fi

# 6. Check for Log Wiping (from offense/scripts)
echo -e "\n${YELLOW}[6/8] Checking for Log Wiping...${NC}"
if grep -r "hi there buddy!" /var/log/ 2>/dev/null; then
    log_finding "Found evidence of log wiping: 'hi there buddy!' in logs"
    grep -r "hi there buddy!" /var/log/ 2>/dev/null >> /tmp/log_wiping.txt
else
    log_clean "No evidence of log wiping found"
fi

# 7. Check for C2 Communication (from c2.cpp, cronjob.cpp)
echo -e "\n${YELLOW}[7/8] Checking for C2 Communication...${NC}"
C2_FINDINGS=0

# Check for YouTube-based C2 URLs
if grep -r "aHR0cHM6Ly93d3cueW91dHViZS5jb20vd2F0Y2g" /tmp /var/tmp /home/*/.bash_history 2>/dev/null; then
    log_finding "Found base64 encoded YouTube C2 URL"
    C2_FINDINGS=$((C2_FINDINGS + 1))
fi

# Check for suspicious curl/wget processes
if pgrep -f "curl.*youtube" >/dev/null || pgrep -f "wget.*youtube" >/dev/null; then
    log_finding "Found suspicious YouTube-related network activity"
    C2_FINDINGS=$((C2_FINDINGS + 1))
fi

# Check for suspicious network connections
if netstat -tuln 2>/dev/null | grep -E "(80|443|53)" | grep -v "127.0.0.1" >/dev/null; then
    log_finding "Found suspicious outbound connections"
    netstat -tuln 2>/dev/null | grep -E "(80|443|53)" | grep -v "127.0.0.1" >> /tmp/suspicious_connections.txt
    C2_FINDINGS=$((C2_FINDINGS + 1))
fi

if [ $C2_FINDINGS -eq 0 ]; then
    log_clean "No C2 communication detected"
fi

# 8. Check for Web-Based Attacks (from your offensive tools)
echo -e "\n${YELLOW}[8/8] Checking for Web-Based Attacks...${NC}"
WEB_FINDINGS=0

# Check for Hackwave Havoc deployment
if [ -f "/var/www/html/index.html" ] && grep -q "Hackwave Havoc" /var/www/html/index.html 2>/dev/null; then
    log_finding "Found Hackwave Havoc offensive website deployed"
    WEB_FINDINGS=$((WEB_FINDINGS + 1))
fi

# Check for The Annoying Site deployment
if [ -f "/var/www/html/index.js" ] && grep -q "The Annoying Site" /var/www/html/index.js 2>/dev/null; then
    log_finding "Found The Annoying Site offensive website deployed"
    WEB_FINDINGS=$((WEB_FINDINGS + 1))
fi

if [ $WEB_FINDINGS -eq 0 ]; then
    log_clean "No offensive websites detected"
fi

# 9. Check for ThunderStorm C2 (NEW - Based on ThunderStorm-main analysis)
echo -e "\n${YELLOW}[9/9] Checking for ThunderStorm C2...${NC}"
THUNDERSTORM_FINDINGS=0

# Check for ThunderStorm processes
THUNDERSTORM_PROCESSES=("bolt" "cirrus" "doppler" "jetstream" "cloudseed" "flurry" "guard")
for proc in "${THUNDERSTORM_PROCESSES[@]}"; do
    if pgrep -f "$proc" >/dev/null; then
        log_finding "Found ThunderStorm C2 process: $proc"
        THUNDERSTORM_FINDINGS=$((THUNDERSTORM_FINDINGS + 1))
    fi
done

# Check for Guardian pipes (ThunderStorm persistence)
if find /tmp -name "*guard*" -type p 2>/dev/null | grep -q .; then
    log_finding "Found ThunderStorm Guardian pipes"
    THUNDERSTORM_FINDINGS=$((THUNDERSTORM_FINDINGS + 1))
fi

# Check for Cirrus web interface (port 7777)
if netstat -tuln 2>/dev/null | grep ":7777" >/dev/null; then
    log_finding "Found ThunderStorm Cirrus C2 on port 7777"
    THUNDERSTORM_FINDINGS=$((THUNDERSTORM_FINDINGS + 1))
fi

# Check for encrypted files (Flurry persistence)
if find /tmp /var/tmp /home -name "*.enc" -o -name "*.xor" 2>/dev/null | grep -q .; then
    log_finding "Found ThunderStorm Flurry encrypted files"
    THUNDERSTORM_FINDINGS=$((THUNDERSTORM_FINDINGS + 1))
fi

if [ $THUNDERSTORM_FINDINGS -eq 0 ]; then
    log_clean "No ThunderStorm C2 detected"
fi

# Summary
echo -e "\n${YELLOW}=================================="
echo "🔍 THREAT HUNT SUMMARY"
echo "==================================${NC}"

if [ -f "/tmp/threat_hunt.log" ]; then
    echo -e "${RED}Found $(wc -l < /tmp/threat_hunt.log) potential threats${NC}"
    echo -e "${BLUE}Full log: /tmp/threat_hunt.log${NC}"
else
    echo -e "${GREEN}No threats detected!${NC}"
fi

# ThunderStorm-specific summary
if [ $THUNDERSTORM_FINDINGS -gt 0 ]; then
    echo -e "\n${PURPLE}⚡ THUNDERSTORM C2 DETECTED!${NC}"
    echo -e "${RED}Run: ./defense/thunderstorm_hunter.sh for detailed analysis${NC}"
    echo -e "${RED}Use: ./defense/thunderstorm_response_guide.md for removal${NC}"
fi

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Review findings in /tmp/threat_hunt.log"
echo "2. Remove any detected persistence"
echo "3. Monitor for new threats"
echo "4. Keep services running for scoring"

echo -e "\n${GREEN}✅ Day 1 Threat Hunter Complete!${NC}" 