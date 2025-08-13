# Cross-Platform Defense Toolkit for PVJ CTF

## Overview
This toolkit provides cross-platform solutions for Day 1 defense when you don't know which machine/service you'll be responsible for. All tools work on both Windows and Linux.

## Core Philosophy
- **Portable**: No installation required, runs from USB/external drive
- **Cross-platform**: Works on Windows and Linux
- **Lightweight**: Minimal dependencies
- **Stealth**: Low footprint, doesn't interfere with services
- **Flexible**: Adapts to unknown environments

## Essential Tools by Category

### 1. System Reconnaissance
**Windows:**
```powershell
# Quick system info
systeminfo
wmic computersystem get name,domain,workgroup
wmic os get caption,version,osarchitecture

# Network info
ipconfig /all
netstat -an
netstat -an | findstr LISTENING

# Process info
tasklist /v
wmic process get name,processid,commandline
```

**Linux:**
```bash
# Quick system info
uname -a
cat /etc/os-release
hostname -f

# Network info
ip addr show
netstat -tuln
ss -tuln

# Process info
ps aux
ps -ef
```

### 2. Service Monitoring
**Cross-platform Python script:**
```python
#!/usr/bin/env python3
import psutil
import time
import json
from datetime import datetime

def monitor_services():
    while True:
        services = {}
        for proc in psutil.process_iter(['pid', 'name', 'cmdline']):
            try:
                services[proc.info['pid']] = {
                    'name': proc.info['name'],
                    'cmdline': ' '.join(proc.info['cmdline']) if proc.info['cmdline'] else ''
                }
            except (psutil.NoSuchProcess, psutil.AccessDenied):
                pass
        
        with open(f'services_{datetime.now().strftime("%Y%m%d_%H%M%S")}.json', 'w') as f:
            json.dump(services, f, indent=2)
        
        time.sleep(60)  # Check every minute

if __name__ == "__main__":
    monitor_services()
```

### 3. Network Monitoring
**Cross-platform netstat wrapper:**
```python
#!/usr/bin/env python3
import subprocess
import json
import time
from datetime import datetime

def get_network_connections():
    try:
        # Cross-platform netstat
        if os.name == 'nt':  # Windows
            result = subprocess.run(['netstat', '-an'], capture_output=True, text=True)
        else:  # Linux/Unix
            result = subprocess.run(['netstat', '-tuln'], capture_output=True, text=True)
        
        connections = []
        for line in result.stdout.split('\n'):
            if line.strip() and not line.startswith('Proto'):
                connections.append(line.strip())
        
        return connections
    except Exception as e:
        return [f"Error: {str(e)}"]

def monitor_network():
    while True:
        connections = get_network_connections()
        with open(f'network_{datetime.now().strftime("%Y%m%d_%H%M%S")}.json', 'w') as f:
            json.dump({'connections': connections}, f, indent=2)
        time.sleep(30)  # Check every 30 seconds

if __name__ == "__main__":
    monitor_network()
```

### 4. File System Monitoring
**Cross-platform file watcher:**
```python
#!/usr/bin/env python3
import os
import time
import hashlib
from datetime import datetime

def get_file_hash(filepath):
    try:
        with open(filepath, 'rb') as f:
            return hashlib.md5(f.read()).hexdigest()
    except:
        return None

def monitor_critical_paths():
    critical_paths = [
        '/etc/init.d', '/etc/systemd', '/etc/cron.d',  # Linux
        'C:\\Windows\\System32', 'C:\\ProgramData',    # Windows
        '/tmp', '/var/tmp',                            # Common temp
        '/home', '/root'                               # User dirs
    ]
    
    file_hashes = {}
    
    while True:
        changes = []
        for path in critical_paths:
            if os.path.exists(path):
                for root, dirs, files in os.walk(path):
                    for file in files:
                        filepath = os.path.join(root, file)
                        current_hash = get_file_hash(filepath)
                        
                        if filepath in file_hashes:
                            if file_hashes[filepath] != current_hash:
                                changes.append({
                                    'file': filepath,
                                    'old_hash': file_hashes[filepath],
                                    'new_hash': current_hash,
                                    'timestamp': datetime.now().isoformat()
                                })
                        
                        file_hashes[filepath] = current_hash
        
        if changes:
            with open(f'file_changes_{datetime.now().strftime("%Y%m%d_%H%M%S")}.json', 'w') as f:
                json.dump(changes, f, indent=2)
        
        time.sleep(60)  # Check every minute

if __name__ == "__main__":
    monitor_critical_paths()
```

