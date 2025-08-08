# Quick Reference Card - Blue Team Strategy

## 🎯 Core Strategy
**"Quick wins first, then threat hunting, then hardening"**

## 📋 Phase 1: Immediate Response (First 30 min)
1. **Service Assessment & Backup**
   - Check what services are running
   - Backup configs offline
   - Get scored services up

2. **Account Audit & Lockdown**
   - `net user` (Windows) / `cat /etc/passwd` (Linux)
   - Kill all accounts except yours
   - Change all passwords

3. **Password Updates**
   - Change default passwords immediately
   - Use strong passwords

## 🔍 Phase 2: Persistence Removal (Next 30 min)
1. **GPO Audit** (Windows)
   - `gpresult /r`
   - Look for suspicious GPOs

2. **Scheduled Tasks Audit**
   - `schtasks /query` (Windows)
   - `crontab -l` (Linux)

3. **Malware Removal**
   - Use our enhanced tools
   - `./linux_defense_tools.sh cleanup`
   - `windows_defense_tools.bat cleanup`

## ⚡ Phase 3: Quick Wins (Next 30 min)
1. **Active Connection Termination**
   - Kill suspicious network connections
   - Block C2 traffic

2. **Service Hardening**
   - Basic SSH/RDP hardening
   - Firewall configuration

3. **Firewall Setup**
   - Allow only necessary ports
   - Block suspicious traffic

## 🕵️ Phase 4: Threat Hunting (Ongoing)
1. **Continuous Monitoring**
   - Start monitoring tools in background
   - Watch for re-infection

2. **Advanced Detection**
   - Binary integrity checks
   - Process monitoring
   - Network monitoring

## 🎯 Phase 5: Offensive Prep (Day 2)
1. **Reconnaissance**
   - Scan other teams
   - Look for default creds

2. **Vulnerability Assessment**
   - Find unhardened services
   - Identify attack vectors

3. **Beacon Deployment**
   - Get access to other team machines
   - Deploy beacons for points

## 🛠️ Essential Commands

### Windows Quick Commands
```cmd
# Service check
sc query | findstr "RUNNING"

# Account audit
net user

# Process check
tasklist | findstr "dolphin bolt cirrus"

# Network check
netstat -an | findstr ":8080 :8443 :9000"

# Registry check
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
```

### Linux Quick Commands
```bash
# Service check
systemctl status --all | grep active

# Account audit
cat /etc/passwd | grep -E ":/bin/bash|:/bin/sh"

# Process check
ps aux | grep -i "dolphin\|bolt\|cirrus"

# Network check
netstat -tuln | grep -E ":(8080|8443|9000|9001)"

# Cron check
crontab -l
```

## 📊 Success Metrics
- **Zero service downtime**
- **Quick persistence removal** (< 30 min)
- **Stable service availability** (95%+ uptime)
- **Effective team coordination**

## 🚨 Critical Priorities
1. **Keep scored services running**
2. **Remove obvious Red Team presence**
3. **Communicate with team constantly**
4. **Document everything**

## 💡 Key Insights
- **Points win the game** - Focus on service uptime
- **Quick wins matter** - Remove obvious threats first
- **Team coordination** - Don't work in isolation
- **Backup everything** - Before making changes

## 🎯 Remember
**"Quick wins first, then threat hunting, then hardening"**

**Good luck, Blue Team! 🛡️** 