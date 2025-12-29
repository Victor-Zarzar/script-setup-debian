#!/bin/bash

# ============================================
# Utility Functions
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

LOG_FILE="$HOME/debian_setup_$(date +%Y%m%d_%H%M%S).log"
TOTAL_INSTALLED=0

# ============================================
# Print Functions
# ============================================

print_header() {
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   Debian/Ubuntu Development Setup     ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${PURPLE}$1${NC}"
    echo "────────────────────────────────────────"
}

print_success() {
    echo -e "${GREEN}SUCCESS:${NC} $1"
}

print_error() {
    echo -e "${RED}ERROR:${NC} $1"
}

print_info() {
    echo -e "${BLUE}INFO:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}WARNING:${NC} $1"
}

print_executing() {
    echo -e "${CYAN}Executing:${NC} $1"
}

# ============================================
# Logging Functions
# ============================================

init_logging() {
    touch "$LOG_FILE"
    log_action "Starting setup script"
}

log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ============================================
# Command Execution
# ============================================

run_command() {
    local cmd="$1"
    local description="$2"

    print_executing "$cmd"
    log_action "Executing: $cmd"

    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        print_success "${description:-Command completed}"
        ((TOTAL_INSTALLED++))
        return 0
    else
        print_error "${description:-Command failed}"
        log_action "ERROR: $cmd failed"
        return 1
    fi
}

# ============================================
# System Detection
# ============================================

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}
