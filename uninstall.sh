#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\033[0;31m"
echo "  ╔══════════════════════════════════════╗"
echo "  ║      🗑️  DANIX OS UNINSTALLER        ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "\033[0m"

echo "  ⚠️ WARNING: This will remove DANIX OS desktop and tools."

# Yahan /dev/tty lagane se ye curl | bash ke andar bhi seedha screen se input maangega
read -p "  Are you sure you want to proceed? (y/n): " confirm </dev/tty

if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    echo "  ⏳ Stopping all processes..."
    bash ~/stop-danixos.sh > /dev/null 2>&1
    pkill -9 -f "termux.x11" 2>/dev/null
    
    echo "  ⏳ Removing Desktop Environment..."
    export DEBIAN_FRONTEND=noninteractive
    yes | pkg remove xfce4 xfce4-terminal thunar mousepad termux-x11-nightly -y > /dev/null 2>&1
    
    echo "  ⏳ Removing Scripts and Shortcuts..."
    rm -rf ~/start-danixos.sh ~/stop-danixos.sh ~/danix-tools.sh
    rm -rf ~/.config/danixos-gpu.sh
    rm -rf ~/Desktop
    
    sed -i '/danixos-gpu.sh/d' ~/.bashrc
    
    echo "  ✅ DANIX OS successfully removed from your device!"
else
    echo "  ❌ Uninstallation cancelled."
fi
