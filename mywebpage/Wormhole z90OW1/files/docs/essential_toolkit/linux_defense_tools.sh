#!/bin/bash
# Linux Defense Tools for PVJ CTF
# Uses only built-in Linux commands - no external dependencies

echo "================================================"
echo "LINUX DEFENSE TOOLKIT - PVJ CTF"
echo "================================================"

# Function to log messages with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for ThunderStorm processes
check_processes() {
    log "Checking for ThunderStorm processes..."
    ps aux | grep -i "bolt\|cirrus\|flurry\|guardian\|doppler\|jetstream\|cloudseed\|thunderstorm\|dolphin" | grep -v grep
}

# Check for suspicious network connections
check_network() {
    log "Checking for suspicious network connections..."
    netstat -tuln 2>/dev/null | grep -E ":(8080|8443|9000|9001|4444|1337)"
    ss -tuln 2>/dev/null | grep -E ":(8080|8443|9000|9001|4444|1337)"
}

# Check for suspicious files
check_files() {
    log "Checking for ThunderStorm files..."
    
    # Common ThunderStorm file locations
    files=(
        "/tmp/bolt" "/tmp/cirrus" "/tmp/flurry" "/tmp/guardian"
        "/var/tmp/bolt" "/var/tmp/cirrus" "/var/tmp/flurry"
        "/home/*/bolt" "/root/bolt" "/root/cirrus"
        "/etc/systemd/system/bolt.service"
        "/etc/systemd/system/cirrus.service"
        "/etc/cron.d/bolt" "/etc/cron.d/cirrus"
    )
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            echo "FOUND: $file"
        fi
    done
    
    log "Checking for dolphin malware..."
    # Check for dolphin malware
    if [ -f "/tmp/dolphin" ]; then
        echo "FOUND: /tmp/dolphin"
    fi
    if [ -f "/usr/bin/dolphin" ]; then
        echo "FOUND: /usr/bin/dolphin"
    fi
    
    # Check for binary replacements
    if [ -f "/bin/taskmgr" ]; then
        echo "FOUND: /bin/taskmgr (suspicious binary)"
        file /bin/taskmgr
    fi
    if [ -f "/usr/bin/taskmgr" ]; then
        echo "FOUND: /usr/bin/taskmgr (suspicious binary)"
        file /usr/bin/taskmgr
    fi
}

# Check for suspicious services
check_services() {
    log "Checking for ThunderStorm services..."
    
    if command_exists systemctl; then
        systemctl list-units --type=service | grep -i "bolt\|cirrus\|flurry\|guardian\|dolphin"
    fi
    
    if command_exists service; then
        service --status-all 2>/dev/null | grep -i "bolt\|cirrus\|flurry\|guardian\|dolphin"
    fi
}

