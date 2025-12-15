#!/bin/bash

# ============================================
# Docker Installation Functions
# ============================================

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
        ((TOTAL_INSTALLED++))
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
