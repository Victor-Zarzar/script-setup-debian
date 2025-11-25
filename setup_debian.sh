#!/bin/bash

# ============================================
# Debian/Ubuntu Development Environment Setup
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

LOG_FILE="$HOME/debian_setup_$(date +%Y%m%d_%H%M%S).log"
TOTAL_INSTALLED=0

# ============================================
# Helper Functions
# ============================================

print_header() {
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   Debian/Ubuntu Development Setup     ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${PURPLE}$1${NC}"
    echo "────────────────────────────────────────"
}

print_success() {
    echo -e "${GREEN}✅ SUCCESS:${NC} $1"
}

print_error() {
    echo -e "${RED}❌ ERROR:${NC} $1"
}

print_info() {
    echo -e "${BLUE}🔹 INFO:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️  WARNING:${NC} $1"
}

print_executing() {
    echo -e "${CYAN}🔹 Executing:${NC} $1"
}

log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

run_command() {
    local cmd="$1"
    local description="$2"
    
    print_executing "$cmd"
    log_action "Executing: $cmd"
    
    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        print_success "${description:-Command completed}"
        ((TOTAL_INSTALLED++))
        return 0
    else
        print_error "${description:-Command failed}"
        log_action "ERROR: $cmd failed"
        return 1
    fi
}

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

# ============================================
# System Functions
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
    run_command "sudo ln -s /var/lib/snapd/snap /snap" "Snap symlink created"
    
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

# ============================================
# Installation Functions
# ============================================

install_git() {
    print_section "Installing Git"
    
    run_command "sudo apt install -y git" "Git installed"
}

install_vscode() {
    print_section "Installing Visual Studio Code"
    
    print_info "Downloading Microsoft GPG key..."
    if wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg 2>/dev/null; then
        sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        print_success "GPG key added"
    else
        print_error "Failed to download GPG key"
        return 1
    fi
    
    print_info "Adding VS Code repository..."
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    
    run_command "sudo apt update" "Repository updated"
    run_command "sudo apt install -y code" "VS Code installed"
    
    rm -f /tmp/packages.microsoft.gpg
    log_action "VS Code installed via official repository"
}

