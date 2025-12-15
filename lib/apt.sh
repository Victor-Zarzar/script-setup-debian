#!/bin/bash

# ============================================
# APT Package Installation Functions
# ============================================

install_git() {
    print_section "Installing Git"

    run_command "sudo apt install -y git" "Git installed"
}

install_security_tools() {
    print_section "Installing Security Tools"

    run_command "sudo apt install -y keepassxc" "KeePassXC installed"
    run_command "sudo snap install localsend" "LocalSend installed"
    run_command "sudo apt install -y network-manager-openvpn openvpn" "OpenVPN installed"
}

install_python_env() {
    print_section "Installing Python Environment"

    run_command "sudo apt install -y python3-pip python3-venv" "Python tools installed"
    run_command "pip3 install fastapi uvicorn" "FastAPI and Uvicorn installed"

    print_info "Pyenv will be installed via Homebrew (option 18)"

    log_action "Python environment configured"
}

install_nodejs_tools() {
    print_section "Installing Node.js Tools"

    run_command "sudo apt install -y npm" "NPM installed"
    run_command "sudo npm install -g pnpm" "PNPM installed"

    print_info "NVM will be installed via Homebrew (option 18)"
}

install_browsers() {
    print_section "Installing Additional Browsers"

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

    run_command "sudo apt install -y fonts-jetbrains-mono" "JetBrains Mono font installed"
}

install_system_tools() {
    print_section "Installing System Tools"

    run_command "sudo apt install -y openssh-server" "SSH server installed"
    run_command "sudo apt install -y nano exa" "Text editor and ls replacement"
    run_command "sudo apt install -y kde-spectacle" "Screenshot tool installed"
    run_command "sudo apt install -y cmake automake ninja-build clang" "Build tools installed"
    run_command "sudo apt install -y flatpak" "Flatpak installed"

    print_info "Nginx will be installed via Homebrew (option 18)"
}

install_databases() {
    print_section "Installing Databases"

    print_info "SQLite and MySQL will be installed via Homebrew (option 18)"
    print_info "Skipping APT database installation..."
}
