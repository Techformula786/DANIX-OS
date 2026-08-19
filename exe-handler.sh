#!/data/data/com.termux/files/usr/bin/bash
#########################################################################
#  📱 DANIX OS - Advanced Windows (.EXE) Execution Engine
#  Developer & Author: Mohd Danish Iqbal
#  YouTube: techformula 786
#  
#  Features:
#  - Smart Storage Bypass (Fixes Android 11+ execution limits)
#  - Cache Management (Auto-cleans old files to save storage)
#  - Nohup & Disown (Prevents app crashes when terminal closes)
#  - X11 Display Auto-Routing (Fixes headless errors)
#  - Cyberpunk TUI Logging System
#########################################################################

# ==========================================
# 🎨 COLOR CODES & UI SETUP
# ==========================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'
BOLD='\033[1m'

# ==========================================
# 🎬 CINEMATIC BANNER
# ==========================================
clear
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "       ${BLUE}${BOLD}🚀 DANIX ADVANCED WINDOWS EXECUTION ENGINE${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# ==========================================
# 🔍 STEP 1: ARGUMENT & DISPLAY CHECKS
# ==========================================
EXE_FILE="$1"

if [ -z "$EXE_FILE" ]; then
    echo -e "${RED}[ ✘ ] CRITICAL ERROR: No executable file provided!${NC}"
    echo -e "${YELLOW}💡 TIP: Open Thunar File Manager and double-click an .exe file.${NC}\n"
    read -p "Press Enter to exit..."
    exit 1
fi

# Ensure GUI Display is set for Wine
if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0
    echo -e "${GRAY}[ * ] Display variable routed to :0${NC}"
fi

FILENAME=$(basename "$EXE_FILE")
APP_NAME="${FILENAME%.*}"
INTERNAL_PATH="$EXE_FILE"
CACHE_DIR="$HOME/.danix_exe_cache"

echo -e "${GREEN}[ ✔ ] Target Acquired : ${WHITE}${BOLD}$FILENAME${NC}"

# ==========================================
# 🛠️ STEP 2: ANDROID STORAGE RESTRICTION BYPASS
# ==========================================
# Android restricts executing binaries directly from /storage/ (Downloads, SD Card)
# We copy it to the internal secure Termux space.

if [[ "$EXE_FILE" == *"/storage/"* ]]; then
    echo -e "\n${YELLOW}[ ⚙ ] Android storage execution block detected!${NC}"
    echo -e "${CYAN}[ * ] Initializing Smart Cache Bypass System...${NC}"
    
    # Auto-cleanup old cached files (Keep storage free)
    if [ -d "$CACHE_DIR" ]; then
        echo -e "${GRAY}[ * ] Cleaning previous session cache...${NC}"
        rm -rf "$CACHE_DIR"/*
    fi
    mkdir -p "$CACHE_DIR"
    
    echo -e "${CYAN}[ * ] Copying payload to secure sector (Please wait)...${NC}"
    # Copy file to internal storage
    cp "$EXE_FILE" "$CACHE_DIR/"
    
    if [ $? -eq 0 ]; then
        INTERNAL_PATH="$CACHE_DIR/$FILENAME"
        echo -e "${GREEN}[ ✔ ] Payload secured at: ${GRAY}$INTERNAL_PATH${NC}"
    else
        echo -e "${RED}[ ✘ ] Failed to copy file! Check storage space.${NC}"
        read -p "Press Enter to exit..."
        exit 1
    fi
fi

echo -e "\n${GRAY}────────────────────────────────────────────────────────────${NC}"

# ==========================================
# 📌 STEP 3: DESKTOP & MENU SHORTCUT GENERATOR
# ==========================================
echo -e "${WHITE}${BOLD}Would you like to install a permanent shortcut for this app?${NC}"
echo -e "${GRAY}(It will appear on your Desktop and Start Menu)${NC}"
read -p "$(echo -e ${CYAN}➯ Type [y/n] and press Enter: ${NC})" choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    DESKTOP_DIR="$HOME/Desktop"
    MENU_DIR="$HOME/.local/share/applications"
    
    mkdir -p "$DESKTOP_DIR" "$MENU_DIR"
    
    # Note: Nohup is used in the shortcut to prevent crashes
    cat << DESKTOP_EOF > "$DESKTOP_DIR/$APP_NAME.desktop"
[Desktop Entry]
Type=Application
Name=$APP_NAME
Exec=bash -c "export DISPLAY=:0 && env WINEDEBUG=-all nohup wine \\"$INTERNAL_PATH\\" >/dev/null 2>&1 &"
Icon=wine
Terminal=false
Categories=Game;Application;System;
DESKTOP_EOF

    chmod +x "$DESKTOP_DIR/$APP_NAME.desktop"
    
    # Sync with System App Menu
    cp "$DESKTOP_DIR/$APP_NAME.desktop" "$MENU_DIR/"
    update-desktop-database "$MENU_DIR" 2>/dev/null || true
    
    echo -e "${GREEN}[ ✔ ] Integration Complete! '${APP_NAME}' added to system.${NC}"
else
    echo -e "${GRAY}[ * ] Shortcut creation skipped. One-time execution mode.${NC}"
fi

echo -e "${GRAY}────────────────────────────────────────────────────────────${NC}\n"

# ==========================================
# 🚀 STEP 4: LAUNCHING THE ENGINE
# ==========================================
echo -e "${BLUE}${BOLD}[ ⚡ ] IGNITING WINE TRANSLATION ENGINE...${NC}"
echo -e "${GRAY}[ * ] Suppressing telemetry and background warnings...${NC}"
echo -e "${GRAY}[ * ] Booting '$APP_NAME'...${NC}\n"

# ==========================================
# THE MAGIC FIX: NOHUP & DISOWN
# This ensures Wine runs independently of this terminal window!
# ==========================================
export WINEDEBUG=-all

# Running in background with nohup to detach from the terminal process
nohup wine "$INTERNAL_PATH" > /dev/null 2>&1 & 

# Save Process ID
WINE_PID=$!

# Disown the process so it survives terminal closure
disown $WINE_PID

# Visual loading effect for the user before closing
echo -e "${CYAN}Terminal will auto-close in safely...${NC}"
for i in {3..1}; do
    printf "\rClosing in %d... " "$i"
    sleep 1
done
echo ""

# Exit cleanly. The application will continue running in the XFCE background!
exit 0
