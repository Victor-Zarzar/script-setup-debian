#!/bin/bash

source "$(dirname "$0")/utils.sh"

setup_flatpak() {
    print_section "Flatpak Setup"

    if ! command_exists flatpak; then
        install_apt_package "flatpak" "Flatpak"
    fi

    print_info "Adding Flathub repository..."
    if flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo >> "$LOG_FILE" 2>&1; then
        print_status "Flathub repository added"
    else
        print_warning "Flathub repository may already exist"
    fi
}

install_flatpak_package() {
    local package="$1"
    local display_name="${2:-$1}"

    if is_flatpak_installed "$display_name"; then
        print_skipped "$display_name"
        return 0
    fi

    print_info "Installing $display_name..."
    if flatpak install -y flathub "$package" >> "$LOG_FILE" 2>&1; then
        print_status "$display_name installed"
        return 0
    else
        print_error "Failed to install $display_name"
        return 1
    fi
}

install_flatpak_apps() {
    print_section "Flatpak Applications"

    setup_flatpak

    install_flatpak_package "org.libreoffice.LibreOffice" "LibreOffice"
    install_flatpak_package "io.github.nickvergessen.cpux" "CPU-X"
    install_flatpak_package "com.github.jeromerobert.pdfarranger" "PDF Arranger"
}
