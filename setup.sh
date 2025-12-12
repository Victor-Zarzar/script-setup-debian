#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

source "$LIB_DIR/utils.sh"
source "$LIB_DIR/apt.sh"
source "$LIB_DIR/snap.sh"
source "$LIB_DIR/flatpak.sh"
source "$LIB_DIR/brew.sh"
source "$LIB_DIR/manual.sh"
source "$LIB_DIR/docker.sh"
source "$LIB_DIR/git.sh"
source "$LIB_DIR/system.sh"

show_menu() {
    clear
    echo ""
    echo "========================================"
    echo " Debian/Ubuntu Development Setup"
    echo "========================================"
    echo ""
    echo " 1) Run complete setup"
    echo " 2) Update system"
    echo " 3) Setup Snapd"
    echo " 4) Setup directories"
    echo " 5) Install Git"
    echo " 6) Install text editors (Zed, Sublime)"
    echo " 7) Install security tools"
    echo " 8) Install Python environment"
    echo " 9) Install Snap applications"
    echo "10) Install Node.js tools"
    echo "11) Install Docker"
    echo "12) Install browsers"
    echo "13) Install fonts"
    echo "14) Install system tools"
    echo "15) Install Flatpak applications"
    echo "16) Install databases"
    echo "17) Install Homebrew"
    echo "18) Install Homebrew packages"
    echo "19) Install Zsh"
    echo "20) Configure Git"
    echo "21) Install Bun"
    echo "22) View installation log"
    echo " 0) Exit"
    echo ""
}

run_complete_setup() {
    print_section "Starting Complete Setup"

    update_system
    setup_snapd
    setup_directories
    install_git
    install_zed_editor
    install_security_tools
    install_python_env
    install_snap_apps
    install_nodejs_tools
    install_docker
    install_browsers
    install_fonts
    install_system_tools
    install_flatpak_apps
    install_databases
    install_homebrew
    install_brew_packages
    install_zsh
    install_bun
    install_localsend

    print_section "Setup Complete"
    print_info "Log file: $LOG_FILE"
    print_warning "Please log out and log back in for all changes to take effect"
}

main() {
    while true; do
        show_menu
        read -p "Select an option: " choice

        case $choice in
            1) run_complete_setup ;;
            2) update_system ;;
            3) setup_snapd ;;
            4) setup_directories ;;
            5) install_git ;;
            6) install_zed_editor; install_snap_package "sublime-text" "Sublime Text" "true" ;;
            7) install_security_tools; install_localsend ;;
            8) install_python_env ;;
            9) install_snap_apps ;;
            10) install_nodejs_tools ;;
            11) install_docker ;;
            12) install_browsers ;;
            13) install_fonts ;;
            14) install_system_tools ;;
            15) install_flatpak_apps ;;
            16) install_databases ;;
            17) install_homebrew ;;
            18) install_brew_packages ;;
            19) install_zsh ;;
            20) configure_git ;;
            21) install_bun ;;
            22) view_log ;;
            0) echo "Goodbye!"; exit 0 ;;
            *) print_error "Invalid option" ;;
        esac

        echo ""
        read -p "Press Enter to continue..."
    done
}

main "$@"
