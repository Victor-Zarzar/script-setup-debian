#!/bin/bash

# ============================================
# Docker Installation Functions
# ============================================

install_docker() {
    print_section "Installing Docker"

    if dpkg -l | grep -q "^ii  docker.io"; then
        print_info "Docker already installed ($(docker --version 2>/dev/null || echo 'version unknown'))"
    else
        run_command "sudo apt install -y docker.io" "Docker installed"
    fi

    print_info "Checking Docker Compose V2 plugin..."
    local DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker}"

    if docker compose version &> /dev/null; then
        print_info "Docker Compose V2 already installed ($(docker compose version --short 2>/dev/null))"
    else
        print_info "Installing Docker Compose V2 plugin..."

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
    fi

    print_info "Configuring Docker group..."
    sudo groupadd docker 2>/dev/null || true

    if groups $USER | grep -q docker; then
        print_info "User already in docker group"
    else
        sudo usermod -aG docker $USER
        print_success "User added to docker group"
    fi

    if systemctl is-enabled docker.service &> /dev/null; then
        print_info "Docker service already enabled"
    else
        run_command "sudo systemctl enable docker.service" "Docker service enabled"
    fi

    if systemctl is-enabled containerd.service &> /dev/null; then
        print_info "Containerd service already enabled"
    else
        run_command "sudo systemctl enable containerd.service" "Containerd service enabled"
    fi

    print_warning "You need to log out and back in for Docker group changes to take effect"
    print_info "Test Docker Compose with: docker compose version"
    log_action "Docker configured with Compose V2 plugin"
}
