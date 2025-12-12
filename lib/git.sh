#!/bin/bash

source "$(dirname "$0")/utils.sh"

configure_git() {
    print_section "Git Configuration"

    echo ""
    read -p "Enter your Git username: " git_name
    read -p "Enter your Git email: " git_email

    if [ -n "$git_name" ]; then
        git config --global user.name "$git_name"
        print_status "Git username set to: $git_name"
    fi

    if [ -n "$git_email" ]; then
        git config --global user.email "$git_email"
        print_status "Git email set to: $git_email"
    fi

    git config --global init.defaultBranch main
    print_status "Default branch set to: main"
}
