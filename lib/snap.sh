#!/bin/bash

# ============================================
# Snap Package Installation Functions
# ============================================

install_editors() {
    print_section "Installing Text Editors"

    run_command "sudo snap install sublime-text --classic" "Sublime Text installed"

    print_info "Zed Editor will be installed via curl (option 6 or 21)"
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
        "telegram-desktop:Telegram"
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
