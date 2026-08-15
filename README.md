# DANIX-OS
DANIX OS: The ultimate automated script to install a full Linux Desktop with GPU acceleration and hacking tools on Android without root.

<div align="center">

<img src="https://img.shields.io/badge/DANIX_OS-v4.0_Pro-blue?style=for-the-badge&logo=linux&color=00e5ff" alt="DANIX OS">
<img src="https://img.shields.io/badge/Architecture-ARM64%20%7C%20x86-orange?style=for-the-badge&logo=arm&color=ff6d00">
<img src="https://img.shields.io/badge/Root_Status-Zero_Root_Required-brightgreen?style=for-the-badge&logo=android&color=00e676">
<img src="https://img.shields.io/badge/Maintained_By-Mohd_Danish_Iqbal-purple?style=for-the-badge">

<br><br>
<img src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Linux-Dark.svg" width="60"> 
<img src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Bash-Dark.svg" width="60"> 
<img src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Python-Dark.svg" width="60">
<img src="https://raw.githubusercontent.com/tandpfun/skill-icons/main/icons/Kali-Dark.svg" width="60">
<br><br>

# 🌌 DANIX OS 🌌
**The Ultimate Hardware-Accelerated Mobile Linux & Security Subsystem**

> *"Code ki duniya mein ek naya aagaaz kiya hai, Termux ke andhere mein DANIX ka noor bhar diya hai."*  
> DANIX OS is not just a script; it is a paradigm shift in mobile computing. Transform your everyday smartphone into a full-fledged, graphical Penetration Testing & Development workstation.

---
</div>

