#!/bin/bash

# ============================================
# APT Package Installation Functions
# ============================================

install_git() {
    print_section "Installing Git"

    if command -v git &> /dev/null; then
        print_info "Git already installed ($(git --version))"
        return 0
    fi

    run_command "sudo apt install -y git" "Git installed"
}

install_security_tools() {
    print_section "Installing Security Tools"

    if ! dpkg -l | grep -q "^ii  keepassxc"; then
        run_command "sudo apt install -y keepassxc" "KeePassXC installed"
    else
        print_info "KeePassXC already installed"
    fi

    if ! snap list | grep -q "localsend"; then
        run_command "sudo snap install localsend" "LocalSend installed"
    else
        print_info "LocalSend already installed"
    fi

    if ! dpkg -l | grep -q "^ii  network-manager-openvpn"; then
        run_command "sudo apt install -y network-manager-openvpn openvpn" "OpenVPN installed"
    else
        print_info "OpenVPN already installed"
    fi
}

install_python_env() {
    print_section "Installing Python Environment"

    if ! dpkg -l | grep -q "^ii  python3-pip"; then
        run_command "sudo apt install -y python3-pip python3-venv" "Python tools installed"
    else
        print_info "Python tools already installed"
    fi

    if ! pip3 list 2>/dev/null | grep -q "fastapi"; then
        run_command "pip3 install fastapi uvicorn" "FastAPI and Uvicorn installed"
    else
        print_info "FastAPI and Uvicorn already installed"
    fi

    print_info "Pyenv will be installed via Homebrew (option 18)"

    log_action "Python environment configured"
}

install_nodejs_tools() {
    print_section "Installing Node.js Tools"

    if ! command -v npm &> /dev/null; then
        run_command "sudo apt install -y npm" "NPM installed"
    else
        print_info "NPM already installed ($(npm --version))"
    fi

    if ! command -v pnpm &> /dev/null; then
        run_command "sudo npm install -g pnpm" "PNPM installed"
    else
        print_info "PNPM already installed ($(pnpm --version))"
    fi

    print_info "NVM will be installed via Homebrew (option 18)"
}

install_browsers() {
    print_section "Installing Additional Browsers"

    if command -v google-chrome &> /dev/null; then
        print_info "Google Chrome already installed ($(google-chrome --version))"
        return 0
    fi

    print_info "Installing Google Chrome..."
    if wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb >> "$LOG_FILE" 2>&1; then
        run_command "sudo apt install -y /tmp/chrome.deb" "Google Chrome installed"
        rm -f /tmp/chrome.deb
    else
        print_error "Failed to download Chrome"
    fi
}

install_fonts() {
    print_section "Installing Fonts"

    if ! dpkg -l | grep -q "^ii  fonts-jetbrains-mono"; then
        run_command "sudo apt install -y fonts-jetbrains-mono" "JetBrains Mono font installed"
    else
        print_info "JetBrains Mono font already installed"
    fi
}

install_system_tools() {
    print_section "Installing System Tools"

    if ! dpkg -l | grep -q "^ii  openssh-server"; then
        run_command "sudo apt install -y openssh-server" "SSH server installed"
    else
        print_info "SSH server already installed"
    fi

    if ! dpkg -l | grep -q "^ii  nano"; then
        run_command "sudo apt install -y nano exa" "Text editor and ls replacement"
    else
        print_info "Nano and exa already installed"
    fi

    if ! dpkg -l | grep -q "^ii  kde-spectacle"; then
        run_command "sudo apt install -y kde-spectacle" "Screenshot tool installed"
    else
        print_info "KDE Spectacle already installed"
    fi

    if ! dpkg -l | grep -q "^ii  cmake"; then
        run_command "sudo apt install -y cmake automake ninja-build clang" "Build tools installed"
    else
        print_info "Build tools already installed"
    fi

    if ! dpkg -l | grep -q "^ii  flatpak"; then
        run_command "sudo apt install -y flatpak" "Flatpak installed"
    else
        print_info "Flatpak already installed"
    fi

    print_info "Nginx will be installed via Homebrew (option 18)"
}

install_databases() {
    print_section "Installing Databases"

    print_info "SQLite and MySQL will be installed via Homebrew (option 18)"
    print_info "Skipping APT database installation..."
}
