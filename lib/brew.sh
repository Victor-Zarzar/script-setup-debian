#!/bin/bash

source "$(dirname "$0")/utils.sh"

install_homebrew() {
    print_section "Homebrew Installation"

    if command_exists brew; then
        print_skipped "Homebrew"
        return 0
    fi

    print_info "Installing Homebrew..."
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" >> "$LOG_FILE" 2>&1; then
        print_status "Homebrew installed"

        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

        print_info "Installing Homebrew dependencies..."
        sudo apt install -y build-essential >> "$LOG_FILE" 2>&1
    else
        print_error "Failed to install Homebrew"
        return 1
    fi
}

install_brew_package() {
    local package="$1"
    local display_name="${2:-$1}"

    if ! command_exists brew; then
        print_error "Homebrew not installed"
        return 1
    fi

    if is_brew_installed "$package"; then
        print_skipped "$display_name"
        return 0
    fi

    print_info "Installing $display_name..."
    if brew install "$package" >> "$LOG_FILE" 2>&1; then
        print_status "$display_name installed"
        return 0
    else
        print_error "Failed to install $display_name"
        return 1
    fi
}

install_brew_packages() {
    print_section "Homebrew Packages"

    if ! command_exists brew; then
        print_warning "Homebrew not installed. Skipping brew packages."
        return 1
    fi

    install_brew_package "fvm" "FVM (Flutter Version Manager)"
    install_brew_package "nvm" "NVM (Node Version Manager)"
    install_brew_package "starship" "Starship Prompt"
    install_brew_package "zsh-autosuggestions" "Zsh Autosuggestions (Brew)"
    install_brew_package "openjdk@21" "OpenJDK 21"
    install_brew_package "pyenv" "Pyenv"
    install_brew_package "alembic" "Alembic"
    install_brew_package "nginx" "Nginx"
    install_brew_package "sqlite" "SQLite (Brew)"
    install_brew_package "mysql" "MySQL"
    install_brew_package "cmake" "CMake"
    install_brew_package "automake" "Automake"
    install_brew_package "ninja" "Ninja"
    install_brew_package "llvm" "LLVM/Clang"

    if is_brew_installed "nvm"; then
        if ! grep -q "NVM_DIR" ~/.bashrc; then
            print_info "Configuring NVM in .bashrc..."
            cat >> ~/.bashrc << 'EOF'

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"
EOF
            print_status "NVM configured in .bashrc"
        fi
    fi

    if is_brew_installed "pyenv"; then
        if ! grep -q "PYENV_ROOT" ~/.bashrc; then
            print_info "Configuring Pyenv in .bashrc..."
            cat >> ~/.bashrc << 'EOF'

# Pyenv Configuration
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF
            print_status "Pyenv configured in .bashrc"
        fi
    fi

    if is_brew_installed "starship"; then
        if ! grep -q "starship init" ~/.bashrc; then
            print_info "Configuring Starship in .bashrc..."
            echo 'eval "$(starship init bash)"' >> ~/.bashrc
            print_status "Starship configured in .bashrc"
        fi
    fi
}
