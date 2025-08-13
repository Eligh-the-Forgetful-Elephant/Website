# Advanced Threat Intelligence for PVJ CTF

## Real-World Red Team Persistence Techniques

Based on actual CTF experience, the Red Team uses sophisticated persistence that goes beyond basic C2 implants.

## Windows Persistence Mechanisms

### 1. GPO-Based Account Creation
**What it does:** Group Policy Objects that continuously create accounts
**Detection:**
```cmd
# Check for suspicious GPOs
gpresult /r
gpresult /h report.html

# Check for new accounts
net user
wmic useraccount get name,disabled,lockout

# Check for account creation events
wevtutil qe Security /q:"*[System[EventID=4720]]" /c:10 /f:text
```

### 2. Dolphin Malware (Task Manager Replacement)
**What it does:** Replaces taskmgr.exe with malicious binary
**Detection:**
```cmd
# Check if taskmgr.exe is legitimate
dir C:\Windows\System32\taskmgr.exe
certutil -dump C:\Windows\System32\taskmgr.exe

# Check for multiple dolphin.exe processes
tasklist | findstr dolphin
wmic process where "name='dolphin.exe'" get processid,commandline

# Check file hashes
certutil -hashfile C:\Windows\System32\taskmgr.exe MD5
```

### 3. Registry Persistence
**Common locations:**
```cmd
# Check all persistence locations
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce"
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run"
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run"
```

### 4. Scheduled Tasks
**Detection:**
```cmd
# List all scheduled tasks
schtasks /query /fo table

# Check for suspicious tasks
schtasks /query /fo table | findstr /i "dolphin bolt cirrus flurry guardian"

# Check task details
schtasks /query /tn "SuspiciousTask" /fo list
```

### 5. Service Persistence
**Detection:**
```cmd
# Check for suspicious services
sc query | findstr /i "dolphin bolt cirrus flurry guardian"

# Check service details
sc qc "SuspiciousService"
```

## Linux Persistence Mechanisms

### 1. Binary Replacement
**What it does:** Replaces system binaries with malicious versions
**Detection:**
```bash
# Check for replaced binaries
ls -la /bin/taskmgr /usr/bin/taskmgr 2>/dev/null
file /bin/taskmgr /usr/bin/taskmgr 2>/dev/null

# Check for dolphin processes
ps aux | grep -i dolphin
pgrep -f dolphin

# Check file hashes
md5sum /bin/taskmgr /usr/bin/taskmgr 2>/dev/null
```

### 2. Advanced Cron Jobs
**Detection:**
```bash
# Check all cron locations
crontab -l
ls -la /etc/cron.d/
ls -la /etc/cron.daily/
ls -la /etc/cron.hourly/
ls -la /etc/cron.monthly/
ls -la /etc/cron.weekly/

# Check for suspicious cron entries
crontab -l | grep -i "dolphin\|bolt\|cirrus\|flurry"
```

### 3. Systemd Service Persistence
**Detection:**
```bash
# Check for suspicious services
systemctl list-units --type=service | grep -i "dolphin\|bolt\|cirrus\|flurry"

# Check service files
ls -la /etc/systemd/system/ | grep -i "dolphin\|bolt\|cirrus\|flurry"
ls -la /lib/systemd/system/ | grep -i "dolphin\|bolt\|cirrus\|flurry"
```

### 4. Binary Infection
**What it does:** Infects legitimate binaries with malicious code
**Detection:**
```bash
# Check for suspicious strings in binaries
strings /bin/ls | grep -i "dolphin\|bolt\|cirrus\|flurry"
strings /usr/bin/ps | grep -i "dolphin\|bolt\|cirrus\|flurry"

# Check for unusual file sizes
ls -la /bin/ /usr/bin/ | awk '$5 > 1000000 {print $0}'
```

## Enhanced Detection Strategy

