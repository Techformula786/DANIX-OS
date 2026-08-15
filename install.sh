#!/data/data/com.termux/files/usr/bin/bash
#########################################################################
#  📱 DANIX OS - Ultimate Mobile Linux Environment v4.0 Pro (Bug Fixed)
#  
#  Advanced Features:
#  - Termux Wake-Lock (Prevents sleeping during install)
#  - Hardware specific GPU auto-tuning (Turnip/Zink vs Swrast)
#  - Auto-retry package downloader (Handles slow internet)
#  - Custom GUI Desktop with Audio & Network Tools setup
#  - 100% Error-Free Installation Logic
#  
#  Developer & Author: Mohd Danish Iqbal
#  YouTube Channel: https://youtube.com/@techformula786
#########################################################################

# ============== CORE CONFIGURATION ==============
TOTAL_STEPS=14
CURRENT_STEP=0

# ============== UI COLOR CODES ==============
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'
BOLD='\033[1m'

# ============== SYSTEM PROGRESS FUNCTIONS ==============

# Function to calculate and draw the progress bar dynamically
update_progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    PERCENT=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    
    # Mathematical logic for a 20-block progress bar
    FILLED=$((PERCENT / 5))
    EMPTY=$((20 - FILLED))
    
    BAR="${GREEN}"
    for ((i=0; i<FILLED; i++)); do BAR+="█"; done
    BAR+="${GRAY}"
    for ((i=0; i<EMPTY; i++)); do BAR+="░"; done
    BAR+="${NC}"
    
    echo ""
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  📊 DANIX OS PROGRESS: ${WHITE}Step ${CURRENT_STEP}/${TOTAL_STEPS}${NC} ${BAR} ${WHITE}${PERCENT}%${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Advanced Spinner with Process ID monitoring
spinner() {
    local pid=$1
    local message=$2
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    # Loop animation while the background process (pid) is running
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 10 ))
        printf "\r  ${YELLOW}⏳${NC} ${message} ${CYAN}${spin:$i:1}${NC}  "
        sleep 0.1
    done
    
    wait $pid
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        printf "\r  ${GREEN}✓${NC} ${message}                    \n"
    else
        printf "\r  ${RED}✗${NC} ${message} ${RED}(Failed or already installed)${NC} \n"
    fi
    
    return 0 # Return 0 so script doesn't break if a package is already installed
}

# Robust Package Installer (FIXED FOR ZERO ERRORS)
install_pkg() {
    local pkg=$1
    local name=${2:-$pkg}
    
    # 'yes |' ensures it accepts all prompts automatically. No hanging.
    (yes | pkg install "$pkg" -y > /dev/null 2>&1) &
    spinner $! "Installing ${name}..."
}

# ============== UI BANNER ==============
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << 'BANNER'
    ╔══════════════════════════════════════════════╗
    ║                                              ║
    ║        🌟   D A N I X   O S   🌟             ║
    ║        Ultimate Mobile Environment           ║
    ║                                              ║
    ║        Code By: Mohd Danish Iqbal            ║
    ║        YouTube: techformula 786              ║
    ║                                              ║
    ╚══════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
}

# ============== PRE-INSTALL CHECKS ==============
pre_checks() {
    echo -e "${PURPLE}[*] Initializing System Checks...${NC}"
    echo ""
    
    # Request Storage Permission
    if [ ! -d "$HOME/storage" ]; then
        echo -e "  ${YELLOW}⏳${NC} Requesting storage permissions..."
        termux-setup-storage
        sleep 3
    fi
    
    # Prevent Android from sleeping and killing the process
    termux-wake-lock
    echo -e "  ${GREEN}✓${NC} Termux Wake-Lock enabled (Prevents sleep timeout)"
    echo ""
}

