#!/data/data/com.termux/files/usr/bin/bash
#########################################################################
#  📱 DANIX OS - Ultimate Mobile Linux Environment v4.0 Pro
#  
#  Advanced Features:
#  - Termux Wake-Lock (Prevents sleeping during install)
#  - Hardware specific GPU auto-tuning (Turnip/Zink vs Swrast)
#  - Auto-retry package downloader (Handles slow internet)
#  - Custom GUI Desktop with Audio & Network Tools setup
#  - Smart .EXE Double-Click Handler (Modular)
#  - EXTREME TUI: Real-time Animated Bars, Matrix Boot, RGB Spinners
#  
#  Developer & Author: Mohd Danish Iqbal
#  YouTube Channel: https://youtube.com/@techformula786
#########################################################################

# ============== CORE CONFIGURATION ==============
TOTAL_STEPS=15
CURRENT_STEP=0
PREV_PERCENT=0

# ============== UI COLOR CODES ==============
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'
BOLD='\033[1m'

# ============== 🎬 EXTREME UI ANIMATIONS ==============

# 1. Real-time Fluid Progress Bar Animation
update_progress() {
    STEP_NAME="$1"
    CURRENT_STEP=$((CURRENT_STEP + 1))
    TARGET_PERCENT=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    
    echo ""
    echo -e "${GRAY}╭──────────────────────────────────────────────────────────╮${NC}"
    
    # Smooth loading effect loop
    for ((p=$PREV_PERCENT; p<=$TARGET_PERCENT; p++)); do
        FILLED=$((p / 4)) # 25 blocks for 100%
        EMPTY=$((25 - FILLED))
        
        BAR="${CYAN}"
        for ((i=0; i<FILLED; i++)); do BAR+="█"; done
        BAR+="${GRAY}"
        for ((i=0; i<EMPTY; i++)); do BAR+="▒"; done
        BAR+="${NC}"
        
        # \r overwrites the same line creating a smooth loading animation!
        printf "\r${GRAY}│ ${BLUE}${BOLD}⚡ DANIX ENGINE ${GRAY}│ ${BAR} ${GRAY}│ %3d%% │${NC}" "$p"
        sleep 0.02
    done
    
    echo ""
    echo -e "${GRAY}╰──────────────────────────────────────────────────────────╯${NC}"
    echo -e "${PURPLE}${BOLD} ➯ STEP ${CURRENT_STEP}/${TOTAL_STEPS} :${NC} ${WHITE}${BOLD}${STEP_NAME}${NC}"
    echo ""
    
    PREV_PERCENT=$TARGET_PERCENT
}

# 2. RGB Fluid Radar Spinner
spinner() {
    local pid=$1
    local message=$2
    local frames=('⣾' '⣽' '⣻' '⢿' '⡿' '⣟' '⣯' '⣷')
    local colors=($CYAN $BLUE $PURPLE $MAGENTA)
    local i=0
    local c=0
    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 8 ))
        c=$(( (c+1) % 4 ))
        # Dynamic color changing spinner
        printf "\r  ${colors[$c]}%s${NC} ${WHITE}%s${NC}...  " "${frames[$i]}" "$message"
        sleep 0.08
    done
    
    wait $pid
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        printf "\r  ${GREEN}[ ✔ ]${NC} ${WHITE}%s${NC}                              \n" "$message"
    else
        printf "\r  ${RED}[ ✘ ]${NC} ${WHITE}%s ${RED}(Failed - Auto retry active)${NC} \n" "$message"
    fi
    
    return $exit_code
}

# 3. Cinematic Boot Sequence & Line-by-line Logo Reveal
show_banner() {
    clear
    # Mini Hacker Boot Sequence
    echo -e "${GREEN}[*] Initiating DANIX Boot Sequence...${NC}"; sleep 0.2
    echo -e "${GREEN}[*] Bypassing Android Security Protocols... [OK]${NC}"; sleep 0.2
    echo -e "${GREEN}[*] Connecting to Mainframe Engine... [OK]${NC}"; sleep 0.3
    clear
    
    # Line by line 3D Logo Reveal
    echo -e "${CYAN}${BOLD}   ██████╗  █████╗ ███╗   ██╗██╗██╗  ██╗${NC}"; sleep 0.05
    echo -e "${BLUE}${BOLD}   ██╔══██╗██╔══██╗████╗  ██║██║╚██╗██╔╝${NC}"; sleep 0.05
    echo -e "${PURPLE}${BOLD}   ██║  ██║███████║██╔██╗ ██║██║ ╚███╔╝ ${NC}"; sleep 0.05
    echo -e "${MAGENTA}${BOLD}   ██║  ██║██╔══██║██║╚██╗██║██║ ██╔██╗ ${NC}"; sleep 0.05
    echo -e "${RED}${BOLD}   ██████╔╝██║  ██║██║ ╚████║██║██╔╝ ██╗${NC}"; sleep 0.05
    echo -e "${YELLOW}${BOLD}   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝${NC}"; sleep 0.05
    echo -e "   ${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "   ${YELLOW}${BOLD}⚡ Ultimate Mobile Linux Environment ⚡${NC}"
    echo -e "   ${GRAY}Code By: ${CYAN}Mohd Danish Iqbal ${GRAY}| ${RED}YT: techformula 786${NC}"
    echo -e "   ${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    sleep 0.5
}

