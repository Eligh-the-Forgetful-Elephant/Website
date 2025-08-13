# Day 1 Defense Checklist

## 🛡️ Blue Team Mission: Keep Services Up, Hunt Red Team

### **Pre-Game Setup (Do This First)**

- [ ] **Update service monitor configuration**
  ```bash
  # Edit defense/service_monitor.sh
  # Update SCORED_SERVICES and SCORED_HOSTS with your actual servers
  ```

- [ ] **Test threat hunter script**
  ```bash
  chmod +x defense/threat_hunter.sh
  ./defense/threat_hunter.sh
  ```

- [ ] **Test service monitor**
  ```bash
  chmod +x defense/service_monitor.sh
  ./defense/service_monitor.sh
  ```

- [ ] **Set up monitoring cron jobs**
  ```bash
  # Run threat hunter every 5 minutes
  echo "*/5 * * * * /path/to/defense/threat_hunter.sh >> /var/log/threat_hunt.log" | crontab -
  ```

### **Game Start (Immediate Actions)**

- [ ] **Start service monitoring**
  ```bash
  ./defense/service_monitor.sh &
  ```

- [ ] **Run initial threat hunt**
  ```bash
  ./defense/threat_hunter.sh
  ```

- [ ] **Verify all scored services are running**
  - [ ] Web server (HTTP/HTTPS)
  - [ ] SSH server
  - [ ] FTP server
  - [ ] DNS server
  - [ ] ICMP working
  - [ ] DNS resolution working

### **Continuous Monitoring (Every 5-10 Minutes)**

- [ ] **Check service status**
  ```bash
  systemctl status apache2 nginx ssh bind9 vsftpd
  ```

- [ ] **Run threat hunter**
  ```bash
  ./defense/threat_hunter.sh
  ```

- [ ] **Check for new processes**
  ```bash
  ps aux | grep -E "(atlas|dotsh|nine|balder|rtw88|cpu_hu|agettyd)"
  ```

- [ ] **Check network connections**
  ```bash
  netstat -tuln | grep -E "(80|443|53)"
  ```

- [ ] **Check for unauthorized users**
  ```bash
  cat /etc/passwd | grep -E "(mattdamon|peter|parker|yourmom|gandalf)"
  ```

### **When Threats Are Found (Immediate Response)**

- [ ] **Document the threat**
  ```bash
  echo "$(date): [THREAT_DESCRIPTION]" >> /var/log/incident_response.log
  ```

- [ ] **Remove persistence**
  - [ ] SSH keys: `sed -i '/malicious_key/d' /root/.ssh/authorized_keys`
  - [ ] Cron jobs: `sed -i '/malicious_cron/d' /etc/crontab`
  - [ ] Processes: `pkill -f "malicious_process"`
  - [ ] Configs: `sed -i '/malicious_config/d' /etc/config`

- [ ] **Verify removal**
  ```bash
  ./defense/threat_hunter.sh
  ```

- [ ] **Ensure services still running**
  ```bash
  ./defense/service_monitor.sh
  ```

### **Prevention Measures (Ongoing)**

- [ ] **Harden SSH**
  ```bash
  # Disable root login, password auth
  sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
  sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
  systemctl restart ssh
  ```

- [ ] **Set up file integrity monitoring**
  ```bash
  # Monitor critical files
  echo "*/10 * * * * md5sum /etc/passwd /etc/shadow /etc/ssh/sshd_config > /tmp/file_hashes.txt" | crontab -
  ```

- [ ] **Monitor network traffic**
  ```bash
  # Monitor suspicious outbound connections
  tcpdump -i any -w /tmp/network_monitor.pcap port 80 or port 443
  netstat -tuln | grep -E "(80|443)" || echo "No suspicious connections found"
  ```

### **Documentation (Throughout the Day)**

- [ ] **Log all findings**
  ```bash
  # Create detailed incident reports
  echo "$(date): [INCIDENT_DETAILS]" >> /var/log/blue_team_actions.log
  ```

- [ ] **Track service uptime**
  ```bash
  # Monitor service availability
  echo "$(date): [SERVICE_STATUS]" >> /var/log/service_uptime.log
  ```

- [ ] **Record Red Team techniques**
  ```bash
  # Document what Red Team is doing
  echo "$(date): [RED_TEAM_TECHNIQUE]" >> /var/log/red_team_analysis.log
  ```

### **End of Day 1**

- [ ] **Final threat hunt**
  ```bash
  ./defense/threat_hunter.sh
  ```

- [ ] **Verify all services running**
  ```bash
  ./defense/service_monitor.sh
  ```

- [ ] **Prepare for Day 2 offense**
  - [ ] Review offensive tools in `offense/` directory
  - [ ] Test Hackwave Havoc deployment
  - [ ] Plan attack strategies

### **Emergency Procedures**

- [ ] **If services go down**
  1. Check `systemctl status [service]`
  2. Restart service: `systemctl restart [service]`
  3. Check logs: `journalctl -u [service]`
  4. Verify network: `ping -c 3 8.8.8.8`

- [ ] **If Red Team gains access**
  1. Document everything
  2. Remove persistence immediately
  3. Change passwords/keys
  4. Monitor for re-entry
  5. Keep services running

- [ ] **If network issues**
  1. Check `ip addr show`
  2. Check `route -n`
  3. Check firewall: `iptables -L`
  4. Restart networking: `systemctl restart networking`

### **Key Reminders**

- ✅ **Primary Goal:** Keep all scored services running
- ✅ **Secondary Goal:** Find and remove Red Team persistence
- ❌ **No Offense:** You cannot attack other teams on Day 1
- ✅ **Document Everything:** For post-game analysis
- ✅ **Stay Calm:** Red Team will keep trying, stay focused

---

**Remember: You're the Blue Team - the defenders! 🛡️**

**Good luck in the CTF!** 