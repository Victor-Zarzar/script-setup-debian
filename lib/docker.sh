#!/bin/bash

source "$(dirname "$0")/utils.sh"

install_docker() {
    print_section "Docker Installation"

    if command_exists docker; then
        print_skipped "Docker"
    else
        print_info "Installing Docker..."
        if sudo apt install -y docker.io >> "$LOG_FILE" 2>&1; then
            print_status "Docker installed"
        else
            print_error "Failed to install Docker"
            return 1
        fi
    fi

    if groups "$USER" | grep -q docker; then
        print_skipped "User already in docker group"
    else
        print_info "Adding user to docker group..."
        sudo usermod -aG docker "$USER"
        print_status "User added to docker group"
        print_warning "Log out and log back in for group changes to take effect"
    fi

    print_info "Enabling Docker service..."
    sudo systemctl enable docker >> "$LOG_FILE" 2>&1
    sudo systemctl start docker >> "$LOG_FILE" 2>&1
    print_status "Docker service enabled"

    install_docker_compose_plugin
}

install_docker_compose_plugin() {
    print_section "Docker Compose V2 Installation"

    if docker compose version &> /dev/null; then
        print_skipped "Docker Compose V2"
        return 0
    fi

    print_info "Installing Docker Compose V2 plugin..."

    local compose_version="v2.24.5"
    local compose_url="https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-linux-x86_64"
    local plugin_dir="$HOME/.docker/cli-plugins"

    mkdir -p "$plugin_dir"

    if curl -SL "$compose_url" -o "$plugin_dir/docker-compose" >> "$LOG_FILE" 2>&1; then
        chmod +x "$plugin_dir/docker-compose"
        print_status "Docker Compose V2 installed"
        print_info "Use: docker compose up/down (without hyphen)"
    else
        print_error "Failed to install Docker Compose V2"
    fi
}