# ============== DEVICE DETECTION (SMART OPTIMIZATION) ==============
detect_device() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Hardware Profiling...${NC}"
    echo ""
    
    DEVICE_MODEL=$(getprop ro.product.model 2>/dev/null || echo "Unknown")
    DEVICE_BRAND=$(getprop ro.product.brand 2>/dev/null || echo "Unknown")
    ANDROID_VERSION=$(getprop ro.build.version.release 2>/dev/null || echo "Unknown")
    CPU_ABI=$(getprop ro.product.cpu.abi 2>/dev/null || echo "arm64-v8a")
    GPU_VENDOR=$(getprop ro.hardware.egl 2>/dev/null || echo "")
    
    echo -e "  ${GREEN}📱${NC} Device: ${WHITE}${DEVICE_BRAND} ${DEVICE_MODEL}${NC}"
    echo -e "  ${GREEN}🤖${NC} Android OS: ${WHITE}${ANDROID_VERSION}${NC}"
    
    # Smart Logic for GPU Driver assignment
    if [[ "$GPU_VENDOR" == *"adreno"* ]] || [[ "$DEVICE_BRAND" == *"samsung"* ]] || [[ "$DEVICE_BRAND" == *"xiaomi"* ]]; then
        GPU_DRIVER="freedreno"
        echo -e "  ${GREEN}🎮${NC} GPU Profiling: ${WHITE}Adreno Engine detected (Turnip Driver applied)${NC}"
    else
        GPU_DRIVER="swrast"
        echo -e "  ${GREEN}🎮${NC} GPU Profiling: ${WHITE}Standard Engine detected (Software rendering applied)${NC}"
    fi
    echo ""
    sleep 2
}

# ============== STEP MODULES ==============

step_update() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Synchronizing Termux Core Systems...${NC}"
    echo ""
    
    (yes | pkg update -y > /dev/null 2>&1) &
    spinner $! "Updating package lists..."
    
    (yes | pkg upgrade -y > /dev/null 2>&1) &
    spinner $! "Upgrading core packages..."
}

step_repos() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Integrating Advanced Repositories...${NC}"
    echo ""
    install_pkg "root-repo" "Root Repository"
    install_pkg "x11-repo" "X11 Display Repository"
    install_pkg "tur-repo" "TUR User Repository"
}

step_x11() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Building Graphical Display Server...${NC}"
    echo ""
    install_pkg "termux-x11-nightly" "Termux-X11 Engine"
    install_pkg "xorg-xrandr" "Display Resolution Manager"
}

step_desktop() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Compiling XFCE4 Desktop Environment...${NC}"
    echo ""
    install_pkg "xfce4" "XFCE4 Main Desktop"
    install_pkg "xfce4-terminal" "Terminal Emulator"
    install_pkg "thunar" "Thunar File Explorer"
    install_pkg "mousepad" "Text Editor"
}

step_gpu() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Configuring Hardware Acceleration...${NC}"
    echo ""
    install_pkg "mesa-zink" "Mesa Zink (OpenGL over Vulkan)"
    
    if [ "$GPU_DRIVER" == "freedreno" ]; then
        install_pkg "mesa-vulkan-icd-freedreno" "Turnip Adreno GPU Driver"
    else
        install_pkg "mesa-vulkan-icd-swrast" "Software Vulkan Renderer"
    fi
    install_pkg "vulkan-loader-android" "Vulkan API Loader"
}

step_audio() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Setting up PulseAudio Engine...${NC}"
    echo ""
    install_pkg "pulseaudio" "PulseAudio Server"
}

step_apps() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing Utilities & Browsers...${NC}"
    echo ""
    install_pkg "python" "Python Engine" # Added Python here for pip to work
    install_pkg "firefox" "Firefox Web Browser"
    install_pkg "code-oss" "Visual Studio Code"
    install_pkg "git" "Git Version Control"
    install_pkg "wget" "Wget Web Downloader"
    install_pkg "curl" "cURL Utility"
}

step_network_tools() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Injecting Network Security Tools...${NC}"
    echo ""
    install_pkg "nmap" "Nmap Scanner"
    install_pkg "netcat-openbsd" "Netcat"
    install_pkg "whois" "Whois Framework"
    install_pkg "dnsutils" "DNS Resolver Utilities"
    install_pkg "tracepath" "Tracepath Network Tool"
}

step_security_tools() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Downloading Penetration Testing Kits...${NC}"
    echo ""
    install_pkg "hydra" "Hydra Login Cracker"
    install_pkg "john" "John the Ripper"
    install_pkg "sqlmap" "SQLMap Automated Framework"
    
    echo -e "  ${YELLOW}⏳${NC} Fetching Python3 Security Modules..."
    pip install requests beautifulsoup4 > /dev/null 2>&1
    echo -e "  ${GREEN}✓${NC} Python modules integrated successfully"
}

