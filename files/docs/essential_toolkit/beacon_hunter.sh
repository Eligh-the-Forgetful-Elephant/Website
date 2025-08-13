#!/bin/bash
# Beacon Hunter - Advanced Detection and Removal Tool
# Detects and kills beacons, backdoors, and malicious sessions using regex patterns

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

# Regex patterns for different types of beacons/backdoors
declare -A PATTERNS=(
    # ThunderStorm C2 patterns
    ["thunderstorm_process"]="bolt|cirrus|flurry|guardian|doppler|jetstream|cloudseed|thunderstorm"
    ["thunderstorm_network"]=":(8080|8443|9000|9001|4444|1337|4443|8443)"
    ["thunderstorm_files"]="bolt|cirrus|flurry|guardian|dolphin"
    
    # Generic C2 patterns
    ["c2_process"]="c2|beacon|implant|agent|payload|shell|reverse"
    ["c2_network"]=":(4444|1337|8080|8443|9000|9001|4443|8443|6666|7777|8888|9999)"
    ["c2_domains"]="\.(tk|ml|ga|cf|gq|xyz|top|club|site|online|tech|space|website|icu|cyou|cc|cn|ru|cn|tk|ml|ga|cf|gq|xyz|top|club|site|online|tech|space|website|icu|cyou|cc|cn|ru|cn)"
    
    # PowerShell/Windows patterns
    ["powershell_evil"]="powershell.*-enc|powershell.*-e|powershell.*base64|iex.*http|invoke-expression.*http"
    ["wmic_evil"]="wmic.*process.*call.*create|wmic.*process.*call.*create.*cmd"
    ["rundll32_evil"]="rundll32.*javascript|rundll32.*vbscript|rundll32.*http"
    
    # Linux persistence patterns
    ["rc_local"]="(/tmp|/var/tmp|/dev/shm)/.*(sh|bash|python|perl|ruby)"
    ["cron_evil"]="@(reboot|yearly|annually|monthly|weekly|daily|hourly|minutely).*http"
    ["systemd_evil"]="ExecStart.*(/tmp|/var/tmp|/dev/shm)/.*(sh|bash|python|perl|ruby)"
    
    # Binary replacement patterns
    ["binary_replacement"]="taskmgr|cmd|powershell|bash|sh|python|perl|ruby"
    
    # Network beacon patterns
    ["beacon_http"]="GET.*/beacon|POST.*/checkin|GET.*/ping|POST.*/heartbeat"
    ["beacon_dns"]="nslookup.*\.(tk|ml|ga|cf|gq|xyz|top|club|site|online|tech|space|website|icu|cyou|cc|cn|ru|cn)"
    ["beacon_icmp"]="ping.*-c.*1.*\..*\.(tk|ml|ga|cf|gq|xyz|top|club|site|online|tech|space|website|icu|cyou|cc|cn|ru|cn)"
)

# Function to check for suspicious processes
check_suspicious_processes() {
    log "Checking for suspicious processes..."
    
    local found=0
    
    # Check for ThunderStorm processes
    local thunderstorm_procs=$(ps aux | grep -E "${PATTERNS[thunderstorm_process]}" | grep -v grep)
    if [[ -n "$thunderstorm_procs" ]]; then
        warn "ThunderStorm processes detected:"
        echo "$thunderstorm_procs"
        found=1
    fi
    
    # Check for generic C2 processes
    local c2_procs=$(ps aux | grep -E "${PATTERNS[c2_process]}" | grep -v grep)
    if [[ -n "$c2_procs" ]]; then
        warn "C2 processes detected:"
        echo "$c2_procs"
        found=1
    fi
    
    # Check for processes with suspicious command lines
    local suspicious_cmds=$(ps aux | grep -E "curl.*http|wget.*http|nc.*-l|netcat.*-l|python.*-c.*http|perl.*-e.*http" | grep -v grep)
    if [[ -n "$suspicious_cmds" ]]; then
        warn "Processes with suspicious command lines:"
        echo "$suspicious_cmds"
        found=1
    fi
    
    # Check for processes with high CPU/memory usage
    local high_usage=$(ps aux --sort=-%cpu | head -20 | grep -E "([0-9]{2,}\.[0-9]%|[0-9]{3,}%)" | grep -v "systemd\|kernel\|init")
    if [[ -n "$high_usage" ]]; then
        warn "Processes with high resource usage:"
        echo "$high_usage"
        found=1
    fi
    
    if [[ $found -eq 0 ]]; then
        success "No suspicious processes detected"
    fi
    
    return $found
}

