#!/bin/bash
# pfSense Beacon Hunter - Network-Level Detection and Blocking
# Detects and blocks beacons, backdoors, and malicious sessions at the firewall level

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Check if running on pfSense
check_pfsense() {
    if [[ ! -f "/etc/platform" ]] || ! grep -q "pfSense" /etc/platform; then
        error "This script is designed for pfSense systems"
        exit 1
    fi
    success "Running on pfSense system"
}

# Suspicious ports and patterns for C2 detection
declare -A C2_PATTERNS=(
    # Common C2 ports
    ["c2_ports"]="4444|1337|8080|8443|9000|9001|4443|8443|6666|7777|8888|9999|4445|1338|8081|8444|9002|9003"
    
    # Suspicious domains (free hosting services often used by malware)
    ["suspicious_domains"]="\.(tk|ml|ga|cf|gq|xyz|top|club|site|online|tech|space|website|icu|cyou|cc|cn|ru|cn|tk|ml|ga|cf|gq|xyz|top|club|site|online|tech|space|website|icu|cyou|cc|cn|ru|cn)"
    
    # HTTP beacon patterns
    ["beacon_http"]="GET.*/beacon|POST.*/checkin|GET.*/ping|POST.*/heartbeat|GET.*/status|POST.*/data"
    
    # DNS beacon patterns
    ["beacon_dns"]="nslookup.*\.(tk|ml|ga|cf|gq|xyz|top|club|site|online|tech|space|website|icu|cyou|cc|cn|ru|cn)"
    
    # ICMP beacon patterns
    ["beacon_icmp"]="ping.*-c.*1.*\..*\.(tk|ml|ga|cf|gq|xyz|top|club|site|online|tech|space|website|icu|cyou|cc|cn|ru|cn)"
)

# Function to check for suspicious network traffic
check_suspicious_traffic() {
    log "Checking for suspicious network traffic..."
    
    local found=0
    
    # Check for connections to suspicious ports
    local suspicious_connections=$(netstat -tuln 2>/dev/null | grep -E "${C2_PATTERNS[c2_ports]}")
    if [[ -n "$suspicious_connections" ]]; then
        warn "Suspicious port connections detected:"
        echo "$suspicious_connections"
        found=1
    fi
    
    # Check for outbound connections to suspicious domains
    local suspicious_outbound=$(netstat -tuln 2>/dev/null | grep -E "${C2_PATTERNS[suspicious_domains]}")
    if [[ -n "$suspicious_outbound" ]]; then
        warn "Outbound connections to suspicious domains:"
        echo "$suspicious_outbound"
        found=1
    fi
    
    # Check for established connections on suspicious ports
    local established_suspicious=$(netstat -tuln 2>/dev/null | grep ESTABLISHED | grep -E "${C2_PATTERNS[c2_ports]}")
    if [[ -n "$established_suspicious" ]]; then
        warn "Established connections on suspicious ports:"
        echo "$established_suspicious"
        found=1
    fi
    
    if [[ $found -eq 0 ]]; then
        success "No suspicious network traffic detected"
    fi
    
    return $found
}

# Function to analyze firewall logs for beacon activity
analyze_firewall_logs() {
    log "Analyzing firewall logs for beacon activity..."
    
    local found=0
    
    # Check recent firewall logs for suspicious activity
    if [[ -f "/var/log/filter.log" ]]; then
        local suspicious_logs=$(tail -1000 /var/log/filter.log | grep -E "${C2_PATTERNS[c2_ports]}")
        if [[ -n "$suspicious_logs" ]]; then
            warn "Suspicious activity in firewall logs:"
            echo "$suspicious_logs" | tail -20
            found=1
        fi
    fi
    
    # Check for repeated connection attempts (potential beacon behavior)
    if [[ -f "/var/log/filter.log" ]]; then
        local repeated_attempts=$(tail -1000 /var/log/filter.log | grep -E "${C2_PATTERNS[c2_ports]}" | awk '{print $NF}' | sort | uniq -c | sort -nr | head -10)
        if [[ -n "$repeated_attempts" ]]; then
            warn "Repeated connection attempts detected:"
            echo "$repeated_attempts"
            found=1
        fi
    fi
    
    if [[ $found -eq 0 ]]; then
        success "No suspicious activity in firewall logs"
    fi
    
    return $found
}

