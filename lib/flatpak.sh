#!/bin/bash

# ============================================
# Flatpak Package Installation Functions
# ============================================

install_flatpak_apps() {
    print_section "Installing Flatpak Applications"

    print_info "Adding Flathub repository..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo >> "$LOG_FILE" 2>&1

    local apps=(
        "org.libreoffice.LibreOffice:LibreOffice"
        "io.github.thetumultuousunicornofdarkness.cpu-x:CPU-X"
        "com.github.jeromerobert.pdfarranger:PDF Arranger"
    )

    for app in "${apps[@]}"; do
        IFS=':' read -r pkg desc <<< "$app"
        run_command "flatpak install -y flathub $pkg" "$desc"
    done
}
