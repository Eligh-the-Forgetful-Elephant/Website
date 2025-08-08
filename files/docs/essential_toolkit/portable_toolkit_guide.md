# Portable Defense Toolkit Guide for PVJ CTF

## Overview
This toolkit provides **platform-specific tools** that work on both Windows and Linux using only built-in commands. No external dependencies required!

## What You Need to Bring

### USB Drive Structure
```
defense_toolkit/
├── windows/
│   ├── windows_defense_tools.bat
│   └── README.md
├── linux/
│   ├── linux_defense_tools.sh
│   └── README.md
├── docs/
│   ├── cross_platform_toolkit.md
│   ├── thunderstorm_intel.md
│   └── thunderstorm_response_guide.md
└── README.md
```

### Essential Portable Tools
**Bring these pre-compiled binaries:**
- `netcat` (nc) - Network connectivity testing
- `curl` - HTTP requests and file transfers
- `wget` - Alternative to curl
- `nmap` - Network scanning
- `tcpdump` - Packet capture
- `strings` - Extract strings from binaries
- `file` - File type identification
- `md5sum`/`sha256sum` - File hashing

**Windows-specific tools:**
- `Sysinternals Suite` (portable) - Process Explorer, Process Monitor, Autoruns
- `TCPView` - Network connections
- `PsExec` - Remote execution

## How to Use the Tools

### Windows Tools
**File:** `windows_defense_tools.bat`

**Commands:**
```cmd
# Continuous monitoring (check every 60 seconds)
windows_defense_tools.bat monitor

# Continuous monitoring (check every 30 seconds)
windows_defense_tools.bat monitor 30

# Comprehensive ThunderStorm hunt
windows_defense_tools.bat hunt

# Quick system check
windows_defense_tools.bat quickcheck

# Remove ThunderStorm artifacts
windows_defense_tools.bat cleanup
```

**What it checks:**
- Suspicious processes (bolt, cirrus, flurry, guardian, etc.)
- Network connections on suspicious ports (8080, 8443, 9000, 9001, 4444, 1337)
- ThunderStorm files in common locations
- Registry persistence mechanisms
- Windows services
- Startup folders

### Linux Tools
**File:** `linux_defense_tools.sh`

**Commands:**
```bash
# Make executable
chmod +x linux_defense_tools.sh

# Continuous monitoring (check every 60 seconds)
./linux_defense_tools.sh monitor

# Continuous monitoring (check every 30 seconds)
./linux_defense_tools.sh monitor 30

# Comprehensive ThunderStorm hunt
./linux_defense_tools.sh hunt

# Quick system check
./linux_defense_tools.sh quickcheck

# Remove ThunderStorm artifacts
./linux_defense_tools.sh cleanup
```

**What it checks:**
- Suspicious processes (bolt, cirrus, flurry, guardian, etc.)
- Network connections on suspicious ports
- ThunderStorm files in common locations
- Systemd services
- Cron jobs
- Startup scripts (rc.local, init.d)

## Day 1 Strategy

### Initial Assessment (First 15 minutes)
1. **Identify your machine type:**
   ```bash
   # Linux
   uname -a
   
   # Windows
   systeminfo | findstr "OS Name"
   ```

2. **Run quick check:**
   ```bash
   # Linux
   ./linux_defense_tools.sh quickcheck
   
   # Windows
   windows_defense_tools.bat quickcheck
   ```

3. **Start continuous monitoring:**
   ```bash
   # Linux
   ./linux_defense_tools.sh monitor 30 &
   
   # Windows
   start /B windows_defense_tools.bat monitor 30
   ```

### Threat Hunting (Next 30 minutes)
1. **Run comprehensive hunt:**
   ```bash
   # Linux
   ./linux_defense_tools.sh hunt
   
   # Windows
   windows_defense_tools.bat hunt
   ```

2. **Document findings:**
   - Take screenshots of suspicious activity
   - Note file locations and process IDs
   - Record network connections

### Response Actions
1. **If ThunderStorm found:**
   ```bash
   # Linux
   ./linux_defense_tools.sh cleanup
   
   # Windows
   windows_defense_tools.bat cleanup
   ```

2. **Verify service functionality:**
   - Check if scored services are still running
   - Test network connectivity
   - Verify DNS resolution

3. **Monitor for re-infection:**
   - Keep monitoring tools running
   - Check logs every 15 minutes
   - Report findings to team

## Team Coordination

### Communication Protocol
- **Slack/Discord channel:** `#blue-team-defense`
- **Check-ins:** Every 15 minutes
- **Escalation:** Immediate for critical findings

### Documentation Template
```
Machine: [hostname]
OS: [Windows/Linux version]
Role: [DNS/Firewall/Web/DB/etc]
Status: [Green/Yellow/Red]
Findings: [List of suspicious activity]
Actions: [What was done]
Next: [What needs to be done]
```

### Status Codes
- **Green:** No suspicious activity, services running
- **Yellow:** Suspicious activity detected, investigating
- **Red:** Confirmed compromise, services down

## Emergency Procedures

### If Machine is Compromised
1. **Document everything** before touching
2. **Take screenshots/photos** of suspicious activity
3. **Stop suspicious processes** using cleanup tools
4. **Remove persistence mechanisms**
5. **Verify service functionality**
6. **Monitor for re-infection**

### If Service is Down
1. **Check if it's a Red Team attack**
2. **Verify configuration changes**
3. **Restart service if safe**
4. **Document incident**
5. **Monitor for recurrence**

## Success Metrics
- **Zero service downtime** from Red Team activity
- **Quick detection** of ThunderStorm persistence (< 5 minutes)
- **Rapid response** to new threats (< 2 minutes)
- **Team coordination** effectiveness
- **Documentation quality** for post-game analysis

## Tips for Success

### Before the Game
1. **Test your tools** on both Windows and Linux VMs
2. **Practice the commands** until they're muscle memory
3. **Prepare your USB drive** with all tools
4. **Set up team communication** channels

### During the Game
1. **Keep it simple** - focus on basics first
2. **Work as a team** - communicate constantly
3. **Document everything** - you'll need it later
4. **Stay calm** - stress leads to mistakes
5. **Ask for help** - don't get stuck on one problem

### Common Pitfalls to Avoid
1. **Don't over-engineer** - simple tools work better
2. **Don't ignore alerts** - investigate everything
3. **Don't work in isolation** - coordinate with team
4. **Don't forget services** - keep scored services running
5. **Don't panic** - methodical approach wins

## Quick Reference Commands

### Windows Quick Commands
```cmd
# Check processes
tasklist | findstr "bolt cirrus flurry"

# Check network
netstat -an | findstr ":8080 :8443 :9000"

# Check files
dir C:\temp\bolt.exe
dir C:\Windows\Temp\cirrus.exe

# Check registry
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
```

### Linux Quick Commands
```bash
# Check processes
ps aux | grep -i "bolt\|cirrus\|flurry"

# Check network
netstat -tuln | grep ":8080\|:8443\|:9000"

# Check files
ls -la /tmp/bolt /tmp/cirrus

# Check services
systemctl list-units --type=service | grep -i "bolt\|cirrus"
```

## Remember
- **Keep it simple, focus on basics, and work as a team!**
- **The goal is to maintain service availability while removing Red Team persistence**
- **Document everything - you'll need it for the post-game analysis**
- **Stay calm and methodical - panic leads to mistakes**

Good luck, Blue Team! 🛡️ 