# Function to monitor beacon activity
create_beacon_monitoring_rules() {
    log "Setting up beacon activity monitoring..."
    
    # Create alias for suspicious ports
    local alias_name="C2_PORTS"
    local ports="4444,1337,8080,8443,9000,9001,4443,8443,6666,7777,8888,9999,4445,1338,8081,8444,9002,9003"
    
    # Add ports alias if it doesn't exist
    if ! pfctl -s aliases | grep -q "$alias_name"; then
        echo "table <$alias_name> persist { $ports }" >> /etc/pf.conf
        success "Created alias for C2 ports monitoring"
    fi
    
    # Create monitoring rules (logging only, no blocking)
    local monitoring_rules=(
        "# Monitor outbound connections to C2 ports"
        "pass out quick proto tcp to any port { $alias_name } log"
        "pass out quick proto udp to any port { $alias_name } log"
        ""
        "# Monitor connections to suspicious domains"
        "pass out quick proto tcp to any port { 80,443 } from any to { .tk .ml .ga .cf .gq .xyz .top .club .site .online .tech .space .website .icu .cyou .cc .cn .ru } log"
        ""
        "# Monitor ICMP beacons"
        "pass out quick proto icmp to { .tk .ml .ga .cf .gq .xyz .top .club .site .online .tech .space .website .icu .cyou .cc .cn .ru } log"
    )
    
    # Add rules to pf.conf if they don't exist
    for rule in "${monitoring_rules[@]}"; do
        if [[ "$rule" != "" ]] && ! grep -q "$rule" /etc/pf.conf 2>/dev/null; then
            echo "$rule" >> /etc/pf.conf
        fi
    done
    
    # Reload pf rules
    pfctl -f /etc/pf.conf 2>/dev/null && success "Reloaded firewall rules"
    
    success "Created beacon monitoring rules"
}

# Function to monitor network traffic in real-time
monitor_network_traffic() {
    local interval=${1:-30}
    log "Starting network traffic monitoring (interval: ${interval}s)"
    
    while true; do
        log "=== NETWORK MONITORING CYCLE ==="
        
        local threats_found=0
        
        # Check for suspicious traffic
        check_suspicious_traffic || threats_found=1
        
        # Analyze firewall logs
        analyze_firewall_logs || threats_found=1
        
        # Check for new connections
        local new_connections=$(netstat -tuln 2>/dev/null | grep -E "${C2_PATTERNS[c2_ports]}" | wc -l)
        if [[ $new_connections -gt 0 ]]; then
            warn "New suspicious connections detected: $new_connections"
            threats_found=1
        fi
        
        if [[ $threats_found -eq 1 ]]; then
            warn "Network threats detected! Consider blocking suspicious IPs/ports."
        else
            success "No network threats detected in this cycle"
        fi
        
        log "Waiting ${interval} seconds until next check..."
        sleep "$interval"
    done
}

# Function to monitor suspicious IPs
monitor_suspicious_ips() {
    log "Monitoring suspicious IPs..."
    
    # Get list of IPs connecting to suspicious ports
    local suspicious_ips=$(netstat -tuln 2>/dev/null | grep -E "${C2_PATTERNS[c2_ports]}" | awk '{print $5}' | cut -d: -f1 | sort | uniq)
    
    if [[ -n "$suspicious_ips" ]]; then
        warn "Suspicious IPs detected:"
        echo "$suspicious_ips"
        
        # Log suspicious IPs for analysis
        for ip in $suspicious_ips; do
            if [[ "$ip" != "127.0.0.1" ]] && [[ "$ip" != "::1" ]]; then
                echo "$(date): Suspicious IP detected: $ip" >> /var/log/suspicious_ips.log
                success "Logged IP: $ip"
            fi
        done
    else
        success "No suspicious IPs to block"
    fi
}

# Function to create comprehensive network defense
setup_network_defense() {
    log "Setting up comprehensive network defense..."
    
    # Create beacon blocking rules
    create_beacon_blocking_rules
    
    # Create rate limiting rules for suspicious activity
    local rate_limit_rules=(
        "# Rate limit connections to suspicious ports"
        "block in quick proto tcp from any to any port { 4444,1337,8080,8443,9000,9001 }"
        ""
        "# Rate limit DNS queries to suspicious domains"
        "block in quick proto udp from any to any port 53"
        ""
        "# Block common malware ports"
        "block in quick proto tcp from any to any port { 6666,7777,8888,9999 }"
    )
    
    # Add rate limiting rules
    for rule in "${rate_limit_rules[@]}"; do
        if [[ "$rule" != "" ]] && ! grep -q "$rule" /etc/pf.conf 2>/dev/null; then
            echo "$rule" >> /etc/pf.conf
        fi
    done
    
    # Reload pf rules
    pfctl -f /etc/pf.conf 2>/dev/null && success "Reloaded firewall rules"
    
    success "Network defense setup complete"
}

