# Defensive Strategy Guide - Beacon Hunting and Backdoor Removal

## Overview

This guide provides a comprehensive approach to detecting and eliminating red team beacons, backdoors, and malicious sessions using regex patterns and layered defense strategies.

## Threat Landscape

### Common Red Team Techniques

1. **Binary Replacements**
   - Replacing legitimate binaries with malicious versions
   - Common targets: `taskmgr`, `cmd`, `powershell`, `bash`, `python`
   - Detection: File integrity checks, hash verification

2. **Persistence Mechanisms**
   - Registry modifications (Windows)
   - Cron jobs and systemd services (Linux)
   - Startup folder modifications
   - Profile file modifications (`.bashrc`, `.profile`)

3. **Network Beacons**
   - HTTP/HTTPS beacons to C2 servers
   - DNS beacons using suspicious domains
   - ICMP beacons for command and control
   - Custom protocols on non-standard ports

4. **Process Injection**
   - DLL injection into legitimate processes
   - Process hollowing techniques
   - Thread injection for stealth

## Detection Tools

### 1. Beacon Hunter (Linux)

**Location**: `defense/essential_toolkit/beacon_hunter.sh`

**Usage**:
```bash
# Continuous monitoring (30-second intervals)
./beacon_hunter.sh monitor 30

# Comprehensive threat hunt
./beacon_hunter.sh hunt

# Remove detected threats
./beacon_hunter.sh cleanup

# Quick kill processes and files
./beacon_hunter.sh kill
```

**Detection Capabilities**:
- ThunderStorm C2 components (bolt, cirrus, flurry, guardian)
- Generic C2 processes (beacon, implant, agent, payload)
- Binary replacements and backdoors
- Persistence mechanisms
- Suspicious network connections
- High resource usage processes

### 2. Beacon Hunter (Windows)

**Location**: `defense/essential_toolkit/beacon_hunter.bat`

**Usage**:
```cmd
# Continuous monitoring
beacon_hunter.bat monitor 30

# Comprehensive threat hunt
beacon_hunter.bat hunt

# Remove detected threats
beacon_hunter.bat cleanup

# Quick kill processes and files
beacon_hunter.bat kill
```

**Detection Capabilities**:
- ThunderStorm C2 components
- Registry persistence mechanisms
- Scheduled tasks and services
- Startup folder modifications
- Binary integrity checks
- Network connection analysis

### 3. pfSense Beacon Hunter

**Location**: `defense/essential_toolkit/pfsense_beacon_hunter.sh`

**Usage**:
```bash
# Network traffic monitoring
./pfsense_beacon_hunter.sh monitor 30

# Comprehensive network hunt
./pfsense_beacon_hunter.sh hunt

# Block suspicious IPs
./pfsense_beacon_hunter.sh block

# Setup network defense
./pfsense_beacon_hunter.sh setup

# Generate defense report
./pfsense_beacon_hunter.sh report
```

**Detection Capabilities**:
- C2 beacon connections
- Suspicious domain connections
- Malware port activity
- ICMP beacon traffic
- DNS beacon queries
- Firewall log analysis

## Regex Patterns for Detection

### Process Detection Patterns

```bash
# ThunderStorm C2
bolt|cirrus|flurry|guardian|doppler|jetstream|cloudseed|thunderstorm

# Generic C2
c2|beacon|implant|agent|payload|shell|reverse

# Suspicious command lines
curl.*http|wget.*http|nc.*-l|python.*-c.*http|perl.*-e.*http
```

### Network Detection Patterns

```bash
# C2 ports
:(4444|1337|8080|8443|9000|9001|4443|8443|6666|7777|8888|9999)

# Suspicious domains
\.(tk|ml|ga|cf|gq|xyz|top|club|site|online|tech|space|website|icu|cyou|cc|cn|ru|cn)

# Beacon patterns
GET.*/beacon|POST.*/checkin|GET.*/ping|POST.*/heartbeat
```

### File Detection Patterns

```bash
# Binary replacements
taskmgr|cmd|powershell|bash|sh|python|perl|ruby

# Persistence patterns
@(reboot|yearly|annually|monthly|weekly|daily|hourly|minutely).*http

# Suspicious locations
(/tmp|/var/tmp|/dev/shm)/.*(sh|bash|python|perl|ruby)
```