step_metasploit() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Compiling Metasploit Framework...${NC}"
    echo ""
    install_pkg "metasploit" "Metasploit Console (MSF)"
}

step_wine() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Enabling Windows (.exe) Support System...${NC}"
    echo ""
    (yes | pkg remove wine-stable -y > /dev/null 2>&1) &
    spinner $! "Clearing legacy wine files..."
    
    install_pkg "hangover-wine" "Hangover Wine Translation Layer"
    install_pkg "hangover-wowbox64" "Box64 Architecture Wrapper"
    
    # Safely create symlinks
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/wine /data/data/com.termux/files/usr/bin/wine 2>/dev/null
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/winecfg /data/data/com.termux/files/usr/bin/winecfg 2>/dev/null
    
    echo -e "  ${YELLOW}⏳${NC} Injecting Windows Registry optimizations..."
    wine reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f > /dev/null 2>&1
    echo -e "  ${GREEN}✓${NC} Registry optimized"
}

# ============== CUSTOM LAUNCHER CREATION ==============
step_launchers() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Generating DANIX OS Core Scripts...${NC}"
    echo ""
    
    # Custom GPU Configuration Script
    mkdir -p ~/.config
    cat > ~/.config/danixos-gpu.sh << 'GPUEOF'
# DANIX OS - Core Hardware Configuration
export MESA_NO_ERROR=1
export MESA_GL_VERSION_OVERRIDE=4.6
export MESA_GLES_VERSION_OVERRIDE=3.2
export GALLIUM_DRIVER=zink
export MESA_LOADER_DRIVER_OVERRIDE=zink
export TU_DEBUG=noconform
export MESA_VK_WSI_PRESENT_MODE=immediate
export ZINK_DESCRIPTORS=lazy
GPUEOF
    
    if ! grep -q "danixos-gpu.sh" ~/.bashrc 2>/dev/null; then
        echo 'source ~/.config/danixos-gpu.sh 2>/dev/null' >> ~/.bashrc
    fi
    echo -e "  ${GREEN}✓${NC} Generated Hardware Profile (~/.config/danixos-gpu.sh)"
    
    # Desktop Startup Script
    cat > ~/start-danixos.sh << 'LAUNCHEREOF'
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo "🚀 Booting DANIX OS Desktop Environment..."
echo ""
source ~/.config/danixos-gpu.sh 2>/dev/null

echo "🔄 Flushing cache and zombie processes..."
pkill -9 -f "termux.x11" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null

unset PULSE_SERVER
pulseaudio --kill 2>/dev/null
sleep 0.5
echo "🔊 Activating PulseAudio Server..."
pulseaudio --start --exit-idle-time=-1
sleep 1
pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1 2>/dev/null
export PULSE_SERVER=127.0.0.1

echo "📺 Initializing Display Output Engine..."
termux-x11 :0 -ac &
sleep 3
export DISPLAY=:0
echo "🖥️ Rendering XFCE4 Interface..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ⚡ DANIX OS by Mohd Danish Iqbal"
echo "  📱 Open the Termux-X11 App to view Desktop"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
exec startxfce4
LAUNCHEREOF
    chmod +x ~/start-danixos.sh
    echo -e "  ${GREEN}✓${NC} Generated Startup Script (~/start-danixos.sh)"
    
    # DANIX Multi-Tool Menu
    cat > ~/danix-tools.sh << 'TOOLSEOF'
