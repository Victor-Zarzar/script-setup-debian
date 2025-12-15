#!/bin/bash

# ============================================
# Homebrew Installation Functions
# ============================================

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