## Layered Defense Strategy

### Layer 1: Network Defense (pfSense)

1. **Firewall Rules**
   - Block outbound connections to C2 ports
   - Block connections to suspicious domains
   - Rate limit DNS queries
   - Monitor for beacon patterns

2. **Network Monitoring**
   - Real-time traffic analysis
   - Log analysis for suspicious patterns
   - Connection tracking
   - IP reputation checking

### Layer 2: Host-Based Defense

1. **Process Monitoring**
   - Continuous process analysis
   - Command line argument monitoring
   - Resource usage tracking
   - Parent-child process relationships

2. **File System Monitoring**
   - File integrity monitoring
   - Binary replacement detection
   - Hidden file detection
   - Permission change monitoring

3. **Persistence Detection**
   - Registry monitoring (Windows)
   - Cron job monitoring (Linux)
   - Service monitoring
   - Startup folder monitoring

### Layer 3: Application Defense

1. **Binary Integrity**
   - Hash verification of system binaries
   - Digital signature validation
   - File modification detection
   - Backup comparison

2. **Memory Analysis**
   - Process memory scanning
   - DLL injection detection
   - Code injection detection
   - Memory pattern analysis

## Response Procedures

### Immediate Response (0-5 minutes)

1. **Isolate the System**
   - Disconnect from network
   - Stop suspicious processes
   - Block suspicious IPs

2. **Document the Incident**
   - Capture process lists
   - Save network connections
   - Document file modifications
   - Preserve logs

### Short-term Response (5-30 minutes)

1. **Remove Threats**
   - Kill malicious processes
   - Remove suspicious files
   - Clean persistence mechanisms
   - Restore modified binaries

2. **Implement Monitoring**
   - Deploy continuous monitoring
   - Set up alerting
   - Configure logging
   - Establish baselines

### Long-term Response (30+ minutes)

1. **Forensic Analysis**
   - Memory dump analysis
   - Disk image creation
   - Log correlation
   - Timeline reconstruction

2. **System Hardening**
   - Update security policies
   - Implement additional controls
   - Review access controls
   - Enhance monitoring

## Best Practices

### 1. Regular Monitoring

- Run continuous monitoring tools
- Set up automated alerts
- Review logs regularly
- Maintain baseline comparisons

### 2. Defense in Depth

- Implement multiple detection layers
- Use different detection methods
- Cross-reference findings
- Validate detections

### 3. Incident Response

- Have response procedures ready
- Practice response scenarios
- Maintain incident documentation
- Learn from each incident

### 4. Threat Intelligence

- Stay updated on new threats
- Share information with teams
- Participate in threat sharing
- Adapt detection patterns

## Advanced Techniques

### 1. Behavioral Analysis

- Monitor process behavior patterns
- Track network communication patterns
- Analyze file access patterns
- Correlate multiple data sources

### 2. Machine Learning

- Train models on normal behavior
- Detect anomalies automatically
- Reduce false positives
- Improve detection accuracy

### 3. Threat Hunting

- Proactive threat searching
- Hypothesis-driven investigations
- Data-driven analysis
- Continuous improvement

## Tool Integration

### Automated Response

```bash
# Example: Automated threat response
if ./beacon_hunter.sh hunt | grep -q "WARNING"; then
    ./beacon_hunter.sh cleanup
    ./pfsense_beacon_hunter.sh block
    # Send alert to security team
fi
```

### Continuous Monitoring

```bash
# Example: Continuous monitoring script
while true; do
    ./beacon_hunter.sh hunt > /tmp/hunt_results.txt
    if grep -q "WARNING" /tmp/hunt_results.txt; then
        # Trigger response procedures
        ./beacon_hunter.sh cleanup
        # Send alert
    fi
    sleep 300  # Check every 5 minutes
done
```

## Conclusion

This defensive strategy provides a comprehensive approach to detecting and eliminating red team beacons and backdoors. The key is to implement multiple layers of defense, use regex patterns for detection, and have clear response procedures in place.

Remember: The goal is not just to detect threats, but to respond quickly and effectively to minimize the impact of red team activities. 