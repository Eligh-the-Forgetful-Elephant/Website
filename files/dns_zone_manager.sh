#!/bin/bash

echo "🔧 DNS Zone Manager - ns0"
echo "=========================="

ZONE_DIR="/etc/bind/zones"
FORWARD_ZONE="$ZONE_DIR/db.localdomain"
REVERSE_ZONE="$ZONE_DIR/db.192.168.0"

add_host() {
    local hostname=$1
    local ip=$2
    
    echo "📝 Adding $hostname ($ip) to DNS zones..."
    
    # Add to forward zone
    echo "$hostname   IN      A       $ip" | sudo tee -a $FORWARD_ZONE
    
    # Extract last octet for reverse zone
    local last_octet=$(echo $ip | cut -d. -f4)
    echo "$last_octet.1    IN      PTR     $hostname.localdomain." | sudo tee -a $REVERSE_ZONE
    
    # Update serial number
    sudo sed -i 's/20230804[0-9][0-9]/20230804'$(date +%d)'/' $FORWARD_ZONE
    sudo sed -i 's/20230804[0-9][0-9]/20230804'$(date +%d)'/' $REVERSE_ZONE
    
    # Reload zones
    sudo rndc reload localdomain
    sudo rndc reload 0.168.192.in-addr.arpa
    
    echo "✅ Added $hostname ($ip) to DNS zones"
}

remove_host() {
    local hostname=$1
    
    echo "🗑️ Removing $hostname from DNS zones..."
    
    # Remove from forward zone
    sudo sed -i "/^$hostname/d" $FORWARD_ZONE
    
    # Remove from reverse zone (find by hostname)
    sudo sed -i "/$hostname.localdomain./d" $REVERSE_ZONE
    
    # Update serial number
    sudo sed -i 's/20230804[0-9][0-9]/20230804'$(date +%d)'/' $FORWARD_ZONE
    sudo sed -i 's/20230804[0-9][0-9]/20230804'$(date +%d)'/' $REVERSE_ZONE
    
    # Reload zones
    sudo rndc reload localdomain
    sudo rndc reload 0.168.192.in-addr.arpa
    
    echo "✅ Removed $hostname from DNS zones"
}

list_hosts() {
    echo "📋 Current DNS Entries:"
    echo "Forward Zone ($FORWARD_ZONE):"
    grep "IN.*A" $FORWARD_ZONE | grep -v "@"
    echo ""
    echo "Reverse Zone ($REVERSE_ZONE):"
    grep "PTR" $REVERSE_ZONE
}

show_usage() {
    echo "Usage: $0 [OPTION] [HOSTNAME] [IP]"
    echo ""
    echo "Options:"
    echo "  add <hostname> <ip>     Add host to DNS zones"
    echo "  remove <hostname>       Remove host from DNS zones"
    echo "  list                    List all DNS entries"
    echo "  reload                  Reload all zones"
    echo ""
    echo "Examples:"
    echo "  $0 add web1 192.168.1.31"
    echo "  $0 remove web1"
    echo "  $0 list"
    echo "  $0 reload"
}

case "$1" in
    "add")
        if [[ -n "$2" && -n "$3" ]]; then
            add_host "$2" "$3"
        else
            echo "❌ Usage: $0 add <hostname> <ip>"
        fi
        ;;
    "remove")
        if [[ -n "$2" ]]; then
            remove_host "$2"
        else
            echo "❌ Usage: $0 remove <hostname>"
        fi
        ;;
    "list")
        list_hosts
        ;;
    "reload")
        echo "🔄 Reloading all zones..."
        sudo rndc reload
        echo "✅ Zones reloaded"
        ;;
    "")
        show_usage
        ;;
    *)
        echo "❌ Unknown option: $1"
        show_usage
        ;;
esac 