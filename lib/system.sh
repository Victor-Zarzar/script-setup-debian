#!/bin/bash

source "$(dirname "$0")/utils.sh"

setup_directories() {
    print_section "Directory Setup"

    local projects_dir="$HOME/Projects"

    if [ -d "$projects_dir" ]; then
        print_skipped "Projects directory"
    else
        print_info "Creating Projects directory..."
        mkdir -p "$projects_dir"
        print_status "Projects directory created: $projects_dir"
    fi
}

view_log() {
    print_section "Installation Log"

    if [ -f "$LOG_FILE" ]; then
        echo ""
        echo "Log file: $LOG_FILE"
        echo ""
        cat "$LOG_FILE"
    else
        print_warning "No log file found for this session"
        echo ""
        echo "Available log files:"
        ls -la ~/debian_setup_*.log 2>/dev/null || echo "No log files found"
    fi
}
