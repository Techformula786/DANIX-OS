#!/data/data/com.termux/files/usr/bin/bash
#########################################################################
#  🗑️ DANIX OS - Ultimate Uninstaller Script
#  
#  This script will safely remove all DANIX OS components, GUI desktops,
#  hacking tools, and configurations, reverting Termux to its default state.
#  
#  Developer & Author: Mohd Danish Iqbal
#  YouTube Channel: https://youtube.com/@techformula786
#########################################################################

# ============== UI COLOR CODES ==============
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# ============== BANNER ==============
show_banner() {
    clear
    echo -e "${RED}"
    cat << 'BANNER'
    ╔══════════════════════════════════════════════╗
    ║                                              ║
    ║        🗑️  UNINSTALL DANIX OS  🗑️            ║
    ║                                              ║
    ║        Code By: Mohd Danish Iqbal            ║
    ║        YouTube: techformula 786              ║
    ║                                              ║
    ╚══════════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
}

# ============== MAIN EXECUTION ==============
main() {
    show_banner
    
    echo -e "${YELLOW}⚠️  WARNING: This will remove all DANIX OS components, desktop environments, hacking tools, and Windows (Wine) support!${NC}"
    echo -e "${WHITE}Your Termux base system & internet packages will remain intact.${NC}"
    echo ""
    read -p "Are you sure you want to completely uninstall DANIX OS? (y/n): " choice
    
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        echo -e "${GREEN}Uninstallation cancelled. DANIX OS is safe.${NC}"
        exit 0
    fi

    echo ""
    echo -e "${CYAN}[*] Stopping all running DANIX OS processes...${NC}"
    pkill -9 -f "termux.x11" 2>/dev/null
    pkill -9 -f "xfce" 2>/dev/null
    pkill -9 -f "pulseaudio" 2>/dev/null
    pkill -9 -f "dbus" 2>/dev/null
    pkill -9 -f "metasploit" 2>/dev/null
    sleep 1

    echo -e "${CYAN}[*] Removing Desktop & GUI Packages...${NC}"
    yes | pkg remove --purge xfce4 xfce4-terminal thunar mousepad -y > /dev/null 2>&1
    yes | pkg remove --purge termux-x11-nightly xorg-xrandr -y > /dev/null 2>&1

    echo -e "${CYAN}[*] Removing GPU & Audio Drivers...${NC}"
    yes | pkg remove --purge mesa-zink mesa-vulkan-icd-freedreno mesa-vulkan-icd-swrast vulkan-loader-android -y > /dev/null 2>&1
    yes | pkg remove --purge pulseaudio -y > /dev/null 2>&1

    echo -e "${CYAN}[*] Removing Hacking & Network Tools...${NC}"
    yes | pkg remove --purge nmap netcat-openbsd whois dnsutils tracepath hydra john sqlmap metasploit -y > /dev/null 2>&1

    echo -e "${CYAN}[*] Removing Applications & Windows Support (Wine)...${NC}"
    yes | pkg remove --purge firefox code-oss git wget curl python hangover-wine hangover-wowbox64 -y > /dev/null 2>&1
    rm -f /data/data/com.termux/files/usr/bin/wine 2>/dev/null
    rm -f /data/data/com.termux/files/usr/bin/winecfg 2>/dev/null

    echo -e "${CYAN}[*] Cleaning up DANIX OS Scripts, Shortcuts & Configs...${NC}"
    rm -f ~/start-danixos.sh
    rm -f ~/danix-tools.sh
    rm -f ~/stop-danixos.sh
    rm -f ~/uninstall-danixos.sh
    rm -f ~/.config/danixos-gpu.sh
    rm -rf ~/Desktop
    
    # Remove bashrc entry so it doesn't cause errors later
    sed -i '/danixos-gpu.sh/d' ~/.bashrc 2>/dev/null

    echo -e "${CYAN}[*] Running final system cleanup (Autoremove)...${NC}"
    yes | pkg autoremove -y > /dev/null 2>&1
    yes | pkg clean -y > /dev/null 2>&1

    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                              ║${NC}"
    echo -e "${GREEN}║       ✅ DANIX OS UNINSTALLED! ✅             ║${NC}"
    echo -e "${GREEN}║                                              ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${WHITE}Thank you for using DANIX OS. Termux is now back to its default state.${NC}"
    echo -e "${CYAN}Subscribe: https://youtube.com/@techformula786${NC}"
    echo ""
}

# Execute main function
main
