#!/bin/bash

source "$(dirname "$0")/utils.sh"

install_nvidia_drivers() {
    print_section "NVIDIA Drivers - Manual Installation Guide"

    local distro=$(detect_distro)

    print_info "Detected distribution: $distro"
    echo ""

    if [ "$distro" = "ubuntu" ] || [ "$distro" = "neon" ] || [ "$distro" = "pop" ] || [ "$distro" = "linuxmint" ]; then
        print_info "Ubuntu-based system detected"
        echo ""
        echo -e "${CYAN}Step 1:${NC} Check available NVIDIA drivers:"
        echo -e "   ${GREEN}ubuntu-drivers devices${NC}"
        echo ""
        echo -e "${CYAN}Step 2:${NC} Install recommended driver:"
        echo -e "   ${GREEN}sudo ubuntu-drivers autoinstall${NC}"
        echo ""
        echo -e "${CYAN}Alternative:${NC} Install specific driver version:"
        echo -e "   ${GREEN}sudo apt install nvidia-driver-XXX${NC}"
        echo "   (Replace XXX with the version number)"
        echo ""
        echo -e "${CYAN}Step 3:${NC} Reboot your system:"
        echo -e "   ${GREEN}sudo reboot${NC}"
        echo ""
        echo -e "${CYAN}Step 4:${NC} Verify installation:"
        echo -e "   ${GREEN}nvidia-smi${NC}"

    elif [ "$distro" = "debian" ]; then
        print_info "Debian system detected"
        echo ""
        echo -e "${CYAN}Step 1:${NC} Add non-free repositories to /etc/apt/sources.list"
        echo "   Add 'contrib non-free non-free-firmware' to each line"
        echo ""
        echo -e "${CYAN}Step 2:${NC} Update package lists:"
        echo -e "   ${GREEN}sudo apt update${NC}"
        echo ""
        echo -e "${CYAN}Step 3:${NC} Check available drivers:"
        echo -e "   ${GREEN}apt search nvidia-driver${NC}"
        echo ""
        echo -e "${CYAN}Step 4:${NC} Install NVIDIA driver:"
        echo -e "   ${GREEN}sudo apt install nvidia-driver firmware-misc-nonfree${NC}"
        echo ""
        echo -e "${CYAN}Step 5:${NC} Reboot your system:"
        echo -e "   ${GREEN}sudo reboot${NC}"
        echo ""
        echo -e "${CYAN}Step 6:${NC} Verify installation:"
        echo -e "   ${GREEN}nvidia-smi${NC}"

    else
        print_warning "Distribution '$distro' not directly supported"
        echo ""
        print_info "For Ubuntu-based distributions, try:"
        echo -e "   ${GREEN}ubuntu-drivers devices${NC}"
        echo -e "   ${GREEN}sudo ubuntu-drivers autoinstall${NC}"
        echo ""
        print_info "For Debian-based distributions, try:"
        echo -e "   ${GREEN}sudo apt install nvidia-driver${NC}"
    fi

    echo ""
    print_warning "IMPORTANT: Always reboot after installing NVIDIA drivers"
    print_info "These commands are provided for manual installation only"

    log_action "Displayed NVIDIA driver installation instructions for: $distro"
}
