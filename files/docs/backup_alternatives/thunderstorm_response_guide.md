# ThunderStorm C2 Response Guide

## ⚡ When You Find ThunderStorm C2 Persistence

### **Immediate Actions (Do These First)**

#### **1. Kill ThunderStorm Processes**
```bash
# Kill all ThunderStorm components
pkill -f "bolt"
pkill -f "cirrus"
pkill -f "doppler"
pkill -f "jetstream"
pkill -f "cloudseed"
pkill -f "flurry"
pkill -f "guard"

# Force kill if needed
killall -9 bolt cirrus doppler jetstream cloudseed flurry
```

#### **2. Remove Guardian Persistence (from bolt.go, flurry.go)**
```bash
# Remove Guardian pipes (default linker type)
find /tmp -name "*guard*" -type p -delete 2>/dev/null

# Remove Guardian processes
pkill -f "guard"

# Check for Guardian services
systemctl stop thunderstorm-guardian 2>/dev/null
systemctl disable thunderstorm-guardian 2>/dev/null
```

#### **3. Remove Flurry Persistence (from flurry.go)**
```bash
# Kill Flurry processes
pkill -f "flurry"

# Remove encrypted files that Flurry uses
find /tmp /var/tmp /home -name "*.enc" -o -name "*.xor" -delete 2>/dev/null

# Check for Flurry services
systemctl stop flurry 2>/dev/null
systemctl disable flurry 2>/dev/null
```

#### **4. Stop Cirrus C2 Server (from cirrus/)**
```bash
# Kill Cirrus server
pkill -f "cirrus"

# Stop Cirrus web interface (port 7777)
fuser -k 7777/tcp 2>/dev/null

# Remove Cirrus configuration
rm -rf /etc/cirrus* /home/*/cirrus* /root/cirrus* 2>/dev/null

# Stop Cirrus services
systemctl stop cirrus 2>/dev/null
systemctl disable cirrus 2>/dev/null
```

#### **5. Remove Doppler CLI Client (from doppler/)**
```bash
# Kill Doppler processes
pkill -f "doppler"

# Remove Doppler configuration files
find /home /root -name "*doppler*" -o -name "config.json" -delete 2>/dev/null

# Stop Doppler services
systemctl stop doppler 2>/dev/null
systemctl disable doppler 2>/dev/null
```

#### **6. Remove Build Artifacts (from jetstream/, cloudseed/)**
```bash
# Remove ThunderStorm binaries
find /tmp /var/tmp /home -name "*.exe" -o -name "*bolt*" -o -name "*flurry*" -delete 2>/dev/null

# Remove Go source files
find /tmp /var/tmp /home -name "*.go" -delete 2>/dev/null

# Remove build directories
rm -rf /tmp/thunderstorm* /var/tmp/thunderstorm* 2>/dev/null
```

#### **7. Monitor C2 Communication**
```bash
# Monitor ThunderStorm C2 ports for detection
netstat -tuln | grep -E "(7777|8080|443|80)" || echo "No suspicious connections found"

# Log suspicious connections for analysis
tcpdump -i any -w /tmp/suspicious_traffic.pcap port 7777 or port 8080 or port 443 or port 80
```

#### **8. Remove Service Persistence**
```bash
# Stop all ThunderStorm services
for service in thunderstorm cirrus bolt flurry doppler; do
    systemctl stop $service 2>/dev/null
    systemctl disable $service 2>/dev/null
    systemctl mask $service 2>/dev/null
done

# Remove cron jobs
crontab -l 2>/dev/null | grep -v -E "(bolt|flurry|cirrus|thunderstorm)" | crontab -
```

### **Verification Steps**

#### **1. Verify ThunderStorm Removal**
```bash
# Run ThunderStorm hunter again
./defense/thunderstorm_hunter.sh

# Check for any remaining threats
cat /tmp/thunderstorm_hunt.log
```

#### **2. Verify Services Still Running**
```bash
# Check critical services
systemctl status apache2 nginx ssh bind9 vsftpd

# Check for any new suspicious processes
ps aux | grep -E "(bolt|cirrus|doppler|flurry|guard)"
```

#### **3. Test Network Connectivity**
```bash
# Test basic connectivity
ping -c 3 8.8.8.8
nslookup google.com
curl -I http://localhost

# Check for suspicious C2 connections
netstat -tuln | grep -E "(7777|8080|443|80)" || echo "No suspicious connections found"
```

### **Prevention Measures**

#### **1. Block ThunderStorm Signatures**
```bash
# Add to /etc/hosts to block C2 domains
echo "127.0.0.1 cirrus.local" >> /etc/hosts
echo "127.0.0.1 thunderstorm.local" >> /etc/hosts
echo "127.0.0.1 bolt.local" >> /etc/hosts
echo "127.0.0.1 flurry.local" >> /etc/hosts
```

#### **2. Set Up ThunderStorm Monitoring**
```bash
# Create monitoring cron job
echo "*/2 * * * * /path/to/defense/thunderstorm_hunter.sh >> /var/log/thunderstorm_monitor.log" | crontab -
```

#### **3. File Integrity Monitoring**
```bash
# Monitor for ThunderStorm files
echo "*/5 * * * * find /tmp /var/tmp -name '*thunderstorm*' -o -name '*bolt*' -o -name '*flurry*' > /tmp/thunderstorm_check.txt" | crontab -
```

### **ThunderStorm-Specific Indicators**

#### **Process Names to Watch:**
- `bolt` - Main implant
- `cirrus` - C2 server
- `doppler` - CLI client
- `flurry` - Persistence mechanism
- `guard` - Guardian process
- `jetstream` - Build tool
- `cloudseed` - Batch builder

#### **File Patterns to Watch:**
- `*.enc`, `*.xor` - Flurry encrypted files
- `*.go` - Go source files
- `config.json` - Doppler configuration
- `*cirrus*` - Cirrus configuration
- `*thunderstorm*` - General ThunderStorm files

#### **Network Indicators:**
- Port 7777 - Cirrus web interface
- WebSocket connections
- Outbound connections to unknown IPs
- Encrypted traffic patterns

#### **Registry/Config Indicators:**
- Guardian pipe names
- Service installations
- Cron job entries
- Startup script modifications

### **Emergency Contacts**

- **Team Lead:** [Your team lead contact]
- **Game Admin:** [Admin contact from rules]
- **Backup Systems:** [List your backup systems]

### **Documentation**

**ALWAYS document ThunderStorm findings:**
```bash
# Create incident report
echo "$(date): Found ThunderStorm [COMPONENT_TYPE]" >> /var/log/thunderstorm_incidents.log
echo "Component: [BOLT/CIRRUS/FLURRY/etc]" >> /var/log/thunderstorm_incidents.log
echo "Location: [PROCESS/FILE/SERVICE]" >> /var/log/thunderstorm_incidents.log
echo "Action taken: [REMOVAL_METHOD]" >> /var/log/thunderstorm_incidents.log
echo "Verification: [HOW YOU VERIFIED]" >> /var/log/thunderstorm_incidents.log
```

### **Remember:**
- ✅ **ThunderStorm is sophisticated** - Multiple components work together
- ✅ **Guardian persistence is tricky** - Check pipes and services
- ✅ **Flurry can resurrect** - Monitor for re-infection
- ✅ **Cirrus has web interface** - Check port 7777
- ✅ **Doppler is CLI client** - Look for config files
- ❌ **Don't underestimate** - This is enterprise-grade C2

---

**Good luck against ThunderStorm! ⚡🛡️** 