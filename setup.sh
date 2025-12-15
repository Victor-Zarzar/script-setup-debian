#!/bin/bash

# ============================================
# Debian/Ubuntu Development Environment Setup
# Main Entry Point
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

source "$LIB_DIR/utils.sh"
source "$LIB_DIR/system.sh"
source "$LIB_DIR/apt.sh"
source "$LIB_DIR/snap.sh"
source "$LIB_DIR/flatpak.sh"
source "$LIB_DIR/brew.sh"
source "$LIB_DIR/manual.sh"
source "$LIB_DIR/docker.sh"
source "$LIB_DIR/git.sh"
source "$LIB_DIR/nvidia.sh"

# ============================================
# Interactive Menu
# ============================================

show_menu() {
    clear
    print_header
    echo "1)  Run complete setup"
    echo "2)  Update system"
    echo "3)  Setup Snapd"
    echo "4)  Setup directories"
    echo "5)  Install Git"
    echo "6)  Install text editors (Zed, Sublime)"
    echo "7)  Install security tools"
    echo "8)  Install Python environment"
    echo "9)  Install Snap applications"
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
    echo "22) Install Nvidia drivers"
    echo "23) View installation log"
    echo "0)  Exit"
    echo ""
    echo -n "Choose an option: "
}

run_full_setup() {
    print_header
    echo -e "${YELLOW}Starting complete setup...${NC}\n"

    update_system
    setup_snapd
    setup_directories
    install_git
    install_editors
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
    configure_git
    install_bun
    install_nvidia_drivers

    echo ""
    print_section "Setup Summary"
    echo -e "${GREEN}Total operations completed:${NC} $TOTAL_INSTALLED"
    echo -e "${GREEN}Log file:${NC} $LOG_FILE"
    echo ""
    print_success "Setup complete!"
    print_warning "Please log out and back in for all changes to take effect"
    print_warning "Run 'chsh -s \$(which zsh)' to set Zsh as default shell"
    echo ""

    log_action "Complete setup finished - Total operations: $TOTAL_INSTALLED"
}

# ============================================
# Main Loop
# ============================================

main() {
    if [ ! -f /etc/debian_version ]; then
        print_error "This script is for Debian/Ubuntu only!"
        exit 1
    fi

    init_logging

    while true; do
        show_menu
        read -r option

        case $option in
            1) run_full_setup ;;
            2) update_system ;;
            3) setup_snapd ;;
            4) setup_directories ;;
            5) install_git ;;
            6) install_editors ;;
            7) install_security_tools ;;
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
            22) install_nvidia_drivers ;;
            23) cat "$LOG_FILE" | less ;;
            0)
                print_success "Goodbye!"
                log_action "Script finished"
                exit 0
                ;;
            *)
                print_error "Invalid option!"
                ;;
        esac

        echo ""
        read -p "Press ENTER to continue..."
    done
}

main