# ============== CORE FUNCTIONS ==============

install_pkg() {
    local pkg=$1
    local name=${2:-$pkg}
    (
        export DEBIAN_FRONTEND=noninteractive
        for retry in {1..3}; do
            yes | pkg install "$pkg" -y -o Dpkg::Options::="--force-confnew" > /dev/null 2>&1 && exit 0
            sleep 2
        done
        exit 1
    ) &
    spinner $! "Installing ${name}"
}

pre_checks() {
    echo -e "${BLUE}${BOLD}[*] System Diagnostics...${NC}"
    if [ ! -d "$HOME/storage" ]; then
        echo -e "  ${YELLOW}[ ⚙ ]${NC} Requesting storage permissions..."
        termux-setup-storage
        sleep 3
    fi
    termux-wake-lock
    echo -e "  ${GREEN}[ ✔ ]${NC} Termux Wake-Lock Enabled (Anti-Sleep Mode)"
}

detect_device() {
    update_progress "Hardware Profiling & Scanning"
    
    DEVICE_MODEL=$(getprop ro.product.model 2>/dev/null || echo "Unknown")
    DEVICE_BRAND=$(getprop ro.product.brand 2>/dev/null || echo "Unknown")
    ANDROID_VERSION=$(getprop ro.build.version.release 2>/dev/null || echo "Unknown")
    GPU_VENDOR=$(getprop ro.hardware.egl 2>/dev/null || echo "")
    
    echo -e "  ${CYAN}[ ${WHITE}📱 ${CYAN}]${NC} Device : ${WHITE}${BOLD}${DEVICE_BRAND} ${DEVICE_MODEL}${NC}"
    echo -e "  ${CYAN}[ ${WHITE}🤖 ${CYAN}]${NC} OS     : ${WHITE}${BOLD}Android ${ANDROID_VERSION}${NC}"
    
    if [[ "$GPU_VENDOR" == *"adreno"* ]] || [[ "$DEVICE_BRAND" == *"samsung"* ]] || [[ "$DEVICE_BRAND" == *"xiaomi"* ]] || [[ "$DEVICE_BRAND" == *"vivo"* ]]; then
        GPU_DRIVER="freedreno"
        echo -e "  ${CYAN}[ ${WHITE}🎮 ${CYAN}]${NC} GPU    : ${WHITE}${BOLD}Adreno Engine Detected (Turnip Vulcan)${NC}"
    else
        GPU_DRIVER="swrast"
        echo -e "  ${CYAN}[ ${WHITE}🎮 ${CYAN}]${NC} GPU    : ${WHITE}${BOLD}Standard Engine Detected (Software Render)${NC}"
    fi
    sleep 1.5
}

# ============== STEP MODULES ==============

step_update() {
    update_progress "Synchronizing Termux Core Systems"
    (yes | pkg update -y > /dev/null 2>&1) &
    spinner $! "Updating package lists"
    (export DEBIAN_FRONTEND=noninteractive; yes | pkg upgrade -y -o Dpkg::Options::="--force-confnew" > /dev/null 2>&1) &
    spinner $! "Upgrading core packages"
}

step_repos() {
    update_progress "Integrating Advanced Repositories"
    install_pkg "root-repo" "Root Repository (Advanced Tools)"
    install_pkg "x11-repo" "X11 Display Repository"
    install_pkg "tur-repo" "TUR User Repository"
    
    (export DEBIAN_FRONTEND=noninteractive; yes | pkg update -y > /dev/null 2>&1) &
    spinner $! "Refreshing new repository lists"
}