# Function to check for suspicious network connections
check_suspicious_network() {
    log "Checking for suspicious network connections..."
    
    local found=0
    
    # Check for ThunderStorm ports
    local thunderstorm_ports=$(netstat -tuln 2>/dev/null | grep -E "${PATTERNS[thunderstorm_network]}")
    if [[ -n "$thunderstorm_ports" ]]; then
        warn "ThunderStorm ports detected:"
        echo "$thunderstorm_ports"
        found=1
    fi
    
    # Check for C2 ports
    local c2_ports=$(netstat -tuln 2>/dev/null | grep -E "${PATTERNS[c2_network]}")
    if [[ -n "$c2_ports" ]]; then
        warn "C2 ports detected:"
        echo "$c2_ports"
        found=1
    fi
    
    # Check for outbound connections to suspicious domains
    local suspicious_outbound=$(netstat -tuln 2>/dev/null | grep -E "${PATTERNS[c2_domains]}")
    if [[ -n "$suspicious_outbound" ]]; then
        warn "Outbound connections to suspicious domains:"
        echo "$suspicious_outbound"
        found=1
    fi
    
    # Check for established connections
    local established=$(netstat -tuln 2>/dev/null | grep ESTABLISHED | grep -E "${PATTERNS[c2_network]}")
    if [[ -n "$established" ]]; then
        warn "Established connections on suspicious ports:"
        echo "$established"
        found=1
    fi
    
    if [[ $found -eq 0 ]]; then
        success "No suspicious network connections detected"
    fi
    
    return $found
}

