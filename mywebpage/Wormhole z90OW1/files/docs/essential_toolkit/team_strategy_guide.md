# Blue Team Strategy Guide for PVJ CTF

## Core Philosophy
**"Quick wins first, then threat hunting, then hardening"**

The goal is to **maximize points** by keeping services up while systematically removing Red Team persistence.

## Phase 1: Immediate Response (First 30 minutes)

### 1. Service Assessment & Backup
```bash
# Linux
systemctl status --all | grep -E "(active|running)"
cp /etc/ssh/sshd_config /root/sshd_config.backup
cp /etc/apache2/apache2.conf /root/apache2.conf.backup

# Windows
sc query | findstr "RUNNING"
copy C:\Windows\System32\drivers\etc\hosts C:\backup\hosts.backup
```

**Priority:** Get scored services running and create offline backups

### 2. Account Audit & Lockdown
```bash
# Linux - Kill all accounts except yours
cat /etc/passwd | grep -E ":/bin/bash|:/bin/sh"
userdel suspicioususer 2>/dev/null
passwd -l suspicioususer 2>/dev/null

# Windows - Audit accounts
net user
net user suspicioususer /delete
```

**Critical:** Remove unauthorized accounts immediately

### 3. Password Updates
```bash
# Linux
passwd
echo "root:NewSecurePassword123!" | chpasswd

# Windows
net user administrator NewSecurePassword123!
```

**Priority:** Change all default passwords

## Phase 2: Persistence Removal (Next 30 minutes)

### 1. GPO Audit (Windows)
```cmd
gpresult /r
gpresult /h report.html
# Look for suspicious GPOs that create accounts or run scripts
```

### 2. Scheduled Tasks Audit
```cmd
# Windows
schtasks /query /fo table | findstr /i "suspicious\|bolt\|cirrus\|dolphin"

# Linux
crontab -l
ls -la /etc/cron.*/
```

### 3. Malware Removal
```bash
# Use our enhanced tools
./linux_defense_tools.sh cleanup
# or
windows_defense_tools.bat cleanup
```

## Phase 3: Quick Wins (Next 30 minutes)

### 1. Active Connection Termination
```bash
# Linux - Kill suspicious connections
netstat -tuln | grep -E ":(8080|8443|9000|9001|4444|1337)"
kill -9 $(lsof -ti:8080,8443,9000,9001,4444,1337)

# Windows - Kill suspicious connections
netstat -an | findstr ":8080 :8443 :9000 :9001 :4444 :1337"
taskkill /F /PID [PID]
```

### 2. Service Hardening
```bash
# SSH Hardening (Linux)
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

# RDP Hardening (Windows)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
```

### 3. Firewall Configuration
```bash
# Linux - Basic firewall
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -j DROP

# Windows - Basic firewall
netsh advfirewall set allprofiles state on
netsh advfirewall firewall add rule name="Allow SSH" dir=in action=allow protocol=TCP localport=22
```

## Phase 4: Threat Hunting (Ongoing)

### 1. Continuous Monitoring
```bash
# Start monitoring in background
./linux_defense_tools.sh monitor 30 &
# or
start /B windows_defense_tools.bat monitor 30
```

### 2. Advanced Detection
- **Binary integrity checks** - Look for replaced system files
- **Process monitoring** - Watch for dolphin.exe, suspicious processes
- **Network monitoring** - Monitor for C2 connections
- **File system monitoring** - Watch for new suspicious files

## Phase 5: Offensive Preparation (Day 2)

### 1. Reconnaissance
```bash
# Scan other teams for default credentials
nmap -p 22,3389 [other_team_ips]
ssh root@[ip] -o ConnectTimeout=5
rdesktop [ip] -u administrator -p password
```

### 2. Vulnerability Assessment
```bash
# Check for unhardened services
nmap -sV -sC [target_ips]
# Look for default configurations, open ports, weak services
```

### 3. Beacon Deployment
```bash
# Once you get access to other team's machines
curl -X POST http://scorebot:8080/beacon -d "team=yourteam&host=targetip"
# or use the official beacon mechanism
```

## Collection Tools Strategy

### Linux Collection
```bash
# UAC (User Account Control) equivalent for Linux
# Monitor privilege escalation attempts
auditd -f
# or custom script to monitor sudo usage
```

### Windows Collection
```bash
# Velociraptor offline collector
# Monitor process creation, file access, network connections
# Focus on detection rules that EDR would flag
```

### Learning Opportunities
- **EDR detection rules** - Understand what triggers alerts
- **Syslog monitoring** - Centralized logging and analysis
- **Event auditing** - Windows Event Log analysis
- **Network forensics** - Packet capture and analysis

## Team Coordination

### Communication Protocol
- **Slack/Discord:** `#blue-team-strategy`
- **Status updates:** Every 15 minutes
- **Escalation:** Immediate for critical findings

### Role Assignment
1. **Service Manager** - Keep scored services running
2. **Threat Hunter** - Remove Red Team persistence
3. **Network Defender** - Monitor and block suspicious traffic
4. **Offensive Player** - Prepare for Day 2 attacks

### Documentation Template
```
Machine: [hostname]
Phase: [1-5]
Status: [Green/Yellow/Red]
Services: [List running scored services]
Findings: [Red Team artifacts found]
Actions: [What was done]
Next: [What needs to be done]
```

## Success Metrics

### Day 1 Goals
- **Zero service downtime** from Red Team activity
- **Quick persistence removal** (< 30 minutes)
- **Stable service availability** (95%+ uptime)
- **Team coordination** effectiveness

### Day 2 Goals
- **Successful reconnaissance** of other teams
- **Effective beacon deployment** on other team machines
- **Point maximization** through service uptime + offensive success

## Key Tactical Insights

### Why This Strategy Works
1. **Quick wins first** - Immediate impact on scoring
2. **Systematic approach** - Don't get overwhelmed
3. **Service focus** - Points come from service availability
4. **Offensive preparation** - Day 2 advantage

### Common Pitfalls to Avoid
1. **Over-engineering** - Keep it simple
2. **Ignoring services** - Focus on scored services first
3. **Working in isolation** - Coordinate with team
4. **Forgetting backups** - Always backup before changes

### Advanced Techniques
1. **Binary integrity** - Check for replaced system files
2. **Process injection** - Look for DLL injection
3. **Memory analysis** - Check for in-memory malware
4. **Network forensics** - Monitor for C2 traffic

## Remember
- **Points win the game** - Keep services up
- **Quick wins matter** - Remove obvious Red Team presence
- **Team coordination** - Communicate constantly
- **Document everything** - For post-game analysis

**Good luck, Blue Team! Let's dominate this CTF! 🛡️** 