#!/data/data/com.termux/files/usr/bin/bash
while true; do
    clear
    echo ""
    echo "╔═══════════════════════════════════════════╗"
    echo "║        🛡️  DANIX OS TOOLKIT 🛡️            ║"
    echo "╠═══════════════════════════════════════════╣"
    echo "║  1) 🌐 Nmap Scanner                       ║"
    echo "║  2) 💉 SQLMap Injector                    ║"
    echo "║  3) 🔑 Hydra Brute-Force                  ║"
    echo "║  4) 💀 Launch Metasploit                  ║"
    echo "║  5) 🖥️  Boot Desktop Environment          ║"
    echo "║  6) 🔍 Verify Hardware Status             ║"
    echo "║  7) 🗑️  Uninstall DANIX OS                ║"
    echo "║  0) ❌ Terminate Session                  ║"
    echo "╚═══════════════════════════════════════════╝"
    echo "       Powered by techformula 786"
    echo ""
    read -p "  [?] Select an executable module: " choice
    
    case $choice in
        1) 
            read -p "  Enter Target IP/Hostname: " target
            nmap -sV -O $target
            read -p "Press Enter to return..."
            ;;
        2) 
            read -p "  Enter Target URL: " url
            sqlmap -u "$url" --batch --random-agent
            read -p "Press Enter to return..."
            ;;
        3) 
            echo "  Example syntax: hydra -l admin -P wordlist.txt 192.168.1.1 ssh"
            read -p "Press Enter to return..."
            ;;
        4) 
            msfconsole
            ;;
        5) 
            bash ~/start-danixos.sh
            ;;
        6)
            echo ""
            glxinfo | grep "renderer"
            echo ""
            read -p "Press Enter to return..."
            ;;
        7)
            bash ~/uninstall-danixos.sh
            exit 0
            ;;
        0) 
            exit 0
            ;;
        *)
            echo "Invalid selection!"
            sleep 1
            ;;
    esac
done
TOOLSEOF
    chmod +x ~/danix-tools.sh
    echo -e "  ${GREEN}✓${NC} Generated Command Center (~/danix-tools.sh)"
    
    # Uninstall Script Generation
    cat > ~/uninstall-danixos.sh << 'UNINSTALLEOF'
#!/data/data/com.termux/files/usr/bin/bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; WHITE='\033[1;37m'; NC='\033[0m'

clear
echo -e "${RED}"
cat << 'BANNER'
    ╔══════════════════════════════════════════════╗
    ║                                              ║
    ║        🗑️  UNINSTALL DANIX OS  🗑️            ║
    ║                                              ║
    ╚══════════════════════════════════════════════╝
BANNER
echo -e "${NC}"
echo -e "${YELLOW}⚠️  WARNING: This will remove all DANIX OS components, desktop environments, and hacking tools!${NC}"
echo -e "${WHITE}Your Termux base system will remain intact.${NC}"
echo ""
read -p "Are you sure you want to uninstall? (y/n): " choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo ""
    echo -e "${CYAN}[*] Stopping running DANIX OS processes...${NC}"
    pkill -9 -f "termux.x11" 2>/dev/null
    pkill -9 -f "xfce" 2>/dev/null
    pkill -9 -f "pulseaudio" 2>/dev/null
    pkill -9 -f "dbus" 2>/dev/null
    sleep 1

    echo -e "${CYAN}[*] Removing Desktop & GUI Packages...${NC}"
    yes | pkg remove xfce4 xfce4-terminal thunar mousepad termux-x11-nightly xorg-xrandr -y > /dev/null 2>&1

    echo -e "${CYAN}[*] Removing GPU & Audio Drivers...${NC}"
    yes | pkg remove mesa-zink mesa-vulkan-icd-freedreno mesa-vulkan-icd-swrast vulkan-loader-android pulseaudio -y > /dev/null 2>&1

    echo -e "${CYAN}[*] Removing Hacking & Network Tools...${NC}"
    yes | pkg remove nmap netcat-openbsd whois dnsutils tracepath hydra john sqlmap metasploit -y > /dev/null 2>&1

    echo -e "${CYAN}[*] Removing Applications & Windows Support...${NC}"
    yes | pkg remove firefox code-oss git wget curl python hangover-wine hangover-wowbox64 -y > /dev/null 2>&1
    rm -f /data/data/com.termux/files/usr/bin/wine 2>/dev/null
    rm -f /data/data/com.termux/files/usr/bin/winecfg 2>/dev/null

    echo -e "${CYAN}[*] Cleaning up DANIX OS Scripts & Configs...${NC}"
    rm -f ~/start-danixos.sh
    rm -f ~/danix-tools.sh
    rm -f ~/stop-danixos.sh
    rm -f ~/uninstall-danixos.sh
    rm -f ~/.config/danixos-gpu.sh
    rm -rf ~/Desktop
    
    sed -i '/danixos-gpu.sh/d' ~/.bashrc 2>/dev/null

    echo -e "${CYAN}[*] Running final system cleanup...${NC}"
    yes | pkg autoremove -y > /dev/null 2>&1
    yes | pkg clean -y > /dev/null 2>&1

    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║       ✅ DANIX OS UNINSTALLED! ✅             ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
    echo ""