# Function to check for suspicious files
check_suspicious_files() {
    log "Checking for suspicious files..."
    
    local found=0
    
    # Common locations for backdoors
    local locations=(
        "/tmp" "/var/tmp" "/dev/shm" "/home/*" "/root" 
        "/etc/systemd/system" "/etc/init.d" "/usr/local/bin"
        "/usr/bin" "/bin" "/sbin" "/usr/sbin"
    )
    
    for location in "${locations[@]}"; do
        if [[ -d "$location" ]]; then
            # Check for ThunderStorm files
            local thunderstorm_files=$(find "$location" -maxdepth 1 -type f -name "*bolt*" -o -name "*cirrus*" -o -name "*flurry*" -o -name "*guardian*" -o -name "*dolphin*" 2>/dev/null)
            if [[ -n "$thunderstorm_files" ]]; then
                warn "ThunderStorm files found in $location:"
                echo "$thunderstorm_files"
                found=1
            fi
            
            # Check for suspicious binary names
            local suspicious_bins=$(find "$location" -maxdepth 1 -type f -executable \( -name "*taskmgr*" -o -name "*cmd*" -o -name "*shell*" -o -name "*backdoor*" \) 2>/dev/null)
            if [[ -n "$suspicious_bins" ]]; then
                warn "Suspicious binaries found in $location:"
                echo "$suspicious_bins"
                found=1
            fi
        fi
    done
    
    # Check for hidden files
    local hidden_files=$(find /tmp /var/tmp /dev/shm /home/* /root -name ".*" -type f -executable 2>/dev/null | head -10)
    if [[ -n "$hidden_files" ]]; then
        warn "Hidden executable files found:"
        echo "$hidden_files"
        found=1
    fi
    
    if [[ $found -eq 0 ]]; then
        success "No suspicious files detected"
    fi
    
    return $found
}

# Function to check for persistence mechanisms
check_persistence() {
    log "Checking for persistence mechanisms..."
    
    local found=0
    
    # Check crontab
    local suspicious_cron=$(crontab -l 2>/dev/null | grep -E "${PATTERNS[cron_evil]}")
    if [[ -n "$suspicious_cron" ]]; then
        warn "Suspicious cron jobs found:"
        echo "$suspicious_cron"
        found=1
    fi
    
    # Check systemd services
    if command -v systemctl >/dev/null 2>&1; then
        local suspicious_services=$(systemctl list-units --type=service | grep -E "${PATTERNS[thunderstorm_process]}")
        if [[ -n "$suspicious_services" ]]; then
            warn "Suspicious systemd services found:"
            echo "$suspicious_services"
            found=1
        fi
    fi
    
    # Check rc.local
    if [[ -f "/etc/rc.local" ]]; then
        local suspicious_rc=$(grep -E "${PATTERNS[rc_local]}" /etc/rc.local)
        if [[ -n "$suspicious_rc" ]]; then
            warn "Suspicious entries in rc.local:"
            echo "$suspicious_rc"
            found=1
        fi
    fi
    
    # Check bashrc and profile files
    local profile_files=(
        "/etc/bash.bashrc" "/etc/profile" "/etc/bashrc"
        "/root/.bashrc" "/root/.profile" "/root/.bash_profile"
    )
    
    for profile in "${profile_files[@]}"; do
        if [[ -f "$profile" ]]; then
            local suspicious_profile=$(grep -E "curl.*http|wget.*http|nc.*-l|python.*-c.*http" "$profile")
            if [[ -n "$suspicious_profile" ]]; then
                warn "Suspicious entries in $profile:"
                echo "$suspicious_profile"
                found=1
            fi
        fi
    done
    
    if [[ $found -eq 0 ]]; then
        success "No persistence mechanisms detected"
    fi
    
    return $found
}

# Function to check for binary replacements
check_binary_replacements() {
    log "Checking for binary replacements..."
    
    local found=0
    
    # Check for suspicious binaries in common locations
    local suspicious_locations=(
        "/bin/taskmgr" "/usr/bin/taskmgr" "/usr/local/bin/taskmgr"
        "/bin/cmd" "/usr/bin/cmd" "/usr/local/bin/cmd"
        "/bin/shell" "/usr/bin/shell" "/usr/local/bin/shell"
    )
    
    for binary in "${suspicious_locations[@]}"; do
        if [[ -f "$binary" ]]; then
            warn "Suspicious binary found: $binary"
            file "$binary"
            found=1
        fi
    done
    
    # Check for modified system binaries
    local system_bins=("/bin/bash" "/bin/sh" "/usr/bin/python" "/usr/bin/perl")
    for binary in "${system_bins[@]}"; do
        if [[ -f "$binary" ]]; then
            local file_info=$(file "$binary")
            if echo "$file_info" | grep -q "not stripped\|dynamically linked"; then
                warn "Potentially modified system binary: $binary"
                echo "$file_info"
                found=1
            fi
        fi
    done
    
    if [[ $found -eq 0 ]]; then
        success "No binary replacements detected"
    fi
    
    return $found
}

# Function to kill detected threats
kill_threats() {
    log "Killing detected threats..."
    
    # Kill ThunderStorm processes
    pkill -f "bolt" 2>/dev/null && success "Killed bolt processes"
    pkill -f "cirrus" 2>/dev/null && success "Killed cirrus processes"
    pkill -f "flurry" 2>/dev/null && success "Killed flurry processes"
    pkill -f "guardian" 2>/dev/null && success "Killed guardian processes"
    pkill -f "dolphin" 2>/dev/null && success "Killed dolphin processes"
    
    # Kill C2 processes
    pkill -f "c2" 2>/dev/null && success "Killed c2 processes"
    pkill -f "beacon" 2>/dev/null && success "Killed beacon processes"
    pkill -f "implant" 2>/dev/null && success "Killed implant processes"
    
    # Kill processes with suspicious command lines
    pkill -f "curl.*http" 2>/dev/null && success "Killed curl processes"
    pkill -f "wget.*http" 2>/dev/null && success "Killed wget processes"
    pkill -f "nc.*-l" 2>/dev/null && success "Killed netcat listener processes"
    pkill -f "python.*-c.*http" 2>/dev/null && success "Killed suspicious python processes"
    
    # Remove suspicious files
    rm -f /tmp/bolt /tmp/cirrus /tmp/flurry /tmp/guardian /tmp/dolphin 2>/dev/null
    rm -f /var/tmp/bolt /var/tmp/cirrus /var/tmp/flurry /var/tmp/guardian /var/tmp/dolphin 2>/dev/null
    rm -f /root/bolt /root/cirrus /root/flurry /root/guardian /root/dolphin 2>/dev/null
    
    # Remove suspicious binaries
    rm -f /bin/taskmgr /usr/bin/taskmgr /usr/local/bin/taskmgr 2>/dev/null
    rm -f /bin/cmd /usr/bin/cmd /usr/local/bin/cmd 2>/dev/null
    rm -f /bin/shell /usr/bin/shell /usr/local/bin/shell 2>/dev/null
    
    # Clean up temp directories
    find /tmp /var/tmp /dev/shm -name ".*" -type f -executable -delete 2>/dev/null
    
    success "Threat removal complete"
}

# Function to monitor continuously
monitor_mode() {
    local interval=${1:-30}
    log "Starting continuous monitoring (interval: ${interval}s)"
    
    while true; do
        log "=== MONITORING CYCLE ==="
        
        local threats_found=0
        
        check_suspicious_processes || threats_found=1
        check_suspicious_network || threats_found=1
        check_suspicious_files || threats_found=1
        check_persistence || threats_found=1
        check_binary_replacements || threats_found=1
        
        if [[ $threats_found -eq 1 ]]; then
            warn "Threats detected! Consider running cleanup mode."
        else
            success "No threats detected in this cycle"
        fi
        
        log "Waiting ${interval} seconds until next check..."
        sleep "$interval"
    done
}

# Function to run comprehensive hunt
hunt_mode() {
    log "Starting comprehensive threat hunt..."
    
    local threats_found=0
    
    echo
    echo "=== PROCESS ANALYSIS ==="
    check_suspicious_processes || threats_found=1
    
    echo
    echo "=== NETWORK ANALYSIS ==="
    check_suspicious_network || threats_found=1
    
    echo
    echo "=== FILE SYSTEM ANALYSIS ==="
    check_suspicious_files || threats_found=1
    
    echo
    echo "=== PERSISTENCE ANALYSIS ==="
    check_persistence || threats_found=1
    
    echo
    echo "=== BINARY ANALYSIS ==="
    check_binary_replacements || threats_found=1
    
    echo
    if [[ $threats_found -eq 1 ]]; then
        warn "THREATS DETECTED! Run cleanup mode to remove them."
    else
        success "No threats detected in comprehensive hunt."
    fi
}

# Function to run cleanup
cleanup_mode() {
    log "Starting threat cleanup..."
    
    echo "Killing malicious processes..."
    kill_threats
    
    echo "Cleaning up persistence mechanisms..."
    
    # Clean crontab
    if crontab -l 2>/dev/null | grep -q -E "${PATTERNS[cron_evil]}"; then
        crontab -l 2>/dev/null | grep -v -E "${PATTERNS[cron_evil]}" | crontab -
        success "Cleaned suspicious cron jobs"
    fi
    
    # Clean systemd services
    if command -v systemctl >/dev/null 2>&1; then
        systemctl disable bolt.service 2>/dev/null && success "Disabled bolt service"
        systemctl disable cirrus.service 2>/dev/null && success "Disabled cirrus service"
        systemctl disable dolphin.service 2>/dev/null && success "Disabled dolphin service"
        systemctl stop bolt.service 2>/dev/null && success "Stopped bolt service"
        systemctl stop cirrus.service 2>/dev/null && success "Stopped cirrus service"
        systemctl stop dolphin.service 2>/dev/null && success "Stopped dolphin service"
    fi
    
    # Clean rc.local
    if [[ -f "/etc/rc.local" ]]; then
        sed -i '/curl.*http\|wget.*http\|nc.*-l\|python.*-c.*http/d' /etc/rc.local 2>/dev/null
        success "Cleaned rc.local"
    fi
    
    # Clean profile files
    local profile_files=(
        "/etc/bash.bashrc" "/etc/profile" "/etc/bashrc"
        "/root/.bashrc" "/root/.profile" "/root/.bash_profile"
    )
    
    for profile in "${profile_files[@]}"; do
        if [[ -f "$profile" ]]; then
            sed -i '/curl.*http\|wget.*http\|nc.*-l\|python.*-c.*http/d' "$profile" 2>/dev/null
        fi
    done
    success "Cleaned profile files"
    
    success "Cleanup complete!"
}

# Main script logic
case "${1:-}" in
    "monitor")
        monitor_mode "${2:-30}"
        ;;
    "hunt")
        hunt_mode
        ;;
    "cleanup")
        cleanup_mode
        ;;
    "kill")
        kill_threats
        ;;
    *)
        echo "Beacon Hunter - Advanced Detection and Removal Tool"
        echo "Usage:"
        echo "  $0 monitor [interval_seconds]  - Continuous monitoring"
        echo "  $0 hunt                       - Comprehensive threat hunt"
        echo "  $0 cleanup                    - Remove detected threats"
        echo "  $0 kill                       - Kill processes and remove files"
        echo
        echo "This tool uses regex patterns to detect:"
        echo "  - ThunderStorm C2 components"
        echo "  - Generic C2 beacons and implants"
        echo "  - Binary replacements and backdoors"
        echo "  - Persistence mechanisms"
        echo "  - Suspicious network connections"
        ;;
esac 