install_editors() {
    print_section "Installing Text Editors"
    
    run_command "sudo snap install sublime-text --classic" "Sublime Text installed"
    install_vscode
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

install_snap_apps() {
    print_section "Installing Snap Applications"
    
    local apps=(
        "postman:Postman"
        "chatgpt-desktop:ChatGPT Desktop"
        "notion-snap-reborn:Notion"
        "trello-desktop:Trello"
        "whatsapp-linux-desktop:WhatsApp"
        "deepseek-desktop:DeepSeek"
        "android-studio --classic:Android Studio"
        "opera:Opera"
        "spotify:Spotify"
        "slack --classic:Slack"
    )
    
    for app in "${apps[@]}"; do
        IFS=':' read -r cmd desc <<< "$app"
        run_command "sudo snap install $cmd" "$desc"
    done
}

install_firefox() {
    print_section "Installing Firefox (Optional)"
    
    if command -v firefox &> /dev/null; then
        print_warning "Firefox is already installed on your system"
        echo -n "Do you want to install Firefox from Snap anyway? (y/N): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_info "Skipping Firefox installation"
            return 0
        fi
    fi
    
    run_command "sudo snap install firefox" "Firefox"
}

install_nodejs_tools() {
    print_section "Installing Node.js Tools"
    
    run_command "sudo apt install -y npm" "NPM installed"
    run_command "sudo npm install -g pnpm" "PNPM installed"
}

install_docker() {
    print_section "Installing Docker"
    
    run_command "sudo apt install -y docker.io" "Docker installed"
    
    print_info "Installing Docker Compose V2 plugin..."
    local DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker}"
    
    if mkdir -p "$DOCKER_CONFIG/cli-plugins" >> "$LOG_FILE" 2>&1; then
        print_success "Docker config directory created"
    fi
    
    print_info "Downloading Docker Compose V2..."
    if curl -SL https://github.com/docker/compose/releases/download/v2.40.1/docker-compose-linux-x86_64 -o "$DOCKER_CONFIG/cli-plugins/docker-compose" >> "$LOG_FILE" 2>&1; then
        chmod +x "$DOCKER_CONFIG/cli-plugins/docker-compose"
        print_success "Docker Compose V2 plugin installed"
    else
        print_error "Failed to download Docker Compose V2"
    fi
    
    print_info "Configuring Docker group..."
    sudo groupadd docker 2>/dev/null || true
    sudo usermod -aG docker $USER
    
    run_command "sudo systemctl enable docker.service" "Docker service enabled"
    run_command "sudo systemctl enable containerd.service" "Containerd service enabled"
    
    print_warning "You need to log out and back in for Docker group changes to take effect"
    print_info "Test Docker Compose with: docker compose version"
    log_action "Docker configured with Compose V2 plugin"
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

install_flatpak_apps() {
    print_section "Installing Flatpak Applications"
    
    print_info "Adding Flathub repository..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo >> "$LOG_FILE" 2>&1
    
    local apps=(
        "org.onlyoffice.desktopeditors:OnlyOffice"
        "io.github.thetumultuousunicornofdarkness.cpu-x:CPU-X"
        "com.github.jeromerobert.pdfarranger:PDF Arranger"
    )
    
    for app in "${apps[@]}"; do
        IFS=':' read -r pkg desc <<< "$app"
        run_command "flatpak install -y flathub $pkg" "$desc"
    done
}

install_databases() {
    print_section "Installing Databases"
    
    print_info "SQLite and MySQL will be installed via Homebrew (option 18)"
    print_info "Skipping APT database installation..."
}

install_homebrew() {
    print_section "Installing Homebrew"
    
    if command -v brew &> /dev/null; then
        print_info "Homebrew already installed"
        brew --version | head -n 1
        return 0
    fi
    
    print_info "Installing Homebrew..."
    
    if NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >> "$LOG_FILE" 2>&1; then
        print_success "Homebrew installed successfully"
    
        if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            
            if ! grep -q 'linuxbrew' "$HOME/.bashrc"; then
                echo '' >> "$HOME/.bashrc"
                echo '# Homebrew configuration' >> "$HOME/.bashrc"
                echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.bashrc"
                print_success "Homebrew added to .bashrc"
            fi
        fi
        
        log_action "Homebrew installed"
        return 0
    else
        print_error "Failed to install Homebrew"
        log_action "ERROR: Homebrew installation failed"
        return 1
    fi
}

install_brew_packages() {
    print_section "Installing Homebrew Packages"
    
    if ! command -v brew &> /dev/null; then
        print_warning "Homebrew not found, skipping brew packages"
        return 1
    fi
    
    run_command "brew install pyenv" "Pyenv installed"
    run_command "brew install nvm" "NVM installed"
    run_command "brew install openjdk@21" "OpenJDK 21 installed"
    run_command "brew install nginx" "Nginx installed"
    
    run_command "brew install sqlite" "SQLite installed"
    run_command "brew install mysql" "MySQL installed"
    
    run_command "brew install starship" "Starship prompt installed"
    run_command "brew install zsh-autosuggestions" "Zsh autosuggestions installed"
    
    run_command "brew tap leoafarias/fvm" "FVM tap added"
    run_command "brew install fvm" "FVM installed"
    
    run_command "brew install alembic" "Alembic installed"
    
    if ! grep -q 'NVM_DIR' "$HOME/.bashrc"; then
        cat >> "$HOME/.bashrc" << 'EOF'

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"
EOF
        print_success "NVM added to .bashrc"
    fi
    
    if ! grep -q 'pyenv init' "$HOME/.bashrc"; then
        cat >> "$HOME/.bashrc" << 'EOF'

# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF
        print_success "Pyenv added to .bashrc"
    fi
    
    if ! grep -q 'starship init' "$HOME/.bashrc"; then
        echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
        print_success "Starship added to .bashrc"
    fi
    
    if ! grep -q 'zsh-autosuggestions' "$HOME/.zshrc" 2>/dev/null; then
        echo 'source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh' >> "$HOME/.zshrc"
        print_success "Zsh autosuggestions added to .zshrc"
    fi
    
    print_info "MySQL service: brew services start mysql"
    print_info "Nginx service: brew services start nginx"
}

install_zsh() {
    print_section "Installing Zsh"
    
    run_command "sudo apt install -y zsh" "Zsh installed"
    
    print_info "To make Zsh your default shell, run: chsh -s $(which zsh)"
}

configure_git() {
    print_section "Configuring Git"
    
    print_info "Enter your Git username:"
    read -r GIT_USERNAME
    
    print_info "Enter your Git email:"
    read -r GIT_EMAIL
    
    run_command "git config --global user.name '$GIT_USERNAME'" "Git username configured"
    run_command "git config --global user.email '$GIT_EMAIL'" "Git email configured"
}

install_nvidia_drivers() {
    print_section "NVIDIA Drivers Installation"
    
    local distro=$(detect_distro)
    
    print_info "Checking for NVIDIA GPU..."
    if lspci | grep -i nvidia &> /dev/null; then
        print_success "NVIDIA GPU detected!"
        lspci | grep -i nvidia
    else
        print_warning "No NVIDIA GPU detected in this system"
        echo ""
        print_info "Press ENTER to continue..."
        read
        return 0
    fi
    
    echo ""
    print_info "Detected distribution: $distro"
    echo ""
    
    if [ "$distro" = "ubuntu" ] || [ "$distro" = "neon" ] || [ "$distro" = "pop" ] || [ "$distro" = "linuxmint" ]; then
        print_info "Ubuntu-based system detected"
        echo ""
        echo -e "${CYAN}Checking available NVIDIA drivers...${NC}"
        ubuntu-drivers devices
        echo ""
        echo -n "Install recommended NVIDIA driver automatically? (Y/n): "
        read -r response
        
        if [[ ! "$response" =~ ^[Nn]$ ]]; then
            run_command "sudo ubuntu-drivers autoinstall" "NVIDIA driver installed"
            echo ""
            print_warning "You must reboot for changes to take effect"
            echo -n "Reboot now? (y/N): "
            read -r reboot_response
            if [[ "$reboot_response" =~ ^[Yy]$ ]]; then
                sudo reboot
            fi
        else
            print_info "Manual installation - use: sudo apt install nvidia-driver-XXX"
        fi
        
    elif [ "$distro" = "debian" ]; then
        print_info "Debian system detected"
        echo ""
        
        if ! grep -q "non-free" /etc/apt/sources.list; then
            print_warning "Non-free repositories not detected in /etc/apt/sources.list"
            echo ""
            echo -n "Add non-free repositories? (Y/n): "
            read -r response
            
            if [[ ! "$response" =~ ^[Nn]$ ]]; then
                print_info "Backing up sources.list..."
                sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
                
                print_info "Adding non-free repositories..."
                sudo sed -i 's/main$/main contrib non-free non-free-firmware/g' /etc/apt/sources.list
                
                run_command "sudo apt update" "Package lists updated"
                print_success "Non-free repositories added"
            else
                print_warning "Cannot install NVIDIA drivers without non-free repositories"
                return 1
            fi
        else
            print_success "Non-free repositories already enabled"
        fi
        
        echo ""
        print_info "Available NVIDIA driver packages:"
        apt search nvidia-driver 2>/dev/null | grep "nvidia-driver" | head -n 5
        
        echo ""
        echo -n "Install NVIDIA driver and firmware? (Y/n): "
        read -r response
        
        if [[ ! "$response" =~ ^[Nn]$ ]]; then
            run_command "sudo apt install -y nvidia-driver firmware-misc-nonfree" "NVIDIA driver installed"
            echo ""
            print_warning "You must reboot for changes to take effect"
            echo -n "Reboot now? (y/N): "
            read -r reboot_response
            if [[ "$reboot_response" =~ ^[Yy]$ ]]; then
                sudo reboot
            fi
        else
            print_info "Skipping NVIDIA driver installation"
        fi
        
    else
        print_warning "Distribution '$distro' not directly supported"
        echo ""
        print_info "Generic installation instructions:"
        echo ""
        echo -e "${CYAN}For Ubuntu-based:${NC}"
        echo -e "   ${GREEN}ubuntu-drivers devices${NC}"
        echo -e "   ${GREEN}sudo ubuntu-drivers autoinstall${NC}"
        echo ""
        echo -e "${CYAN}For Debian-based:${NC}"
        echo -e "   ${GREEN}sudo apt install nvidia-driver firmware-misc-nonfree${NC}"
        echo ""
        print_info "Press ENTER to continue..."
        read
    fi
    
    log_action "NVIDIA driver installation processed for: $distro"
}

show_system_info() {
    print_section "System Information"
    
    if [ -f /etc/os-release ]; then
        cat /etc/os-release
    else
        print_error "Unable to detect system information"
    fi
    
    echo ""
    print_info "Press ENTER to continue..."
    read
}

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
    echo "6)  Install text editors (VS Code, Sublime)"
    echo "7)  Install security tools"
    echo "8)  Install Python environment"
    echo "9)  Install Snap applications"
    echo "10) Install Firefox (optional)"
    echo "11) Install Node.js tools"
    echo "12) Install Docker"
    echo "13) Install browsers"
    echo "14) Install fonts"
    echo "15) Install system tools"
    echo "16) Install Flatpak applications (OnlyOffice)"
    echo "17) Install databases"
    echo "18) Install Homebrew"
    echo "19) Install Homebrew packages"
    echo "20) Install Zsh"
    echo "21) Configure Git"
    echo "22) Install NVIDIA drivers"
    echo "23) Show system information"
    echo "24) View installation log"
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
    install_firefox
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
    
    touch "$LOG_FILE"
    log_action "Starting setup script"
    
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
            10) install_firefox ;;
            11) install_nodejs_tools ;;
            12) install_docker ;;
            13) install_browsers ;;
            14) install_fonts ;;
            15) install_system_tools ;;
            16) install_flatpak_apps ;;
            17) install_databases ;;
            18) install_homebrew ;;
            19) install_brew_packages ;;
            20) install_zsh ;;
            21) configure_git ;;
            22) install_nvidia_drivers ;;
            23) show_system_info ;;
            24) cat "$LOG_FILE" | less ;;
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