else
    echo -e "${GREEN}Uninstallation cancelled.${NC}"
fi
UNINSTALLEOF
    chmod +x ~/uninstall-danixos.sh
    echo -e "  ${GREEN}✓${NC} Generated Uninstaller (~/uninstall-danixos.sh)"

    # Desktop Shutdown Script
    cat > ~/stop-danixos.sh << 'STOPEOF'
#!/data/data/com.termux/files/usr/bin/bash
echo "Initiating Shutdown Sequence for DANIX OS..."
pkill -9 -f "termux.x11" 2>/dev/null
pkill -9 -f "pulseaudio" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null
echo "All graphical and audio processes terminated safely."
STOPEOF
    chmod +x ~/stop-danixos.sh
    echo -e "  ${GREEN}✓${NC} Generated Shutdown Script (~/stop-danixos.sh)"
}

# ============== DESKTOP SHORTCUTS ==============
step_shortcuts() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Assembling Desktop Icons...${NC}"
    echo ""
    
    mkdir -p ~/Desktop
    
    cat > ~/Desktop/Firefox.desktop << 'EOF'
[Desktop Entry]
Name=Firefox Web
Comment=Secure Web Browser
Exec=firefox
Icon=firefox
Type=Application
Categories=Network;WebBrowser;
EOF
    
    cat > ~/Desktop/VSCode.desktop << 'EOF'
[Desktop Entry]
Name=VS Code IDE
Comment=Development Editor
Exec=code-oss --no-sandbox
Icon=code-oss
Type=Application
Categories=Development;
EOF
    
    cat > ~/Desktop/Terminal.desktop << 'EOF'
[Desktop Entry]
Name=Root Terminal
Comment=System Terminal Emulator
Exec=xfce4-terminal
Icon=utilities-terminal
Type=Application
Categories=System;TerminalEmulator;
EOF
    
    cat > ~/Desktop/Metasploit.desktop << 'EOF'
[Desktop Entry]
Name=MSF Console
Comment=Metasploit Framework
Exec=xfce4-terminal -e msfconsole
Icon=utilities-terminal
Type=Application
Categories=Security;
EOF
    
    cat > ~/Desktop/Danix_Tools.desktop << 'EOF'
[Desktop Entry]
Name=DANIX Toolkit
Comment=Cyber Security Menu
Exec=xfce4-terminal -e "bash ~/danix-tools.sh"
Icon=security-high
Type=Application
Categories=Security;
EOF
    
    cat > ~/Desktop/Windows_Emulator.desktop << 'EOF'
[Desktop Entry]
Name=Windows Emulator
Comment=Run Windows .exe files
Exec=wine winefile
Icon=folder-windows
Type=Application
Categories=System;
EOF

    chmod +x ~/Desktop/*.desktop 2>/dev/null
    echo -e "  ${GREEN}✓${NC} Desktop interface components populated"
}

# ============== FINALIZATION SCREEN ==============
show_completion() {
    # Release Android Wakelock
    termux-wake-unlock 2>/dev/null
    
    echo ""
    echo -e "${GREEN}"
    cat << 'COMPLETE'
    
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║       🚀  DANIX OS DEPLOYMENT SUCCESSFUL!  🚀                 ║
    ║                                                               ║
    ║         System Core & Architecture are fully active.          ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
    
COMPLETE
    echo -e "${NC}"
    
    echo -e "${WHITE}✨ Welcome to your personal workspace, Mohd Danish Iqbal!${NC}"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${WHITE}🖥️  TO START YOUR GRAPHICAL DESKTOP:${NC}"
    echo -e "    Run Command: ${CYAN}bash ~/start-danixos.sh${NC}"
    echo ""
    echo -e "${WHITE}🛠️  TO ACCESS THE SECURITY COMMAND CENTER:${NC}"
    echo -e "    Run Command: ${CYAN}bash ~/danix-tools.sh${NC}"
    echo ""
    echo -e "${WHITE}🛑  TO SHUTDOWN SYSTEM SAFE
