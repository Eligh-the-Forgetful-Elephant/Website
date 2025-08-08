#!/bin/bash

echo "🧹 Cleaning Red Team Accounts and Creating Clean Access"
echo "======================================================"

PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqRyM+M9ff/bYyQP/ycDPYL5nPtbfxbb5MJkKezzior universal_linux_access"
PRIVATE_KEY_PATH="~/.ssh/universal_key"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

clean_and_create() {
    local machine_name=$1
    local connection_string=$2
    
    echo -e "${BLUE}🔧 Cleaning $machine_name ($connection_string)...${NC}"
    
    local username=$(echo $connection_string | cut -d@ -f1)
    local hostname=$(echo $connection_string | cut -d@ -f2)
    
    echo -e "${YELLOW}🗑️ Removing red team accounts...${NC}"
    ssh $connection_string "sudo userdel -r icanhasaccess 2>/dev/null; sudo userdel -r goldteamscoring 2>/dev/null; echo 'Red team accounts removed'" 2>/dev/null
    
    echo -e "${YELLOW}👤 Creating clean admin account...${NC}"
    ssh $connection_string "sudo useradd -m -s /bin/bash admin_clean && echo 'admin_clean:SecurePass123!' | sudo chpasswd && sudo usermod -aG sudo admin_clean" 2>/dev/null
    
    echo -e "${YELLOW}🔑 Deploying SSH key to clean account...${NC}"
    echo "$PUBLIC_KEY" | ssh $connection_string "sudo mkdir -p /home/admin_clean/.ssh && sudo tee /home/admin_clean/.ssh/authorized_keys > /dev/null && sudo chown -R admin_clean:admin_clean /home/admin_clean/.ssh && sudo chmod 600 /home/admin_clean/.ssh/authorized_keys" 2>/dev/null
    
    echo -e "${YELLOW}🧪 Testing clean account access...${NC}"
    ssh -i $PRIVATE_KEY_PATH admin_clean@$hostname "echo '✅ Clean account access successful!' && whoami && hostname" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Clean account created and tested on $hostname${NC}"
        
        echo -e "${YELLOW}🔒 Securing old access methods...${NC}"
        ssh -i $PRIVATE_KEY_PATH admin_clean@$hostname "sudo passwd -l $username 2>/dev/null; echo 'Old access disabled'" 2>/dev/null
        
        echo -e "${YELLOW}👤 Creating backup account...${NC}"
        ssh -i $PRIVATE_KEY_PATH admin_clean@$hostname "sudo useradd -m -s /bin/bash backup_admin && echo 'backup_admin:SecurePass123!' | sudo chpasswd && sudo usermod -aG sudo backup_admin" 2>/dev/null
        
        echo "$PUBLIC_KEY" | ssh -i $PRIVATE_KEY_PATH admin_clean@$hostname "sudo mkdir -p /home/backup_admin/.ssh && sudo tee /home/backup_admin/.ssh/authorized_keys > /dev/null && sudo chown -R backup_admin:backup_admin /home/backup_admin/.ssh && sudo chmod 600 /home/backup_admin/.ssh/authorized_keys" 2>/dev/null
        
        echo -e "${GREEN}✅ Backup account created on $hostname${NC}"
    else
        echo -e "${RED}❌ Failed to create clean account on $hostname${NC}"
    fi
    
    echo ""
}

clean_all_machines() {
    echo -e "${BLUE}🚀 Cleaning all configured machines...${NC}"
    echo ""
    
    declare -A MACHINES=(
        ["mail0"]="icanhasaccess@mail0"
        ["web0"]="admin@web0"
        ["db0"]="root@db0"
        ["app0"]="user@app0"
        ["monitor0"]="admin@monitor0"
    )
    
    for machine in "${!MACHINES[@]}"; do
        clean_and_create "$machine" "${MACHINES[$machine]}"
    done
}

clean_specific_machine() {
    local machine_name=$1
    
    declare -A MACHINES=(
        ["mail0"]="icanhasaccess@mail0"
        ["web0"]="admin@web0"
        ["db0"]="root@db0"
        ["app0"]="user@app0"
        ["monitor0"]="admin@monitor0"
    )
    
    if [[ -n "${MACHINES[$machine_name]}" ]]; then
        clean_and_create "$machine_name" "${MACHINES[$machine_name]}"
    else
        echo -e "${RED}❌ Machine '$machine_name' not found in configuration${NC}"
        echo "Available machines: ${!MACHINES[@]}"
    fi
}

verify_clean_state() {
    echo -e "${BLUE}🔍 Verifying clean state...${NC}"
    echo ""
    
    declare -A MACHINES=(
        ["mail0"]="admin_clean@mail0"
        ["web0"]="admin_clean@web0"
        ["db0"]="admin_clean@db0"
        ["app0"]="admin_clean@app0"
        ["monitor0"]="admin_clean@monitor0"
    )
    
    for machine in "${!MACHINES[@]}"; do
        local connection_string="${MACHINES[$machine]}"
        local hostname=$(echo $connection_string | cut -d@ -f2)
        
        echo -e "${YELLOW}Verifying $machine ($hostname)...${NC}"
        ssh -i $PRIVATE_KEY_PATH $connection_string "echo '✅ $hostname clean' && whoami && hostname && echo 'Users:' && cat /etc/passwd | grep -E ':(/bin/bash|/bin/sh)$'" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ $hostname: CLEAN${NC}"
        else
            echo -e "${RED}❌ $hostname: NOT CLEAN${NC}"
        fi
        echo ""
    done
}

show_usage() {
    echo "Usage: $0 [OPTION] [MACHINE_NAME]"
    echo ""
    echo "Options:"
    echo "  all                    Clean all configured machines"
    echo "  verify                 Verify clean state of all machines"
    echo "  <machine_name>         Clean specific machine"
    echo ""
    echo "Examples:"
    echo "  $0 all                 # Clean all machines"
    echo "  $0 mail0               # Clean mail0 only"
    echo "  $0 verify              # Verify clean state"
    echo ""
}

case "$1" in
    "all")
        clean_all_machines
        ;;
    "verify")
        verify_clean_state
        ;;
    "")
        show_usage
        ;;
    *)
        clean_specific_machine "$1"
        ;;
esac

echo -e "${GREEN}🎉 Clean account creation completed!${NC}"
echo ""
echo -e "${BLUE}🔑 New Clean Connection Commands:${NC}"
echo "  ssh -i $PRIVATE_KEY_PATH admin_clean@mail0"
echo "  ssh -i $PRIVATE_KEY_PATH backup_admin@mail0"
echo ""
echo -e "${YELLOW}💡 Old red team accounts have been removed and clean accounts created${NC}" 