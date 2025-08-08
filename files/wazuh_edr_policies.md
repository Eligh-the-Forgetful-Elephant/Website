# Wazuh EDR Policies - Comprehensive Implementation Guide

**Document Version:** 1.0  
**Date:** $(date +%Y-%m-%d)  
**Department:** Cybersecurity Operations  
**Purpose:** Endpoint Detection and Response (EDR) Implementation

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Linux EDR Policy](#linux-edr-policy)
3. [Windows EDR Policy](#windows-edr-policy)
4. [Deployment Instructions](#deployment-instructions)
5. [Monitoring and Maintenance](#monitoring-and-maintenance)
6. [Compliance Framework](#compliance-framework)    

---

## Executive Summary

This document provides comprehensive Wazuh EDR policies for both Linux and Windows environments. The policies implement multiple layers of security including:

- **Custom Detection Rules**: Real-time threat detection
- **Active Response Scripts**: Automated threat containment
- **Security Configuration Assessment**: Compliance monitoring
- **File Integrity Monitoring**: Critical file protection
- **Process Monitoring**: Malicious activity detection

### Key Benefits

✅ **Real-time Threat Detection**  
✅ **Automated Response Capabilities**  
✅ **Compliance Monitoring**  
✅ **Comprehensive Logging**  
✅ **Centralized Management**  
✅ **Scalable Architecture**

---

## Linux EDR Policy

### 1. Custom Detection Rules

**File:** `local_rules.xml`  
**Location:** `/var/ossec/etc/rules/`

```xml
<!-- Linux EDR Custom Rules -->
<group name="linux,edr,">
  <!-- Process Injection Detection -->
  <rule id="100001" level="12">
    <if_sid>0</if_sid>
    <match>ptrace</match>
    <description>Linux EDR: Process injection attempt detected</description>
  </rule>

  <!-- Privilege Escalation -->
  <rule id="100002" level="12">
    <if_sid>0</if_sid>
    <match>sudo.*su -</match>
    <description>Linux EDR: Privilege escalation attempt</description>
  </rule>

  <!-- Suspicious Network Connections -->
  <rule id="100003" level="10">
    <if_sid>0</if_sid>
    <match>nc -l|netcat.*listen</match>
    <description>Linux EDR: Suspicious network listener</description>
  </rule>

  <!-- File System Tampering -->
  <rule id="100004" level="11">
    <if_sid>0</if_sid>
    <match>chmod.*777|chmod.*666</match>
    <description>Linux EDR: Suspicious file permission changes</description>
  </rule>

  <!-- Kernel Module Loading -->
  <rule id="100005" level="12">
    <if_sid>0</if_sid>
    <match>insmod|modprobe</match>
    <description>Linux EDR: Kernel module loading attempt</description>
  </rule>

  <!-- Cron Job Manipulation -->
  <rule id="100006" level="10">
    <if_sid>0</if_sid>
    <match>crontab.*-e|crontab.*-r</match>
    <description>Linux EDR: Cron job manipulation</description>
  </rule>

  <!-- SSH Key Tampering -->
  <rule id="100007" level="11">
    <if_sid>0</if_sid>
    <match>authorized_keys|id_rsa</match>
    <description>Linux EDR: SSH key manipulation</description>
  </rule>

  <!-- System Service Manipulation -->
  <rule id="100008" level="11">
    <if_sid>0</if_sid>
    <match>systemctl.*enable|systemctl.*disable</match>
    <description>Linux EDR: System service manipulation</description>
  </rule>

  <!-- Root Access Attempts -->
  <rule id="100009" level="12">
    <if_sid>0</if_sid>
    <match>su -|sudo su</match>
    <description>Linux EDR: Root access attempt</description>
  </rule>

  <!-- Network Scanning -->
  <rule id="100010" level="10">
    <if_sid>0</if_sid>
    <match>nmap|masscan|netcat.*scan</match>
    <description>Linux EDR: Network scanning activity</description>
  </rule>
</group>
```

### 2. Active Response Scripts

#### Process Killer Script
**File:** `kill_malicious.sh`  
**Location:** `/var/ossec/active-response/bin/`

```bash
#!/bin/bash
# Linux EDR Active Response - Kill Malicious Process

LOG_FILE="/var/ossec/logs/active-responses.log"
PID=$1
RULE_ID=$2
AGENT_ID=$3

echo "$(date) - Linux EDR: Killing malicious process PID=$PID (Rule=$RULE_ID, Agent=$AGENT_ID)" >> $LOG_FILE

# Kill the malicious process
if kill -9 $PID 2>/dev/null; then
    echo "$(date) - Linux EDR: Successfully killed process $PID" >> $LOG_FILE
    
    # Get process details for logging
    PROCESS_INFO=$(ps -p $PID -o pid,ppid,cmd --no-headers 2>/dev/null)
    echo "$(date) - Linux EDR: Process details - $PROCESS_INFO" >> $LOG_FILE
    
    # Block the process from running again
    echo "kill -9 $PID" >> /etc/rc.local
else
    echo "$(date) - Linux EDR: Failed to kill process $PID" >> $LOG_FILE
fi

# Send alert to security team
echo "ALERT: Malicious process $PID killed on agent $AGENT_ID" | mail -s "Linux EDR Alert" security@company.com
```

#### Network Blocker Script
**File:** `block_ip.sh`  
**Location:** `/var/ossec/active-response/bin/`

```bash
#!/bin/bash
# Linux EDR Active Response - Block Suspicious IP

LOG_FILE="/var/ossec/logs/active-responses.log"
IP=$1
RULE_ID=$2
AGENT_ID=$3

echo "$(date) - Linux EDR: Blocking IP $IP (Rule=$RULE_ID, Agent=$AGENT_ID)" >> $LOG_FILE

# Block IP using iptables
iptables -A INPUT -s $IP -j DROP
iptables -A OUTPUT -d $IP -j DROP

# Save iptables rules
iptables-save > /etc/iptables/rules.v4

echo "$(date) - Linux EDR: Blocked IP $IP" >> $LOG_FILE

# Send alert to security team
echo "ALERT: IP $IP blocked on agent $AGENT_ID" | mail -s "Linux EDR Alert" security@company.com
```

### 3. Security Configuration Assessment

**File:** `linux_edr_policy.yml`  
**Location:** `/var/ossec/etc/sca/`

```yaml
# Linux EDR Security Configuration Assessment
policy:
  id: "linux_edr_policy"
  name: "Linux EDR Security Policy"
  description: "Comprehensive EDR policy for Linux systems"
  references:
    - "NIST Cybersecurity Framework"
    - "CIS Linux Benchmarks"
    - "ISO 27001"

checks:
  # File Integrity Monitoring
  - id: "1001"
    title: "Critical system files monitored"
    description: "Ensure critical system files are monitored for changes"
    rationale: "Critical files must be monitored for unauthorized changes"
    remediation: "Enable FIM monitoring for critical system files"
    compliance:
      - "NIST CSF: PR.DS-6"
      - "ISO 27001: A.12.2.1"
    rules:
      - "fim_file: /etc/passwd"
      - "fim_file: /etc/shadow"
      - "fim_file: /etc/sudoers"
      - "fim_file: /etc/ssh/sshd_config"
      - "fim_file: /etc/hosts"
      - "fim_file: /etc/crontab"

  # Process Monitoring
  - id: "1002"
    title: "Process monitoring enabled"
    description: "Ensure process monitoring is active"
    rationale: "Process monitoring helps detect malicious activity"
    remediation: "Enable process monitoring in Wazuh agent"
    compliance:
      - "NIST CSF: DE.CM-1"
    rules:
      - "process_monitoring: enabled"

  # Network Security
  - id: "1003"
    title: "Network security controls"
    description: "Verify network security controls are in place"
    rationale: "Network controls prevent unauthorized access"
    remediation: "Implement network security controls"
    compliance:
      - "NIST CSF: PR.AC-3"
    rules:
      - "firewall: enabled"
      - "iptables: active"
      - "ufw: enabled"

  # User Access Control
  - id: "1004"
    title: "User access controls"
    description: "Verify user access controls are properly configured"
    rationale: "Proper access controls prevent unauthorized access"
    remediation: "Configure proper user access controls"
    compliance:
      - "NIST CSF: PR.AC-1"
    rules:
      - "sudo: configured"
      - "password_policy: enforced"
      - "root_login: disabled"

  # Logging and Monitoring
  - id: "1005"
    title: "Logging and monitoring"
    description: "Ensure comprehensive logging and monitoring"
    rationale: "Logging and monitoring enable threat detection"
    remediation: "Enable comprehensive logging and monitoring"
    compliance:
      - "NIST CSF: DE.CM-1"
    rules:
      - "syslog: enabled"
      - "auditd: active"
      - "rsyslog: configured"

  # System Hardening
  - id: "1006"
    title: "System hardening"
    description: "Verify system hardening measures are in place"
    rationale: "System hardening reduces attack surface"
    remediation: "Implement system hardening measures"
    compliance:
      - "NIST CSF: PR.AC-3"
    rules:
      - "unnecessary_services: disabled"
      - "default_passwords: changed"
      - "unused_accounts: removed"
```

---

## Windows EDR Policy

### 1. Custom Detection Rules

**File:** `local_rules.xml`  
**Location:** `/var/ossec/etc/rules/`

```xml
<!-- Windows EDR Custom Rules -->
<group name="windows,edr,">
  <!-- Process Injection Detection -->
  <rule id="200001" level="12">
    <if_sid>0</if_sid>
    <match>CreateRemoteThread|VirtualAllocEx|WriteProcessMemory</match>
    <description>Windows EDR: Process injection attempt detected</description>
  </rule>

  <!-- Registry Tampering -->
  <rule id="200002" level="11">
    <if_sid>0</if_sid>
    <match>HKLM.*Run|HKCU.*Run|HKLM.*RunOnce</match>
    <description>Windows EDR: Registry persistence attempt</description>
  </rule>

  <!-- PowerShell Execution -->
  <rule id="200003" level="10">
    <if_sid>0</if_sid>
    <match>powershell.*-enc|powershell.*-e</match>
    <description>Windows EDR: Encoded PowerShell execution</description>
  </rule>

  <!-- Scheduled Task Manipulation -->
  <rule id="200004" level="11">
    <if_sid>0</if_sid>
    <match>schtasks.*/create|at.*</match>
    <description>Windows EDR: Scheduled task manipulation</description>
  </rule>

  <!-- Service Manipulation -->
  <rule id="200005" level="11">
    <if_sid>0</if_sid>
    <match>sc.*create|sc.*start|sc.*stop</match>
    <description>Windows EDR: Service manipulation</description>
  </rule>

  <!-- WMI Abuse -->
  <rule id="200006" level="12">
    <if_sid>0</if_sid>
    <match>wmic.*process.*call|wmic.*process.*create</match>
    <description>Windows EDR: WMI process manipulation</description>
  </rule>

  <!-- DLL Injection -->
  <rule id="200007" level="12">
    <if_sid>0</if_sid>
    <match>LoadLibrary|GetProcAddress|CreateProcess</match>
    <description>Windows EDR: DLL injection attempt</description>
  </rule>

  <!-- Credential Access -->
  <rule id="200008" level="12">
    <if_sid>0</if_sid>
    <match>mimikatz|procdump|wdigest</match>
    <description>Windows EDR: Credential access attempt</description>
  </rule>

  <!-- Lateral Movement -->
  <rule id="200009" level="11">
    <if_sid>0</if_sid>
    <match>psexec|wmic.*/node|net.*use</match>
    <description>Windows EDR: Lateral movement attempt</description>
  </rule>

  <!-- Data Exfiltration -->
  <rule id="200010" level="10">
    <if_sid>0</if_sid>
    <match>robocopy.*/mir|xcopy.*/s|copy.*large</match>
    <description>Windows EDR: Potential data exfiltration</description>
  </rule>
</group>
```

### 2. Active Response Scripts

#### Process Killer Script
**File:** `kill_malicious.ps1`  
**Location:** `/var/ossec/active-response/bin/`

```powershell
# Windows EDR Active Response - Kill Malicious Process
param(
    [string]$ProcessName,
    [string]$RuleID,
    [string]$AgentID
)

$LogFile = "C:\Program Files (x86)\ossec-agent\active-response.log"
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Add-Content -Path $LogFile -Value "$Timestamp - Windows EDR: Killing malicious process $ProcessName (Rule=$RuleID, Agent=$AgentID)"

try {
    # Get process details before killing
    $Process = Get-Process -Name $ProcessName -ErrorAction Stop
    $ProcessInfo = "PID: $($Process.Id), Path: $($Process.Path), StartTime: $($Process.StartTime)"
    
    # Kill the process
    Stop-Process -Name $ProcessName -Force -ErrorAction Stop
    Add-Content -Path $LogFile -Value "$Timestamp - Windows EDR: Successfully killed process $ProcessName - $ProcessInfo"
    
    # Block the process from running again
    $BlockPath = "C:\Windows\System32\drivers\etc\hosts"
    Add-Content -Path $BlockPath -Value "127.0.0.1 $ProcessName"
    
    # Create registry block
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$ProcessName"
    New-ItemProperty -Path $RegPath -Name "Debugger" -Value "ntsd.exe" -PropertyType String -Force
    
} catch {
    Add-Content -Path $LogFile -Value "$Timestamp - Windows EDR: Failed to kill process $ProcessName - $($_.Exception.Message)"
}

# Send alert to security team
$AlertBody = "ALERT: Malicious process $ProcessName killed on agent $AgentID"
Send-MailMessage -From "edr@company.com" -To "security@company.com" -Subject "Windows EDR Alert" -Body $AlertBody -SmtpServer "smtp.company.com"
```

#### Network Blocker Script
**File:** `block_ip.ps1`  
**Location:** `/var/ossec/active-response/bin/`

```powershell
# Windows EDR Active Response - Block Suspicious IP
param(
    [string]$IP,
    [string]$RuleID,
    [string]$AgentID
)

$LogFile = "C:\Program Files (x86)\ossec-agent\active-response.log"
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Add-Content -Path $LogFile -Value "$Timestamp - Windows EDR: Blocking IP $IP (Rule=$RuleID, Agent=$AgentID)"

try {
    # Block IP using Windows Firewall
    New-NetFirewallRule -DisplayName "Wazuh Blocked IP $IP" -Direction Inbound -RemoteAddress $IP -Action Block -Profile Any
    New-NetFirewallRule -DisplayName "Wazuh Blocked IP $IP Outbound" -Direction Outbound -RemoteAddress $IP -Action Block -Profile Any
    
    # Add to hosts file
    $HostsFile = "C:\Windows\System32\drivers\etc\hosts"
    Add-Content -Path $HostsFile -Value "127.0.0.1 $IP"
    
    Add-Content -Path $LogFile -Value "$Timestamp - Windows EDR: Blocked IP $IP"
} catch {
    Add-Content -Path $LogFile -Value "$Timestamp - Windows EDR: Failed to block IP $IP - $($_.Exception.Message)"
}

# Send alert to security team
$AlertBody = "ALERT: IP $IP blocked on agent $AgentID"
Send-MailMessage -From "edr@company.com" -To "security@company.com" -Subject "Windows EDR Alert" -Body $AlertBody -SmtpServer "smtp.company.com"
```

### 3. Security Configuration Assessment

**File:** `windows_edr_policy.yml`  
**Location:** `/var/ossec/etc/sca/`

```yaml
# Windows EDR Security Configuration Assessment
policy:
  id: "windows_edr_policy"
  name: "Windows EDR Security Policy"
  description: "Comprehensive EDR policy for Windows systems"
  references:
    - "NIST Cybersecurity Framework"
    - "CIS Windows Benchmarks"
    - "ISO 27001"

checks:
  # Windows Defender
  - id: "2001"
    title: "Windows Defender enabled"
    description: "Ensure Windows Defender is enabled and updated"
    rationale: "Windows Defender provides real-time protection"
    remediation: "Enable and update Windows Defender"
    compliance:
      - "NIST CSF: PR.DS-5"
      - "ISO 27001: A.12.2.1"
    rules:
      - "defender: enabled"
      - "defender_signatures: updated"
      - "defender_realtime: enabled"

  # User Account Control
  - id: "2002"
    title: "UAC enabled"
    description: "Ensure User Account Control is enabled"
    rationale: "UAC prevents unauthorized privilege escalation"
    remediation: "Enable UAC in Windows settings"
    compliance:
      - "NIST CSF: PR.AC-3"
    rules:
      - "uac: enabled"
      - "uac_level: high"

  # Windows Firewall
  - id: "2003"
    title: "Windows Firewall enabled"
    description: "Ensure Windows Firewall is enabled"
    rationale: "Firewall controls network access"
    remediation: "Enable Windows Firewall"
    compliance:
      - "NIST CSF: PR.AC-3"
    rules:
      - "firewall: enabled"
      - "firewall_profiles: configured"

  # BitLocker
  - id: "2004"
    title: "BitLocker enabled"
    description: "Ensure BitLocker encryption is enabled"
    rationale: "Encryption protects data at rest"
    remediation: "Enable BitLocker encryption"
    compliance:
      - "NIST CSF: PR.DS-1"
    rules:
      - "bitlocker: enabled"
      - "tpm: enabled"

  # Windows Updates
  - id: "2005"
    title: "Windows Updates enabled"
    description: "Ensure Windows Updates are enabled and current"
    rationale: "Updates patch security vulnerabilities"
    remediation: "Enable and configure Windows Updates"
    compliance:
      - "NIST CSF: PR.IP-12"
    rules:
      - "windows_update: enabled"
      - "windows_update: current"
      - "automatic_updates: enabled"

  # Audit Logging
  - id: "2006"
    title: "Audit logging enabled"
    description: "Ensure comprehensive audit logging is enabled"
    rationale: "Audit logs enable threat detection"
    remediation: "Enable comprehensive audit logging"
    compliance:
      - "NIST CSF: DE.CM-1"
    rules:
      - "audit_policy: enabled"
      - "event_logs: enabled"
      - "security_log: enabled"

  # Account Security
  - id: "2007"
    title: "Account security"
    description: "Verify account security settings"
    rationale: "Proper account security prevents unauthorized access"
    remediation: "Configure account security settings"
    compliance:
      - "NIST CSF: PR.AC-1"
    rules:
      - "password_policy: enforced"
      - "account_lockout: enabled"
      - "guest_account: disabled"
```

---

## Deployment Instructions

### 1. Prerequisites

- Wazuh Manager 4.x or higher
- Wazuh Agents installed on target systems
- Root/Administrator access to all systems
- Network connectivity between manager and agents

### 2. Installation Steps

#### Step 1: Install Custom Rules
```bash
# Copy custom rules to Wazuh manager
cp local_rules.xml /var/ossec/etc/rules/

# Set proper permissions
chown root:ossec /var/ossec/etc/rules/local_rules.xml
chmod 640 /var/ossec/etc/rules/local_rules.xml
```

#### Step 2: Install Active Response Scripts
```bash
# Copy Linux scripts
cp kill_malicious.sh /var/ossec/active-response/bin/
cp block_ip.sh /var/ossec/active-response/bin/

# Copy Windows scripts
cp kill_malicious.ps1 /var/ossec/active-response/bin/
cp block_ip.ps1 /var/ossec/active-response/bin/

# Set permissions
chmod +x /var/ossec/active-response/bin/*.sh
chmod +x /var/ossec/active-response/bin/*.ps1
chown root:ossec /var/ossec/active-response/bin/*
```

#### Step 3: Install SCA Policies
```bash
# Copy SCA policies
cp linux_edr_policy.yml /var/ossec/etc/sca/
cp windows_edr_policy.yml /var/ossec/etc/sca/

# Set permissions
chown root:ossec /var/ossec/etc/sca/*.yml
chmod 640 /var/ossec/etc/sca/*.yml
```

#### Step 4: Configure Active Response
Add to `/var/ossec/etc/ossec.conf`:

```xml
<ossec_config>
  <!-- Linux Active Response -->
  <active-response>
    <command>kill_malicious</command>
    <location>local</location>
    <level>10</level>
    <timeout>600</timeout>
  </active-response>

  <active-response>
    <command>block_ip</command>
    <location>local</location>
    <level>10</level>
    <timeout>600</timeout>
  </active-response>

  <!-- Windows Active Response -->
  <active-response>
    <command>kill_malicious.ps1</command>
    <location>local</location>
    <level>10</level>
    <timeout>600</timeout>
  </active-response>

  <active-response>
    <command>block_ip.ps1</command>
    <location>local</location>
    <level>10</level>
    <timeout>600</timeout>
  </active-response>
</ossec_config>
```

#### Step 5: Deploy to Agents
```bash
# Restart Wazuh manager
systemctl restart wazuh-manager

# Deploy SCA policies
wazuh-cli -d -g linux_edr_policy
wazuh-cli -d -g windows_edr_policy

# Verify deployment
wazuh-cli -d -l
```

### 3. Verification Steps

#### Check Rules Installation
```bash
# Verify rules are loaded
grep "EDR" /var/ossec/logs/ossec.log | tail -10
```

#### Test Active Response
```bash
# Test Linux active response
/var/ossec/active-response/bin/kill_malicious.sh 12345 100001 AGENT001

# Test Windows active response
powershell -ExecutionPolicy Bypass -File "C:\Program Files (x86)\ossec-agent\active-response\bin\kill_malicious.ps1" -ProcessName "test.exe" -RuleID "200001" -AgentID "AGENT002"
```

#### Verify SCA Policies
```bash
# Check SCA policy status
wazuh-cli -d -g linux_edr_policy --status
wazuh-cli -d -g windows_edr_policy --status
```

---

## Monitoring and Maintenance

### 1. Daily Monitoring Tasks

- Review active response logs
- Check for false positives
- Monitor system performance impact
- Verify agent connectivity

### 2. Weekly Maintenance Tasks

- Update custom rules based on new threats
- Review and tune detection thresholds
- Update SCA policies for compliance changes
- Backup configuration files

### 3. Monthly Review Tasks

- Analyze detection effectiveness
- Update threat intelligence feeds
- Review compliance status
- Performance optimization

### 4. Log Locations

**Linux Systems:**
- Active Response Logs: `/var/ossec/logs/active-responses.log`
- Agent Logs: `/var/ossec/logs/ossec.log`
- SCA Results: `/var/ossec/logs/sca.log`

**Windows Systems:**
- Active Response Logs: `C:\Program Files (x86)\ossec-agent\active-response.log`
- Agent Logs: `C:\Program Files (x86)\ossec-agent\ossec.log`
- SCA Results: `C:\Program Files (x86)\ossec-agent\sca.log`

---

## Compliance Framework

### NIST Cybersecurity Framework Alignment

| Function | Category | Implementation |
|----------|----------|----------------|
| **IDENTIFY** | ID.AM-1 | Asset inventory through agent deployment |
| **PROTECT** | PR.AC-1 | Access control through UAC and sudo monitoring |
| **PROTECT** | PR.DS-1 | Data protection through BitLocker monitoring |
| **DETECT** | DE.CM-1 | Continuous monitoring through custom rules |
| **DETECT** | DE.CM-3 | Process monitoring and detection |
| **RESPOND** | RS.MI-1 | Active response scripts for containment |
| **RECOVER** | RC.RP-1 | Automated recovery through active response |

### ISO 27001 Compliance

- **A.12.2.1**: File integrity monitoring
- **A.12.4.1**: Event logging and monitoring
- **A.9.2.1**: User access management
- **A.13.1.1**: Network security controls

### CIS Benchmarks

- **Linux**: CIS Linux Benchmark v2.0
- **Windows**: CIS Windows 10/11 Benchmark v1.0

---

## Contact Information

**Security Operations Center**  
Email: soc@company.com  
Phone: +1-XXX-XXX-XXXX  
Escalation: security@company.com

**Document Owner**  
Name: [Your Name]  
Email: [your.email@company.com]  
Phone: [Your Phone]

---

**Document Control**  
Version: 1.0  
Last Updated: $(date +%Y-%m-%d)  
Next Review: $(date -d "+6 months" +%Y-%m-%d)  
Approved By: [Approver Name] 