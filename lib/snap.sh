#!/bin/bash

source "$(dirname "$0")/utils.sh"

install_snap_package() {
    local package="$1"
    local display_name="${2:-$1}"
    local classic="${3:-false}"

    if is_snap_installed "$package"; then
        print_skipped "$display_name"
        return 0
    fi

    print_info "Installing $display_name..."
    local cmd="sudo snap install $package"
    if [ "$classic" = "true" ]; then
        cmd="$cmd --classic"
    fi

    if $cmd >> "$LOG_FILE" 2>&1; then
        print_status "$display_name installed"
        return 0
    else
        print_error "Failed to install $display_name"
        return 1
    fi
}

install_snap_apps() {
    print_section "Snap Applications"

    install_snap_package "sublime-text" "Sublime Text" "true"
    install_snap_package "postman" "Postman"
    install_snap_package "chatgpt-desktop" "ChatGPT Desktop"
    install_snap_package "notion-snap-reborn" "Notion"
    install_snap_package "trello-desktop" "Trello"
    install_snap_package "whatsapp-linux-app" "WhatsApp"
    install_snap_package "deepseek-desktop" "DeepSeek Desktop"
    install_snap_package "android-studio" "Android Studio" "true"
    install_snap_package "spotify" "Spotify"
    install_snap_package "slack" "Slack" "true"
    install_snap_package "telegram-desktop" "Telegram"
}

install_browsers() {
    print_section "Browsers"

    install_snap_package "firefox" "Firefox"
    install_snap_package "opera" "Opera"

    if command_exists google-chrome || command_exists google-chrome-stable; then
        print_skipped "Google Chrome"
    else
        print_info "Installing Google Chrome..."
        wget -q -O /tmp/chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" >> "$LOG_FILE" 2>&1
        if sudo dpkg -i /tmp/chrome.deb >> "$LOG_FILE" 2>&1; then
            print_status "Google Chrome installed"
        else
            sudo apt install -f -y >> "$LOG_FILE" 2>&1
            print_status "Google Chrome installed (with dependencies)"
        fi
        rm -f /tmp/chrome.deb
    fi
}
