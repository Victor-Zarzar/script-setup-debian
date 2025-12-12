#!/bin/bash

source "$(dirname "$0")/utils.sh"

install_zed_editor() {
    print_section "Zed Editor Installation"

    if command_exists zed; then
        print_skipped "Zed Editor"
        return 0
    fi

    print_info "Installing Zed Editor..."
    if curl -f https://zed.dev/install.sh | sh >> "$LOG_FILE" 2>&1; then
        print_status "Zed Editor installed"
    else
        print_error "Failed to install Zed Editor"
    fi
}

install_bun() {
    print_section "Bun Installation"

    if command_exists bun; then
        print_skipped "Bun"
        return 0
    fi

    print_info "Installing Bun..."
    if curl -fsSL https://bun.sh/install | bash >> "$LOG_FILE" 2>&1; then
        print_status "Bun installed"
    else
        print_error "Failed to install Bun"
    fi
}

install_localsend() {
    print_section "LocalSend Installation"

    if is_snap_installed "localsend"; then
        print_skipped "LocalSend"
        return 0
    fi

    print_info "Installing LocalSend..."
    if sudo snap install localsend >> "$LOG_FILE" 2>&1; then
        print_status "LocalSend installed"
    else
        print_error "Failed to install LocalSend"
    fi
}

install_fonts() {
    print_section "Fonts Installation"

    local font_dir="$HOME/.local/share/fonts"

    if [ -f "$font_dir/JetBrainsMono-Regular.ttf" ]; then
        print_skipped "JetBrains Mono"
        return 0
    fi

    print_info "Installing JetBrains Mono font..."
    mkdir -p "$font_dir"

    local url="https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip"
    if wget -q -O /tmp/jetbrains-mono.zip "$url" >> "$LOG_FILE" 2>&1; then
        unzip -o /tmp/jetbrains-mono.zip -d /tmp/jetbrains-mono >> "$LOG_FILE" 2>&1
        cp /tmp/jetbrains-mono/fonts/ttf/*.ttf "$font_dir/"
        fc-cache -f -v >> "$LOG_FILE" 2>&1
        rm -rf /tmp/jetbrains-mono /tmp/jetbrains-mono.zip
        print_status "JetBrains Mono font installed"
    else
        print_error "Failed to download JetBrains Mono font"
    fi
}