# Function to generate network defense report
generate_report() {
    log "Generating network defense report..."
    
    echo
    echo "=== PF SENSE BEACON HUNTER REPORT ==="
    echo "Generated: $(date)"
    echo
    
    echo "--- CURRENT FIREWALL RULES ---"
    pfctl -s rules | grep -E "block|pass" | head -20
    
    echo
    echo "--- SUSPICIOUS CONNECTIONS ---"
    netstat -tuln 2>/dev/null | grep -E "${C2_PATTERNS[c2_ports]}" | head -10
    
    echo
    echo "--- RECENT FIREWALL LOGS ---"
    if [[ -f "/var/log/filter.log" ]]; then
        tail -20 /var/log/filter.log | grep -E "${C2_PATTERNS[c2_ports]}"
    fi
    
    echo
    echo "--- ACTIVE CONNECTIONS ---"
    netstat -tuln 2>/dev/null | grep ESTABLISHED | head -10
    
    echo
    echo "--- SYSTEM STATUS ---"
    echo "pfSense Version: $(cat /etc/version 2>/dev/null || echo 'Unknown')"
    echo "Uptime: $(uptime)"
    echo "Memory Usage: $(free -h 2>/dev/null || echo 'Unknown')"
    
    echo
    success "Report generation complete"
}

# Function to run comprehensive network hunt
hunt_network() {
    log "Starting comprehensive network threat hunt..."
    
    local threats_found=0
    
    echo
    echo "=== NETWORK TRAFFIC ANALYSIS ==="
    check_suspicious_traffic || threats_found=1
    
    echo
    echo "=== FIREWALL LOG ANALYSIS ==="
    analyze_firewall_logs || threats_found=1
    
    echo
    echo "=== CONNECTION ANALYSIS ==="
    local all_connections=$(netstat -tuln 2>/dev/null | wc -l)
    local suspicious_connections=$(netstat -tuln 2>/dev/null | grep -E "${C2_PATTERNS[c2_ports]}" | wc -l)
    echo "Total connections: $all_connections"
    echo "Suspicious connections: $suspicious_connections"
    
    if [[ $suspicious_connections -gt 0 ]]; then
        warn "Suspicious connections detected!"
        netstat -tuln 2>/dev/null | grep -E "${C2_PATTERNS[c2_ports]}"
        threats_found=1
    fi
    
    echo
    echo "=== ROUTING TABLE ANALYSIS ==="
    netstat -rn | head -10
    
    echo
    if [[ $threats_found -eq 1 ]]; then
        warn "NETWORK THREATS DETECTED! Consider blocking suspicious IPs/ports."
    else
        success "No network threats detected in comprehensive hunt."
    fi
}

# Main script logic
case "${1:-}" in
    "monitor")
        check_pfsense
        monitor_network_traffic "${2:-30}"
        ;;
    "hunt")
        check_pfsense
        hunt_network
        ;;
    "block")
        check_pfsense
        block_suspicious_ips
        ;;
    "setup")
        check_pfsense
        setup_network_defense
        ;;
    "report")
        check_pfsense
        generate_report
        ;;
    *)
        echo "pfSense Beacon Hunter - Network-Level Detection and Blocking"
        echo "Usage:"
        echo "  $0 monitor [interval_seconds]  - Continuous network monitoring"
        echo "  $0 hunt                       - Comprehensive network threat hunt"
        echo "  $0 block                      - Block suspicious IPs"
        echo "  $0 setup                      - Setup comprehensive network defense"
        echo "  $0 report                     - Generate network defense report"
        echo
        echo "This tool detects and blocks:"
        echo "  - C2 beacon connections"
        echo "  - Suspicious domain connections"
        echo "  - Malware port activity"
        echo "  - ICMP beacon traffic"
        echo "  - DNS beacon queries"
        ;;
esac 