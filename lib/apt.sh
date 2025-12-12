#!/bin/bash

source "$(dirname "$0")/utils.sh"

update_system() {
    print_section "System Update"

    print_info "Updating package lists..."
    if sudo apt update -y >> "$LOG_FILE" 2>&1; then
        print_status "Package lists updated"
    else
        print_error "Failed to update package lists"
    fi

    print_info "Upgrading packages..."
    if sudo apt upgrade -y >> "$LOG_FILE" 2>&1; then
        print_status "Packages upgraded"
    else
        print_error "Failed to upgrade packages"
    fi

    print_info "Removing unused packages..."
    if sudo apt autoremove -y >> "$LOG_FILE" 2>&1; then
        print_status "Unused packages removed"
    else
        print_error "Failed to remove unused packages"
    fi
}

install_apt_package() {
    local package="$1"
    local display_name="${2:-$1}"

    if is_apt_installed "$package"; then
        print_skipped "$display_name"
        return 0
    fi

    print_info "Installing $display_name..."
    if sudo apt install -y "$package" >> "$LOG_FILE" 2>&1; then
        print_status "$display_name installed"
        return 0
    else
        print_error "Failed to install $display_name"
        return 1
    fi
}

setup_snapd() {
    print_section "Snapd Setup"
    install_apt_package "snapd" "Snapd"
}

install_git() {
    print_section "Git Installation"
    install_apt_package "git" "Git"
}

install_zsh() {
    print_section "Zsh Installation"
    install_apt_package "zsh" "Zsh"
    install_apt_package "zsh-autosuggestions" "Zsh Autosuggestions"
}

install_python_env() {
    print_section "Python Environment"
    install_apt_package "python3-pip" "Python3 Pip"
    install_apt_package "python3-venv" "Python3 Venv"

    print_info "Installing FastAPI and Uvicorn..."
    if pip3 install --user fastapi uvicorn >> "$LOG_FILE" 2>&1; then
        print_status "FastAPI and Uvicorn installed"
    else
        print_warning "FastAPI/Uvicorn installation failed (may need venv)"
    fi
}

install_security_tools() {
    print_section "Security Tools"
    install_apt_package "keepassxc" "KeePassXC"
    install_apt_package "network-manager-openvpn" "Network Manager OpenVPN"
    install_apt_package "openvpn" "OpenVPN"
}

install_system_tools() {
    print_section "System Tools"
    install_apt_package "nano" "Nano"
    install_apt_package "exa" "Exa"
    install_apt_package "flatpak" "Flatpak"
    install_apt_package "kde-spectacle" "KDE Spectacle"
    install_apt_package "openssh-server" "OpenSSH Server"
}

install_nodejs_tools() {
    print_section "Node.js Tools"
    install_apt_package "npm" "NPM"

    if command_exists pnpm; then
        print_skipped "PNPM"
    else
        print_info "Installing PNPM..."
        if sudo npm install -g pnpm >> "$LOG_FILE" 2>&1; then
            print_status "PNPM installed"
        else
            print_error "Failed to install PNPM"
        fi
    fi
}

install_databases() {
    print_section "Databases"
    install_apt_package "sqlite3" "SQLite3"
}