### Windows Enhanced Commands
```cmd
# Comprehensive persistence check
echo === GPO CHECK ===
gpresult /r | findstr /i "bolt\|cirrus\|flurry\|dolphin"

echo === ACCOUNT CHECK ===
net user | findstr /i "bolt\|cirrus\|flurry\|dolphin"

echo === TASK MANAGER CHECK ===
dir C:\Windows\System32\taskmgr.exe
tasklist | findstr dolphin

echo === SCHEDULED TASKS ===
schtasks /query /fo table | findstr /i "dolphin\|bolt\|cirrus\|flurry"

echo === SERVICES ===
sc query | findstr /i "dolphin\|bolt\|cirrus\|flurry"

echo === REGISTRY PERSISTENCE ===
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" | findstr /i "dolphin\|bolt\|cirrus\|flurry"
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" | findstr /i "dolphin\|bolt\|cirrus\|flurry"
```

### Linux Enhanced Commands
```bash
# Comprehensive persistence check
echo "=== BINARY REPLACEMENT CHECK ==="
ls -la /bin/ /usr/bin/ | grep -i "dolphin\|bolt\|cirrus\|flurry"

echo "=== PROCESS CHECK ==="
ps aux | grep -i "dolphin\|bolt\|cirrus\|flurry" | grep -v grep

echo "=== CRON CHECK ==="
crontab -l 2>/dev/null | grep -i "dolphin\|bolt\|cirrus\|flurry"
find /etc/cron.* -name "*" -exec grep -l -i "dolphin\|bolt\|cirrus\|flurry" {} \; 2>/dev/null

echo "=== SERVICE CHECK ==="
systemctl list-units --type=service | grep -i "dolphin\|bolt\|cirrus\|flurry"

echo "=== BINARY INFECTION CHECK ==="
strings /bin/ls /usr/bin/ps /bin/netstat 2>/dev/null | grep -i "dolphin\|bolt\|cirrus\|flurry"
```

## Response Priorities

### 1. Immediate (Critical)
- **Dolphin malware** - Task manager replacement
- **Binary infections** - System binary modifications
- **GPO account creation** - Continuous account spawning

### 2. High Priority
- **Registry persistence** - Run keys, services
- **Scheduled tasks** - Automated execution
- **Service persistence** - Systemd services

### 3. Medium Priority
- **Cron jobs** - Scheduled execution
- **Startup scripts** - Init scripts, rc.local

## Advanced Cleanup Procedures

### Windows Cleanup
```cmd
# Remove dolphin malware
taskkill /F /IM dolphin.exe
del /F /Q "C:\Windows\System32\dolphin.exe"
copy C:\Windows\System32\taskmgr.exe.backup C:\Windows\System32\taskmgr.exe

# Remove suspicious accounts
net user suspicioususer /delete

# Remove scheduled tasks
schtasks /delete /tn "SuspiciousTask" /f

# Remove services
sc delete "SuspiciousService"

# Clean registry
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "dolphin" /f
```

### Linux Cleanup
```bash
# Remove dolphin processes
pkill -f dolphin

# Restore infected binaries
cp /bin/ls.backup /bin/ls
cp /usr/bin/ps.backup /usr/bin/ps

# Remove suspicious cron jobs
crontab -l | grep -v "dolphin\|bolt\|cirrus\|flurry" | crontab -

# Remove services
systemctl disable dolphin.service
systemctl stop dolphin.service
rm -f /etc/systemd/system/dolphin.service
```

## Key Insights

1. **Red Team has 2 weeks** to stage payloads - expect sophisticated persistence
2. **Binary replacement** is common (dolphin.exe, taskmgr.exe)
3. **GPO abuse** for account creation and persistence
4. **Multiple layers** of persistence (registry, services, tasks, cron)
5. **System binary infection** on both Windows and Linux

## Detection Strategy

1. **Baseline system** - know what should be there
2. **Check for anomalies** - unexpected processes, files, accounts
3. **Verify binary integrity** - file hashes, digital signatures
4. **Monitor for re-infection** - persistence often returns
5. **Document everything** - for post-game analysis

This intelligence gives you a **massive advantage** - you know exactly what to look for! 🛡️ 