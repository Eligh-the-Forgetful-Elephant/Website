# Day 1 Quick Response Guide

## 🚨 When You Find Red Team Persistence

### **Immediate Actions (Do These First)**

#### **1. Remove SSH Key Persistence**
```bash
# Remove malicious SSH key
sed -i '/ssh-rsa AAAAB4NzaC1yc2EAAAADAQABAAABAQCl0kIN33IJISIufmqpqg54D7s4J0L7XV2kep0rNzgY1S1IdE8HDAf7z1ipBVuGTygGsq+x4yVnxveGshVP48YmicQHJMCIljmn6Po0RMC48qihm\/9ytoEYtkKkeiTR02c6DyIcDnX3QdlSmEqPqSNRQ\/XDgM7qIB\/VpYtAhK\/7DoE8pqdoFNBU5+JlqeWYpsMO+qkHugKA5U22wEGs8xG2XyyDtrBcw10xz+M7U8Vpt0tEadeV973tXNNNpUgYGIFEsrDEAjbMkEsUw+iQmXg37EusEFjCVjBySGH3F+EQtwin3YmxbB9HRMzOIzNnXwCFaYU5JjTNnzylUBp\/XB6B user@placeholder_host/d' /root/.ssh/authorized_keys
```

#### **2. Remove Cron Job Persistence**
```bash
# Remove malicious cron jobs
sed -i '/curl -s http:\/\/placeholder-domain/d' /etc/crontab
sed -i '/curl -s http:\/\/placeholder-domain/d' /var/spool/cron/crontabs/root
```

#### **3. Kill Malicious Processes**
```bash
# Kill specific malicious processes
pkill -f "atlas.x86"
pkill -f "dotsh"
pkill -f "nine.x86"
pkill -f "balder"
pkill -f "rtw88_pcied"
pkill -f "cpu_hu"
pkill -f "agettyd"
```

#### **4. Fix Modified Configs**
```bash
# Remove malicious DNS entry
sed -i '/8.8.8.8/d' /etc/resolv.conf

# Fix SSH config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart ssh

# Remove malicious hosts entry
sed -i '/128.90.59.19/d' /etc/hosts
```

#### **5. Remove Fake Users**
```bash
# Remove fake users (be careful!)
for user in mattdamon peter parker yourmom gandalf tonystark batman spiderman joker loki frodo sauron thanos deadpool drstrange neo trinity morpheus johnwick yoda vader obiwan skywalker terminator ragnar ezio altair kratos agent47 geralt; do
    userdel -r "$user" 2>/dev/null
done
```

#### **6. Clean Log Wiping Evidence**
```bash
# Remove log wiping messages
sed -i '/hi there buddy!/d' /var/log/*
```

#### **7. Monitor C2 Communication**
```bash
# Monitor YouTube-based C2 for detection
netstat -tuln | grep -E "(youtube|80|443|53)" || echo "No suspicious connections found"

# Log suspicious connections for analysis
tcpdump -i any -w /tmp/suspicious_traffic.pcap host youtube.com or host www.youtube.com or port 80 or port 443 or port 53
```

### **Verification Steps**

#### **1. Verify Persistence Removal**
```bash
# Run threat hunter again
./defense/threat_hunter.sh

# Check for any remaining threats
cat /tmp/threat_hunt.log
```

#### **2. Verify Services Still Running**
```bash
# Check critical services
systemctl status apache2
systemctl status ssh
systemctl status bind9
systemctl status vsftpd
```

#### **3. Test Network Connectivity**
```bash
# Test basic connectivity
ping -c 3 8.8.8.8
nslookup google.com
curl -I http://localhost
```

### **Prevention Measures**

#### **1. Harden SSH**
```bash
# Edit SSH config for security
cat >> /etc/ssh/sshd_config << EOF
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
AllowUsers your_username
EOF

systemctl restart ssh
```

#### **2. Set Up Monitoring**
```bash
# Create monitoring cron job
echo "*/5 * * * * /path/to/defense/threat_hunter.sh >> /var/log/threat_hunt.log" | crontab -
```

#### **3. File Integrity Monitoring**
```bash
# Monitor critical files
echo "*/10 * * * * md5sum /etc/passwd /etc/shadow /etc/ssh/sshd_config > /tmp/file_hashes.txt" | crontab -
```

### **Emergency Contacts**

- **Team Lead:** [Your team lead contact]
- **Game Admin:** [Admin contact from rules]
- **Backup Systems:** [List your backup systems]

### **Documentation**

**ALWAYS document what you find and fix:**
```bash
# Create incident report
echo "$(date): Found and removed [THREAT_TYPE]" >> /var/log/incident_response.log
echo "Action taken: [DESCRIPTION]" >> /var/log/incident_response.log
echo "Verification: [HOW YOU VERIFIED]" >> /var/log/incident_response.log
```

### **Remember:**
- ✅ **Keep services running** - This is your primary goal
- ✅ **Document everything** - For post-game analysis
- ✅ **Stay calm** - Red Team will keep trying
- ✅ **Work as a team** - Coordinate with your Blue Team members
- ❌ **Don't panic** - You have the tools to handle this

---

**Good luck, Blue Team! 🛡️** 