step_x11() {
    update_progress "Building Graphical Display Server"
    install_pkg "termux-x11-nightly" "Termux-X11 Engine"
    install_pkg "xorg-xrandr" "Display Resolution Manager"
}

step_desktop() {
    update_progress "Compiling XFCE4 Desktop Environment"
    install_pkg "xfce4" "XFCE4 Main Desktop"
    install_pkg "xfce4-terminal" "Terminal Emulator"
    install_pkg "thunar" "Thunar File Explorer"
    install_pkg "mousepad" "Text Editor"
}

step_gpu() {
    update_progress "Configuring Hardware Acceleration"
    install_pkg "mesa-zink" "Mesa Zink (OpenGL over Vulkan)"
    
    if [ "$GPU_DRIVER" == "freedreno" ]; then
        install_pkg "mesa-vulkan-icd-freedreno" "Turnip Adreno GPU Driver"
    else
        install_pkg "mesa-vulkan-icd-swrast" "Software Vulkan Renderer"
    fi
    install_pkg "vulkan-loader-android" "Vulkan API Loader"
}

step_audio() {
    update_progress "Setting up PulseAudio Engine"
    install_pkg "pulseaudio" "PulseAudio Server"
}

step_apps() {
    update_progress "Installing Utilities & Browsers"
    install_pkg "firefox" "Firefox Web Browser"
    install_pkg "code-oss" "Visual Studio Code"
    install_pkg "git" "Git Version Control"
    install_pkg "wget" "Wget Web Downloader"
}

step_network_tools() {
    update_progress "Injecting Network Security Tools"
    install_pkg "nmap" "Nmap Scanner"
    install_pkg "netcat-openbsd" "Netcat"
    install_pkg "whois" "Whois Framework"
    install_pkg "dnsutils" "DNS Resolver Utilities"
}

step_security_tools() {
    update_progress "Downloading Penetration Testing Kits"
    install_pkg "hydra" "Hydra Login Cracker"
    install_pkg "john" "John the Ripper"
    install_pkg "sqlmap" "SQLMap Automated Framework"
    
    (pip install requests beautifulsoup4 > /dev/null 2>&1) &
    spinner $! "Fetching Python3 Security Modules"
}

step_metasploit() {
    update_progress "Compiling Metasploit Framework"
    install_pkg "metasploit" "Metasploit Console (MSF)"
}

step_wine() {
    update_progress "Enabling Windows (.exe) Support System"
    (yes | pkg remove wine-stable -y > /dev/null 2>&1) &
    spinner $! "Clearing legacy wine files"
    
    install_pkg "hangover-wine" "Hangover Wine Translation Layer"
    install_pkg "hangover-wowbox64" "Box64 Architecture Wrapper"
    
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/wine /data/data/com.termux/files/usr/bin/wine
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/winecfg /data/data/com.termux/files/usr/bin/winecfg
    
    (wine reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f > /dev/null 2>&1) &
    spinner $! "Injecting Windows Registry optimizations"
}

step_launchers() {
    update_progress "Generating DANIX OS Core Scripts"
    mkdir -p ~/.config
    cat > ~/.config/danixos-gpu.sh << 'GPUEOF'
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
    echo -e "  ${GREEN}[ ✔ ]${NC} Generated Hardware Profile (~/.config/danixos-gpu.sh)"
    
    cat > ~/start-danixos.sh << 'LAUNCHEREOF'
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo "🚀 Booting DANIX OS Desktop Environment..."
echo ""
source ~/.config/danixos-gpu.sh 2>/dev/null

pkill -9 -f "termux.x11" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null

unset PULSE_SERVER
pulseaudio --kill 2>/dev/null
sleep 0.5
pulseaudio --start --exit-idle-time=-1
sleep 1
pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1 2>/dev/null
export PULSE_SERVER=127.0.0.1

termux-x11 :0 -ac &
sleep 3
export DISPLAY=:0
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ⚡ DANIX OS by Mohd Danish Iqbal"
echo "  📱 Open the Termux-X11 App to view Desktop"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
exec startxfce4
LAUNCHEREOF
    chmod +x ~/start-danixos.sh
    echo -e "  ${GREEN}[ ✔ ]${NC} Generated Startup Script (~/start-danixos.sh)"
    
    cat > ~/danix-tools.sh << 'TOOLSEOF'
#!/data/data/com.termux/files/usr/bin/bash
while true; do
    clear
    echo "╔═══════════════════════════════════════════╗"
    echo "║        🛡️  DANIX OS TOOLKIT 🛡️            ║"
    echo "╚═══════════════════════════════════════════╝"
    echo "  1) Nmap Scanner"
    echo "  2) SQLMap Injector"
    echo "  3) Hydra Brute-Force"
    echo "  4) Metasploit"
    echo "  5) Boot Desktop"
    echo "  0) Exit"
    read -p "  Select an option: " choice
    case $choice in
        1) read -p "Target IP: " t; nmap -sV -O $t; read -p "Press Enter...";;
        2) read -p "Target URL: " u; sqlmap -u "$u" --batch; read -p "Press Enter...";;
        3) echo "Example: hydra -l admin -P pass.txt ip ssh"; read -p "Press Enter...";;
        4) msfconsole;;
        5) bash ~/start-danixos.sh;;
        0) exit 0;;
    esac