### 5. ThunderStorm-Specific Detection
**Cross-platform ThunderStorm hunter:**
```python
#!/usr/bin/env python3
import os
import json
import subprocess
from datetime import datetime

def check_thunderstorm_indicators():
    indicators = {
        'processes': [
            'bolt', 'cirrus', 'flurry', 'guardian', 'doppler',
            'jetstream', 'cloudseed', 'thunderstorm'
        ],
        'files': [
            '/tmp/bolt', '/tmp/cirrus', '/tmp/flurry',
            'C:\\temp\\bolt.exe', 'C:\\temp\\cirrus.exe'
        ],
        'ports': [8080, 8443, 9000, 9001],  # Common ThunderStorm ports
        'registry_keys': [
            'HKEY_CURRENT_USER\\Software\\ThunderStorm',
            'HKEY_LOCAL_MACHINE\\SOFTWARE\\ThunderStorm'
        ]
    }
    
    findings = []
    
    # Check processes
    try:
        if os.name == 'nt':
            result = subprocess.run(['tasklist'], capture_output=True, text=True)
        else:
            result = subprocess.run(['ps', 'aux'], capture_output=True, text=True)
        
        for indicator in indicators['processes']:
            if indicator.lower() in result.stdout.lower():
                findings.append(f"ThunderStorm process found: {indicator}")
    except:
        pass
    
    # Check files
    for file_path in indicators['files']:
        if os.path.exists(file_path):
            findings.append(f"ThunderStorm file found: {file_path}")
    
    # Check ports
    try:
        if os.name == 'nt':
            result = subprocess.run(['netstat', '-an'], capture_output=True, text=True)
        else:
            result = subprocess.run(['netstat', '-tuln'], capture_output=True, text=True)
        
        for port in indicators['ports']:
            if f":{port}" in result.stdout:
                findings.append(f"ThunderStorm port found: {port}")
    except:
        pass
    
    return findings

def run_thunderstorm_hunt():
    while True:
        findings = check_thunderstorm_indicators()
        if findings:
            with open(f'thunderstorm_findings_{datetime.now().strftime("%Y%m%d_%H%M%S")}.json', 'w') as f:
                json.dump(findings, f, indent=2)
        
        time.sleep(30)  # Check every 30 seconds

if __name__ == "__main__":
    run_thunderstorm_hunt()
```

### 6. Quick Response Scripts

**Windows cleanup script:**
```powershell
# Remove suspicious processes
Get-Process | Where-Object {$_.ProcessName -like "*bolt*" -or $_.ProcessName -like "*cirrus*"} | Stop-Process -Force

# Remove suspicious files
Remove-Item "C:\temp\bolt.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "C:\temp\cirrus.exe" -Force -ErrorAction SilentlyContinue

# Clear temp directories
Remove-Item "C:\temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

# Check for persistence
Get-WmiObject -Class Win32_StartupCommand | Where-Object {$_.Command -like "*bolt*" -or $_.Command -like "*cirrus*"} | Remove-WmiObject
```

**Linux cleanup script:**
```bash
#!/bin/bash
# Remove suspicious processes
pkill -f bolt
pkill -f cirrus
pkill -f flurry
pkill -f guardian

# Remove suspicious files
rm -f /tmp/bolt /tmp/cirrus /tmp/flurry /tmp/guardian
rm -f /var/tmp/bolt /var/tmp/cirrus

# Clear temp directories
rm -rf /tmp/* /var/tmp/*

# Check for persistence
crontab -l | grep -v "bolt\|cirrus" | crontab -
systemctl list-unit-files | grep enabled | grep -E "(bolt|cirrus)" | awk '{print $1}' | xargs -I {} systemctl disable {}
```

### 7. Portable Tools to Bring

**Essential binaries (pre-compiled):**
- `netcat` (nc) - Network connectivity testing
- `curl` - HTTP requests and file transfers
- `wget` - Alternative to curl
- `nmap` - Network scanning
- `tcpdump` - Packet capture
- `strings` - Extract strings from binaries
- `file` - File type identification
- `md5sum`/`sha256sum` - File hashing

**Python scripts (portable):**
- Service monitor
- Network monitor
- File system monitor
- ThunderStorm hunter
- Log parser
- Beacon detector

**Windows-specific:**
- `Sysinternals Suite` (portable)
- `Process Explorer`
- `Process Monitor`
- `Autoruns`
- `TCPView`

### 8. Deployment Strategy

**USB Drive Structure:**
```
defense_toolkit/
├── windows/
│   ├── tools/
│   ├── scripts/
│   └── binaries/
├── linux/
│   ├── tools/
│   ├── scripts/
│   └── binaries/
├── cross_platform/
│   ├── python_scripts/
│   └── configs/
└── README.md
```

**Quick setup script:**
```bash
#!/bin/bash
# Cross-platform setup
echo "Setting up defense toolkit..."

# Create monitoring directories
mkdir -p /tmp/defense_logs
mkdir -p /var/log/defense

# Start monitoring scripts
python3 service_monitor.py &
python3 network_monitor.py &
python3 thunderstorm_hunter.py &

echo "Defense toolkit deployed!"
```

### 9. Communication Protocol

**Team coordination:**
- Use shared Google Doc/Notion for findings
- Slack/Discord for real-time communication
- Regular check-ins every 15 minutes
- Escalation procedures for critical findings

**Documentation template:**
```
Machine: [hostname]
OS: [Windows/Linux version]
Role: [DNS/Firewall/Web/DB/etc]
Status: [Green/Yellow/Red]
Findings: [List of suspicious activity]
Actions: [What was done]
Next: [What needs to be done]
```

### 10. Emergency Procedures

**If machine is compromised:**
1. Document everything before touching
2. Take screenshots/photos
3. Stop suspicious processes
4. Remove persistence mechanisms
5. Verify service functionality
6. Monitor for re-infection

**If service is down:**
1. Check if it's a Red Team attack
2. Verify configuration changes
3. Restart service if safe
4. Document incident
5. Monitor for recurrence

## Success Metrics
- **Zero service downtime** from Red Team activity
- **Quick detection** of ThunderStorm persistence
- **Rapid response** to new threats
- **Team coordination** effectiveness
- **Documentation quality** for post-game analysis

Remember: **Keep it simple, focus on basics, and work as a team!** 