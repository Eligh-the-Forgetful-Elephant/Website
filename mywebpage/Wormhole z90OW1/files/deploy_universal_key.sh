#!/bin/bash
# Universal SSH Key Deployment Script for All Linux Machines

echo "🔑 Universal SSH Key Deployment Script"
echo "======================================"

# Configuration
PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqRyM+M9ff/bYyQP/ycDPYL5nPtbfxbb5MJkKezzior universal_linux_access"
PRIVATE_KEY_PATH="~/.ssh/universal_key"

# Define target machines (add more as needed)
declare -A TARGETS=(
    ["mail0"]="icanhasaccess@mail0"
    ["web0"]="admin@web0"
    ["db0"]="root@db0"
    ["app0"]="user@app0"
    ["monitor0"]="admin@monitor0"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to deploy key to a single machine
deploy_to_machine() {
    local machine_name=$1
    local connection_string=$2
    
    echo -e "${BLUE}🔧 Deploying to $machine_name ($connection_string)...${NC}"
    
    # Extract username and hostname
    local username=$(echo $connection_string | cut -d@ -f1)
    local hostname=$(echo $connection_string | cut -d@ -f2)
    
    # Deploy key to main user
    echo -e "${YELLOW}📤 Copying key to $username@$hostname...${NC}"
    echo "$PUBLIC_KEY" | ssh $connection_string "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Key deployed to $username@$hostname${NC}"
        
        # Test connection with new key
        echo -e "${YELLOW}🧪 Testing connection...${NC}"
        ssh -i $PRIVATE_KEY_PATH $connection_string "echo '✅ Universal key access successful!' && whoami && hostname" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Connection test successful!${NC}"
            
            # Create backup admin user
            echo -e "${YELLOW}👤 Creating backup admin user...${NC}"
            ssh -i $PRIVATE_KEY_PATH $connection_string "sudo useradd -m -s /bin/bash backup_admin 2>/dev/null; echo 'backup_admin:SecurePass123!' | sudo chpasswd; sudo usermod -aG sudo backup_admin 2>/dev/null" 2>/dev/null
            
            # Deploy key to backup user
            echo -e "${YELLOW}🔑 Deploying key to backup user...${NC}"
            echo "$PUBLIC_KEY" | ssh -i $PRIVATE_KEY_PATH $connection_string "sudo mkdir -p /home/backup_admin/.ssh && sudo tee /home/backup_admin/.ssh/authorized_keys > /dev/null && sudo chown -R backup_admin:backup_admin /home/backup_admin/.ssh && sudo chmod 600 /home/backup_admin/.ssh/authorized_keys" 2>/dev/null
            
            echo -e "${GREEN}✅ Backup user created on $hostname${NC}"
        else
            echo -e "${RED}❌ Connection test failed for $hostname${NC}"
        fi
    else
        echo -e "${RED}❌ Failed to deploy key to $hostname${NC}"
    fi
    
    echo ""
}

# Function to deploy to all machines
deploy_to_all() {
    echo -e "${BLUE}🚀 Deploying to all configured machines...${NC}"
    echo ""
    
    for machine in "${!TARGETS[@]}"; do
        deploy_to_machine "$machine" "${TARGETS[$machine]}"
    done
}

# Function to deploy to specific machine
deploy_to_specific() {
    local machine_name=$1
    
    if [[ -n "${TARGETS[$machine_name]}" ]]; then
        deploy_to_machine "$machine_name" "${TARGETS[$machine_name]}"
    else
        echo -e "${RED}❌ Machine '$machine_name' not found in configuration${NC}"
        echo "Available machines: ${!TARGETS[@]}"
    fi
}

# Function to add new machine
add_machine() {
    local machine_name=$1
    local connection_string=$2
    
    if [[ -n "$machine_name" && -n "$connection_string" ]]; then
        TARGETS["$machine_name"]="$connection_string"
        echo -e "${GREEN}✅ Added $machine_name ($connection_string) to configuration${NC}"
    else
        echo -e "${RED}❌ Usage: add_machine <machine_name> <user@hostname>${NC}"
    fi
}

# Function to list configured machines
list_machines() {
    echo -e "${BLUE}📋 Configured Machines:${NC}"
    for machine in "${!TARGETS[@]}"; do
        echo "  $machine: ${TARGETS[$machine]}"
    done
    echo ""
}

# Function to test all connections
test_all_connections() {
    echo -e "${BLUE}🧪 Testing all connections...${NC}"
    echo ""
    
    for machine in "${!TARGETS[@]}"; do
        local connection_string="${TARGETS[$machine]}"
        local hostname=$(echo $connection_string | cut -d@ -f2)
        
        echo -e "${YELLOW}Testing $machine ($hostname)...${NC}"
        ssh -i $PRIVATE_KEY_PATH $connection_string "echo '✅ $hostname accessible' && whoami && hostname" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ $hostname: SUCCESS${NC}"
        else
            echo -e "${RED}❌ $hostname: FAILED${NC}"
        fi
        echo ""
    done
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTION] [MACHINE_NAME]"
    echo ""
    echo "Options:"
    echo "  all                    Deploy to all configured machines"
    echo "  test                   Test connections to all machines"
    echo "  list                   List configured machines"
    echo "  add <name> <user@host> Add new machine to configuration"
    echo "  <machine_name>         Deploy to specific machine"
    echo ""
    echo "Examples:"
    echo "  $0 all                 # Deploy to all machines"
    echo "  $0 mail0               # Deploy to mail0 only"
    echo "  $0 test                # Test all connections"
    echo "  $0 add web1 admin@web1 # Add new machine"
    echo ""
}

# Main script logic
case "$1" in
    "all")
        deploy_to_all
        ;;
    "test")
        test_all_connections
        ;;
    "list")
        list_machines
        ;;
    "add")
        add_machine "$2" "$3"
        ;;
    "")
        show_usage
        ;;
    *)
        deploy_to_specific "$1"
        ;;
esac

echo -e "${GREEN}🎉 Deployment script completed!${NC}"
echo ""
echo -e "${BLUE}🔑 Connection Commands:${NC}"
echo "  ssh -i $PRIVATE_KEY_PATH icanhasaccess@mail0"
echo "  ssh -i $PRIVATE_KEY_PATH backup_admin@mail0"
echo ""
echo -e "${YELLOW}💡 Tip: Add machines to the TARGETS array in the script for permanent configuration${NC}" 