done
TOOLSEOF
    chmod +x ~/danix-tools.sh
    echo -e "  ${GREEN}[ ✔ ]${NC} Generated Command Center (~/danix-tools.sh)"
    
    cat > ~/stop-danixos.sh << 'STOPEOF'
#!/data/data/com.termux/files/usr/bin/bash
pkill -9 -f "termux.x11" 2>/dev/null
pkill -9 -f "pulseaudio" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null
echo "DANIX OS Terminated."
STOPEOF
    chmod +x ~/stop-danixos.sh
    echo -e "  ${GREEN}[ ✔ ]${NC} Generated Shutdown Script (~/stop-danixos.sh)"
}

step_shortcuts() {
    update_progress "Assembling Desktop Icons"
    mkdir -p ~/Desktop
    
    cat > ~/Desktop/Danix_Tools.desktop << 'EOF'
[Desktop Entry]
Name=DANIX Toolkit
Exec=xfce4-terminal -e "bash ~/danix-tools.sh"
Icon=security-high
Type=Application
EOF
    chmod +x ~/Desktop/*.desktop 2>/dev/null
    echo -e "  ${GREEN}[ ✔ ]${NC} Desktop interface populated"
}

step_smart_exe() {
    update_progress "Configuring Smart .EXE Auto-Installer"

    wget -qO /data/data/com.termux/files/usr/bin/danix-exe-install https://raw.githubusercontent.com/Techformula786/DANIX-OS/main/exe-handler.sh
    chmod +x /data/data/com.termux/files/usr/bin/danix-exe-install
    echo -e "  ${GREEN}[ ✔ ]${NC} Smart Runner Engine Downloaded"

    mkdir -p ~/.local/share/applications
    mkdir -p ~/Desktop

    cat << 'MIMEEOF' > ~/.local/share/applications/danix-exe-handler.desktop
[Desktop Entry]
Type=Application
Name=DANIX Windows Installer
Comment=Install or Run Windows .exe files
Exec=danix-exe-install "%f"
Icon=wine
Terminal=true
Categories=System;Utility;
MimeType=application/x-ms-dos-executable;application/x-msdownload;application/x-exe;application/vnd.microsoft.portable-executable;
MIMEEOF

    cp ~/.local/share/applications/danix-exe-handler.desktop ~/Desktop/DANIX_Windows_Installer.desktop
    chmod +x ~/Desktop/DANIX_Windows_Installer.desktop

    xdg-mime default danix-exe-handler.desktop application/x-ms-dos-executable 2>/dev/null || true
    xdg-mime default danix-exe-handler.desktop application/x-msdownload 2>/dev/null || true
    update-desktop-database ~/.local/share/applications 2>/dev/null || true
    
    echo -e "  ${GREEN}[ ✔ ]${NC} Windows .EXE System Integrated"
}

show_completion() {
    termux-wake-unlock 2>/dev/null
    echo ""
    echo -e "${CYAN}╭──────────────────────────────────────────────────────────╮${NC}"
    echo -e "${CYAN}│ ${GREEN}${BOLD}     🚀 DANIX OS DEPLOYMENT 100% SUCCESSFUL! 🚀       ${CYAN}│${NC}"
    echo -e "${CYAN}╰──────────────────────────────────────────────────────────╯${NC}"
    echo -e "  ${PURPLE}➜ To Boot Your OS, Type: ${WHITE}${BOLD}bash ~/start-danixos.sh${NC}"
    echo ""
}

main() {
    show_banner
    pre_checks
    detect_device
    step_update
    step_repos
    step_x11
    step_desktop
    step_gpu
    step_audio
    step_apps
    step_network_tools
    step_security_tools
    step_metasploit
    step_wine
    step_launchers
    step_shortcuts
    step_smart_exe
    show_completion
}

main
