#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

LOG_FILE="$HOME/debian_setup_$(date +%Y%m%d_%H%M%S).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

print_status() {
    echo -e "${GREEN}[OK]${NC} $1"
    log "[OK] $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    log "[ERROR] $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    log "[WARN] $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
    log "[INFO] $1"
}

print_skipped() {
    echo -e "${YELLOW}[SKIP]${NC} $1 (already installed)"
    log "[SKIP] $1 (already installed)"
}

print_section() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE} $1${NC}"
    echo -e "${BLUE}========================================${NC}"
    log "=== $1 ==="
}

command_exists() {
    command -v "$1" &> /dev/null
}

is_apt_installed() {
    dpkg -l "$1" 2>/dev/null | grep -q "^ii"
}

is_snap_installed() {
    snap list "$1" &> /dev/null
}

is_flatpak_installed() {
    flatpak list --app 2>/dev/null | grep -qi "$1"
}

is_brew_installed() {
    if command_exists brew; then
        brew list "$1" &> /dev/null
    else
        return 1
    fi
}