# Check for cron jobs
check_cron() {
    log "Checking for suspicious cron jobs..."
    
    # Check system crontab
    crontab -l 2>/dev/null | grep -i "bolt\|cirrus\|flurry\|guardian\|dolphin"
    
    # Check all cron directories
    for cron_dir in /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.monthly /etc/cron.weekly; do
        if [ -d "$cron_dir" ]; then
            for file in "$cron_dir"/*; do
                if [ -f "$file" ]; then
                    grep -l -i "bolt\|cirrus\|flurry\|guardian\|dolphin" "$file" 2>/dev/null
                fi
            done
        fi
    done
}

# Check for startup scripts
check_startup() {
    log "Checking for startup scripts..."
    
    # Check rc.local
    if [ -f "/etc/rc.local" ]; then
        grep -i "bolt\|cirrus\|flurry\|guardian" /etc/rc.local
    fi
    
    # Check init.d
    if [ -d "/etc/init.d" ]; then
        for file in /etc/init.d/*; do
            if [ -f "$file" ]; then
                grep -l -i "bolt\|cirrus\|flurry\|guardian" "$file" 2>/dev/null
            fi
        done
    fi
}

# Monitor mode - continuous monitoring
monitor() {
    local interval=${1:-60}
    log "Starting continuous monitoring (interval: ${interval}s)"
    
    while true; do
        log "Checking for ThunderStorm activity..."
        
        # Check processes
        suspicious_processes=$(check_processes)
        if [ -n "$suspicious_processes" ]; then
            log "WARNING: Suspicious processes detected!"
            echo "$suspicious_processes"
        fi
        
        # Check network
        suspicious_network=$(check_network)
        if [ -n "$suspicious_network" ]; then
            log "WARNING: Suspicious network connections detected!"
            echo "$suspicious_network"
        fi
        
        # Check files
        suspicious_files=$(check_files)
        if [ -n "$suspicious_files" ]; then
            log "WARNING: Suspicious files detected!"
            echo "$suspicious_files"
        fi
        
        log "Monitoring complete. Waiting ${interval} seconds..."
        sleep "$interval"
    done
}

# Hunt mode - comprehensive search
hunt() {
    log "Starting comprehensive ThunderStorm hunt..."
    
    echo
    echo "--- CHECKING PROCESSES ---"
    check_processes
    
    echo
    echo "--- CHECKING NETWORK CONNECTIONS ---"
    check_network
    
    echo
    echo "--- CHECKING SUSPICIOUS FILES ---"
    check_files
    
    echo
    echo "--- CHECKING SERVICES ---"
    check_services
    
    echo
    echo "--- CHECKING CRON JOBS ---"
    check_cron
    
    echo
    echo "--- CHECKING STARTUP SCRIPTS ---"
    check_startup
    
    echo
    log "ThunderStorm hunt complete!"
}

# Cleanup mode - remove ThunderStorm artifacts
cleanup() {
    log "Starting ThunderStorm cleanup..."
    
    echo "Stopping suspicious processes..."
pkill -f bolt 2>/dev/null
pkill -f cirrus 2>/dev/null
pkill -f flurry 2>/dev/null
pkill -f guardian 2>/dev/null
pkill -f doppler 2>/dev/null
pkill -f dolphin 2>/dev/null
    
    echo "Removing suspicious files..."
rm -f /tmp/bolt /tmp/cirrus /tmp/flurry /tmp/guardian 2>/dev/null
rm -f /var/tmp/bolt /var/tmp/cirrus /var/tmp/flurry 2>/dev/null
rm -f /root/bolt /root/cirrus 2>/dev/null
rm -f /home/*/bolt 2>/dev/null

echo "Removing dolphin malware..."
rm -f /tmp/dolphin /usr/bin/dolphin 2>/dev/null
rm -f /bin/taskmgr /usr/bin/taskmgr 2>/dev/null
    
    echo "Clearing temp directories..."
    rm -rf /tmp/* /var/tmp/* 2>/dev/null
    
    echo "Removing suspicious services..."
if command_exists systemctl; then
    systemctl disable bolt.service 2>/dev/null
    systemctl disable cirrus.service 2>/dev/null
    systemctl disable dolphin.service 2>/dev/null
    systemctl stop bolt.service 2>/dev/null
    systemctl stop cirrus.service 2>/dev/null
    systemctl stop dolphin.service 2>/dev/null
fi
    
    echo "Cleaning cron jobs..."
crontab -l 2>/dev/null | grep -v "bolt\|cirrus\|flurry\|guardian\|dolphin" | crontab - 2>/dev/null
    
    echo "Removing suspicious cron files..."
rm -f /etc/cron.d/bolt /etc/cron.d/cirrus /etc/cron.d/dolphin 2>/dev/null
    
    log "Cleanup complete!"
}

# Quick check mode - basic system check
quickcheck() {
    log "Quick system check..."
    
    echo
    echo "--- SYSTEM INFO ---"
    uname -a
    cat /etc/os-release 2>/dev/null | head -5
    
    echo
    echo "--- NETWORK INFO ---"
    ip addr show | grep "inet " | head -5
    
    echo
    echo "--- LISTENING PORTS ---"
    netstat -tuln 2>/dev/null | grep LISTEN | head -10
    
    echo
    echo "--- RUNNING PROCESSES (top 10 by memory) ---"
    ps aux --sort=-%mem | head -11
    
    echo
    echo "--- SUSPICIOUS ACTIVITY CHECK ---"
    suspicious_processes=$(check_processes)
    if [ -n "$suspicious_processes" ]; then
        echo "WARNING: Suspicious processes found!"
        echo "$suspicious_processes"
    else
        echo "No suspicious processes detected."
    fi
    
    suspicious_network=$(check_network)
    if [ -n "$suspicious_network" ]; then
        echo "WARNING: Suspicious network connections found!"
        echo "$suspicious_network"
    else
        echo "No suspicious network connections detected."
    fi
    
    echo
    log "Quick check complete!"
}

# Main script logic
case "${1:-}" in
    "monitor")
        monitor "${2:-60}"
        ;;
    "hunt")
        hunt
        ;;
    "cleanup")
        cleanup
        ;;
    "quickcheck")
        quickcheck
        ;;
    *)
        echo "Usage:"
        echo "  $0 monitor [interval_seconds]"
        echo "  $0 hunt"
        echo "  $0 cleanup"
        echo "  $0 quickcheck"
        ;;
esac

echo
echo "Linux Defense Toolkit complete." 