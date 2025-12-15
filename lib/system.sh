#!/bin/bash

# ============================================
# System Configuration Functions
# ============================================

update_system() {
    print_section "Updating System"

    run_command "sudo apt update" "Package lists updated"
    run_command "sudo apt upgrade -y" "System upgraded"
    run_command "sudo apt autoremove -y" "Unused packages removed"

    log_action "System updated"
}

setup_snapd() {
    print_section "Setting Up Snapd"

    run_command "sudo apt install -y snapd" "Snapd installed"
    run_command "sudo systemctl enable --now snapd.socket" "Snapd service enabled"
    run_command "sudo ln -sf /var/lib/snapd/snap /snap" "Snap symlink created"

    log_action "Snapd configured"
}

setup_directories() {
    print_section "Setting Up Directories"

    local dirs=(
        "$HOME/Projects"
    )

    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir" && print_success "Created: $dir" || print_error "Failed to create: $dir"
        else
            print_info "Already exists: $dir"
        fi
    done

    log_action "Directories configured"
}

install_zsh() {
    print_section "Installing Zsh"

    run_command "sudo apt install -y zsh" "Zsh installed"

    print_info "To make Zsh your default shell, run: chsh -s \$(which zsh)"
}
