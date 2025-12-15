#!/bin/bash

# ============================================
# NVIDIA Driver Installation Functions
# ============================================

check_nvidia_gpu() {
    if lspci | grep -i nvidia &> /dev/null; then
        return 0
    else
        return 1
    fi
}

install_nvidia_drivers() {
    print_section "Installing NVIDIA Drivers"

    if ! check_nvidia_gpu; then
        print_warning "No NVIDIA GPU detected on this system"
        print_info "Skipping NVIDIA driver installation"
        return 0
    fi

    print_success "NVIDIA GPU detected!"

    local distro=$(detect_distro)
    print_info "Detected distribution: $distro"

    if [ "$distro" = "ubuntu" ] || [ "$distro" = "neon" ] || [ "$distro" = "pop" ] || [ "$distro" = "linuxmint" ]; then
        print_info "Ubuntu-based system detected"
        print_info "Checking available NVIDIA drivers..."

        ubuntu-drivers devices >> "$LOG_FILE" 2>&1

        print_info "Installing recommended NVIDIA driver..."
        run_command "sudo ubuntu-drivers autoinstall" "NVIDIA driver installed"

        print_warning "IMPORTANT: Reboot your system for changes to take effect"
        print_info "After reboot, verify with: nvidia-smi"

    elif [ "$distro" = "debian" ]; then
        print_info "Debian system detected"
        print_warning "Please ensure contrib non-free non-free-firmware repositories are enabled"

        run_command "sudo apt update" "Package lists updated"
        run_command "sudo apt install -y nvidia-driver firmware-misc-nonfree" "NVIDIA driver installed"

        print_warning "IMPORTANT: Reboot your system for changes to take effect"
        print_info "After reboot, verify with: nvidia-smi"

    else
        print_warning "Distribution '$distro' - attempting generic installation"

        if command -v ubuntu-drivers &> /dev/null; then
            run_command "sudo ubuntu-drivers autoinstall" "NVIDIA driver installed"
        else
            run_command "sudo apt install -y nvidia-driver" "NVIDIA driver installed"
        fi

        print_warning "IMPORTANT: Reboot your system for changes to take effect"
    fi

    log_action "NVIDIA driver installation completed for: $distro"
}
