# ThunderStorm C2 Intelligence Summary

## ⚡ Red Team C2 Analysis

Based on analysis of `offense/ThunderStorm-main/`, this is the C2 framework Red Team will likely use against your Blue Team machines.

---

## **🏗️ ThunderStorm Architecture**

### **Core Components:**

#### **1. Cirrus (C2 Server)**
- **Purpose:** Primary "teamserver" - REST API + WebSocket interface
- **Default Port:** 7777 (web interface)
- **Features:** 
  - Automatic job/session capture
  - Real-time WebSocket updates
  - REST API for control
- **Detection:** Look for port 7777, WebSocket connections

#### **2. Bolt (Implant)**
- **Purpose:** Main implant that runs on target machines
- **Modes:** Service/daemon, DLL, or standalone binary
- **Persistence:** Uses Guardian system for resurrection
- **Detection:** Process names: `bolt`, `cirrus`, `doppler`

#### **3. Flurry (Persistence)**
- **Purpose:** Automatically resurrects killed Bolts
- **Method:** Guardian function + encrypted file storage
- **Files:** Uses XOR-encrypted files (`.enc`, `.xor`)
- **Detection:** Look for encrypted files, Guardian pipes

#### **4. Guardian (Persistence)**
- **Purpose:** Prevents multiple instances, enables resurrection
- **Default:** Pipe-based linker
- **Detection:** Named pipes in `/tmp`, Guardian processes

#### **5. Doppler (CLI Client)**
- **Purpose:** Python CLI to control Cirrus
- **Config:** JSON configuration files
- **Features:** Multi-user support, real-time data
- **Detection:** `config.json` files, Doppler processes

#### **6. JetStream/CloudSeed (Build Tools)**
- **Purpose:** Build and obfuscate Bolts
- **Output:** Cross-platform binaries
- **Detection:** Go source files, build artifacts

---

## **🎯 Red Team Attack Vectors**

### **Initial Compromise:**
1. **Bolt Implant** - Main payload delivered
2. **Guardian Setup** - Establishes persistence
3. **C2 Communication** - Connects to Cirrus server

### **Persistence Mechanisms:**
1. **Guardian Pipes** - Named pipes for process coordination
2. **Service Installation** - Runs as Windows/Linux service
3. **Flurry Resurrection** - Automatically restarts killed Bolts
4. **Encrypted Storage** - XOR-encrypted files for persistence

### **C2 Communication:**
1. **REST API** - Cirrus server on port 7777
2. **WebSocket** - Real-time updates
3. **Encrypted Traffic** - All communication encrypted
4. **Work Hours** - Can be configured for specific time windows

---

## **🛡️ Blue Team Detection Points**

### **Process Monitoring:**
```bash
# Key process names to watch
bolt, cirrus, doppler, jetstream, cloudseed, flurry, guard
```

### **File System Monitoring:**
```bash
# File patterns to watch
*.enc, *.xor          # Flurry encrypted files
*.go                  # Go source files
config.json           # Doppler configuration
*cirrus*              # Cirrus configuration
*thunderstorm*        # General ThunderStorm files
```

### **Network Monitoring:**
```bash
# Network indicators
Port 7777             # Cirrus web interface
WebSocket connections  # Real-time updates
Outbound connections   # C2 communication
```

### **Registry/Config Monitoring:**
```bash
# Configuration indicators
Guardian pipe names    # Named pipes
Service installations  # System services
Cron job entries      # Scheduled tasks
Startup scripts       # Auto-start mechanisms
```

---

## **⚡ ThunderStorm-Specific Threats**

### **High Priority:**
1. **Bolt Implants** - Main payload, can execute commands
2. **Guardian Persistence** - Prevents removal, enables resurrection
3. **Cirrus C2 Server** - Command and control infrastructure
4. **Flurry Resurrection** - Automatically restarts killed implants

### **Medium Priority:**
1. **Doppler CLI** - Red Team operator interface
2. **Encrypted Files** - Flurry persistence mechanism
3. **Build Artifacts** - Evidence of implant creation
4. **Configuration Files** - C2 setup and configuration

### **Low Priority:**
1. **Source Code** - Go files from build process
2. **Log Files** - ThunderStorm operation logs
3. **Temporary Files** - Build artifacts and cache

---

## **🔍 Detection Strategies**

### **1. Process Monitoring:**
```bash
# Monitor for ThunderStorm processes
ps aux | grep -E "(bolt|cirrus|doppler|flurry|guard)"
```

### **2. File System Monitoring:**
```bash
# Monitor for ThunderStorm files
find /tmp /var/tmp /home -name "*thunderstorm*" -o -name "*bolt*" -o -name "*flurry*"
```

### **3. Network Monitoring:**
```bash
# Monitor for C2 communication
netstat -tuln | grep -E "(7777|8080|443|80)"
ss -tuln | grep "ws"
```

### **4. Service Monitoring:**
```bash
# Monitor for ThunderStorm services
systemctl list-units --type=service | grep -E "(thunderstorm|cirrus|bolt|flurry)"
```

---

## **🚨 Response Priorities**

### **Immediate (0-5 minutes):**
1. **Kill ThunderStorm processes** - Stop active implants
2. **Block C2 communication** - Prevent command reception
3. **Remove Guardian pipes** - Disable persistence mechanism

### **Short-term (5-30 minutes):**
1. **Remove Flurry persistence** - Delete encrypted files
2. **Stop ThunderStorm services** - Disable auto-start
3. **Clean build artifacts** - Remove evidence

### **Long-term (30+ minutes):**
1. **Monitor for re-infection** - Watch for resurrection
2. **Block ThunderStorm signatures** - Prevent future compromise
3. **Document incident** - Record findings and response

---

## **📊 Threat Assessment**

### **Sophistication Level:** HIGH
- Enterprise-grade C2 framework
- Multiple persistence mechanisms
- Encrypted communication
- Automatic resurrection capabilities

### **Detection Difficulty:** MEDIUM
- Clear process names and patterns
- Specific network indicators
- Distinctive file patterns
- Service-based persistence

### **Removal Difficulty:** HIGH
- Multiple persistence layers
- Automatic resurrection (Flurry)
- Guardian protection
- Encrypted file storage

### **Re-infection Risk:** HIGH
- Flurry can resurrect from encrypted files
- Guardian system prevents complete removal
- Multiple backup persistence mechanisms

---

## **🎯 Blue Team Recommendations**

### **1. Enhanced Monitoring:**
- Run ThunderStorm hunter every 2-5 minutes
- Monitor for Guardian pipes and processes
- Watch for encrypted file creation
- Track network connections to port 7777

### **2. Proactive Defense:**
- Block outbound connections to common C2 ports
- Monitor for Go binary creation
- Watch for service installations
- Track configuration file modifications

### **3. Incident Response:**
- Use specialized ThunderStorm response guide
- Focus on Guardian and Flurry removal
- Monitor for resurrection attempts
- Document all findings thoroughly

---

**Remember: ThunderStorm is sophisticated enterprise C2. Stay vigilant! ⚡🛡️** 