## 📑 Table of Contents
1. [The Developer's Vision](#-the-developers-vision)
2. [System Architecture & Engine](#-system-architecture--engine)
3. [Pro Features & Hardware Optimization](#-pro-features--hardware-optimization)
4. [The Tactical Arsenal (Included Tools)](#-the-tactical-arsenal-included-tools)
5. [System Prerequisites](#-system-prerequisites)
6. [1-Click Deployment Guide](#-1-click-deployment-guide)
7. [Global Master Commands](#-global-master-commands)
8. [Troubleshooting & FAQ](#-troubleshooting--faq)
9. [Legal & Ethical Disclaimer](#-legal--ethical-disclaimer)

---

## 📖 The Developer's Vision

Most mobile Linux scripts fail because they rely on outdated software rendering, bloated package installations, and unstable background processes. **DANIX OS** was engineered from the ground up by **Mohd Danish Iqbal** to solve these exact problems. 

Integrating UI/UX principles with deep bash scripting, DANIX OS utilizes a modular, auto-recovering installer. It brings true desktop-grade computing to your pocket, complete with automated Windows (.exe) translation layers and native GPU driver injections. 

---

## 🏗️ System Architecture & Engine

How does DANIX OS run a full PC OS on Android without root? It operates on a sophisticated 5-layer stack:

1. **Host Layer (Android):** Utilizes standard Android Kernel resources.
2. **Translation Layer (Termux + PRoot):** Emulates a Linux file system hierarchy without triggering SELinux root blocks.
3. **Hardware Abstraction (Mesa/Turnip):** Bypasses CPU rendering by directly interacting with the Adreno/Mali GPU via Vulkan APIs.
4. **Desktop Environment (XFCE4):** A highly customized, resource-efficient graphical interface.
5. **Display Server (Termux-X11):** Renders the Linux GUI natively on the Android display at high refresh rates.

---

## 💎 Pro Features & Hardware Optimization

### ⚙️ 1. Intelligent GPU Profiling (Smart Drivers)
DANIX OS actively queries your Android's `build.prop` to identify your System-on-Chip (SoC).
- **Snapdragon (Adreno):** Injects `freedreno` Turnip/Zink Vulkan drivers. Result: PC-like 60 FPS UI.
- **Exynos/MediaTek:** Applies `swrast` software fallback optimized for low thermal output, preventing device crashes.

### 🛡️ 2. Termux Wake-Lock Integration
Long installations crash when Android enters Doze Mode (screen off). DANIX OS forces a Wake-Lock on the CPU, ensuring your 20-minute installation completes flawlessly, even if you lock your device.

### 🔄 3. Adaptive Auto-Retry & Mirror Logic
The DANIX deployment engine features a 3-tier recovery loop. If a Termux mirror is down or your internet fluctuates, the system automatically pauses, switches mirrors, and retries the download. Zero interrupted installations.

### 🪟 4. Seamless Windows Execution (x86 on ARM)
Execute Windows `.exe` tools. DANIX OS deploys a pre-configured **Hangover Wine** & **Box64** architecture. We also inject specific Windows Registry (`regedit`) tweaks to enable font-smoothing for a native look.

### 🔊 5. Native TCP Audio Routing
Unlike other setups that are completely silent, DANIX OS configures a `PulseAudio` TCP server bridging the Linux environment directly to your Android speakers.

---

## 🧰 The Tactical Arsenal (Included Tools)

DANIX OS is a ready-to-use weapon for developers and security analysts. 

<details>
<summary><b> 💻 Development & Workspace Suite (Click to Expand)</b></summary>

*   **GUI & Management:** XFCE4 Desktop, Thunar File Manager, XFCE Terminal
*   **Web Ecosystem:** Mozilla Firefox (Full Desktop Engine)
*   **Coding & Compilation:** Visual Studio Code (Code-OSS), Python 3.x, pip
*   **Version Control & Fetching:** Git, cURL, Wget
</details>

<details>
<summary><b> ☠️ Offensive Security & Penetration Testing (Click to Expand)</b></summary>

*   **Reconnaissance & Intel:** Nmap (Network Mapper), Whois, DNS Utils, Tracepath
*   **Web Application Analysis:** SQLMap (Automated SQL Injection), Nikto (Web Vulnerability Scanner)
*   **Cryptographic & Password Attacks:** Hydra (Network Logon Cracker), John the Ripper (Offline Password Cracker)
*   **Exploitation Frameworks:** Metasploit Framework (MSF Console - Full Database)
*   **Network Manipulation:** Netcat (The TCP/IP Swiss Army Knife)
</details>

---

## 📱 System Prerequisites

To ensure maximum performance without bottlenecks, verify the following:

| Component | Minimum Requirement | Recommended |
| :--- | :--- | :--- |
| **OS Version** | Android 8.0+ | Android 11+ |
| **Free Storage** | 4.5 GB (Internal) | 6.0 GB+ (Internal) |
| **RAM** | 4 GB | 6 GB or higher |
| **Termux App** | [GitHub Release ONLY](https://github.com/termux/termux-app/releases) | DO NOT USE PLAY STORE |
| **X11 App** | [Termux-X11 Plugin](https://github.com/termux/termux-x11/releases) | Latest Nightly Build |

---

## 🚀 1-Click Deployment Guide

Installation is fully autonomous. Follow these exact steps:

1. Open your **Termux** application.
2. Ensure you have an active, stable internet connection.
3. Copy and paste the deployment string below and press Enter:

```bash
curl -sL [https://raw.githubusercontent.com/Techformula786/DANIX-OS/main/install.sh](https://raw.githubusercontent.com/Techformula786/DANIX-OS/main/install.sh) | bash
```

> **⏳ Note:** The compiler will take approximately **15 to 25 minutes** to build the OS. Do not force-close the app while the progress bar is running.

---

## 🖥️ Global Master Commands

Once the terminal outputs **"DEPLOYMENT SUCCESSFUL - 100%"**, the DANIX OS Core is active. Use these master commands anywhere in Termux:

| Command Syntax | Sub-System Action |
| :--- | :--- |
| `bash ~/start-danixos.sh` | 🚀 **Ignites the Graphical OS.** *(Immediately open the Termux-X11 app after running this to view the desktop).* |
| `bash ~/danix-tools.sh` | 🛡️ **Deploys the CLI Security Toolkit.** *(A beautifully designed interface to launch Nmap, MSF, etc., without starting the heavy GUI).* |
| `bash ~/stop-danixos.sh` | 🛑 **Executes a Graceful Shutdown.** *(Clears cache, kills X11, terminates PulseAudio, and frees up RAM).* |

---

## 🔧 Troubleshooting & FAQ

**Q: Termux keeps crashing during the installation!**  
> **A:** Modern Android systems (especially Android 12/13/14) use a "Phantom Process Killer" that terminates heavy background tasks. You must disable this in your Android Developer Options or via ADB.

**Q: I get a black screen when I open the Termux-X11 app.**  
> **A:** Ensure you ran `bash ~/start-danixos.sh` *before* opening the Termux-X11 app. If it persists, run `bash ~/stop-danixos.sh` and try again.

**Q: Storage Permission Denied error?**  
> **A:** Go to your Android App Settings -> Termux -> Permissions -> Allow Storage/Files access. 

---

## ⚖️ Legal & Ethical Disclaimer

> **DANIX OS and its bundled tactical toolkits are engineered strictly for EDUCATIONAL PURPOSES, ethical hacking, and authorized system administration.** 
> Unauthorized penetration testing, network scanning, or attempting to breach systems you do not own is illegal and punishable by law. The author, **Mohd Danish Iqbal**, assumes absolute zero liability for any misuse, damage, or legal consequences caused by this software. Be a professional, act ethically.

---

<div align="center">

## 🌐 Join the Ecosystem

Architected and maintained by **Mohd Danish Iqbal**. <br>
If DANIX OS revolutionized your workflow, consider supporting the continuous development by dropping a ⭐ **Star** on this repository!

[![YouTube](https://img.shields.io/badge/Subscribe_to-techformula_786-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtube.com/@techformula.786?si=q_8QOqew4grutpg_)
[![Infoinsight](https://img.shields.io/badge/Powered_by-Infoinsight-0052CC?style=for-the-badge&logo=google-cloud&logoColor=white)](https://youtube.com)

**"Where Logic Meets Creativity, and Mobile Computing Meets Desktop Power."**

</div>
