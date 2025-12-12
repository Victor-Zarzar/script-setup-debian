# Debian/Ubuntu Development Environment Setup

A modular, idempotent automated setup script for Debian/Ubuntu that installs and configures a complete development environment.

## Features

- **Modular Architecture**: Organized into separate library files for maintainability
- **Idempotent Execution**: Safe to run multiple times without duplicating installations
- **Hybrid Package Strategy**: Uses APT, Snap, Flatpak, Homebrew, NPM, and Pip
- **Interactive Menu**: Choose individual components or run complete setup
- **Automatic Logging**: Detailed timestamped logs for troubleshooting

## What Gets Installed

### Text Editors & IDEs
- Zed Editor (official installer)
- Sublime Text (Snap)
- Android Studio (Snap)

### Shell & Terminal
- Zsh with autosuggestions
- Starship prompt (Homebrew)
- Exa (modern ls replacement)

### Development Tools
- Git, Docker, Docker Compose V2
- Node.js tools: NPM, PNPM, NVM, Bun
- Python: Pip, Venv, FastAPI, Uvicorn, Pyenv
- Build tools: CMake, Automake, Ninja, Clang
- OpenJDK 21, Nginx, OpenSSH Server

### Databases
- SQLite, MySQL

### Applications
- **Snap**: Postman, ChatGPT, Notion, Trello, WhatsApp, Slack, Telegram, Spotify, DeepSeek
- **Flatpak**: LibreOffice, CPU-X, PDF Arranger
- **Browsers**: Firefox, Google Chrome, Opera

### Security & Utilities
- KeePassXC, LocalSend, OpenVPN
- KDE Spectacle, JetBrains Mono font

### Homebrew Packages
- FVM (Flutter Version Manager)
- NVM, Pyenv, Alembic
- Starship, Nginx, MySQL, SQLite

## Requirements

- Debian 10+ or Ubuntu 20.04+
- Sudo privileges
- Internet connection

## Installation

```bash
git clone https://github.com/Victor-Zarzar/script-setup-debian
cd script-setup-debian
chmod +x setup.sh
./setup.sh
```

## Directory Structure

```
debian-setup/
├── setup.sh          # Main entry point
├── lib/
│   ├── utils.sh      # Utility functions and logging
│   ├── apt.sh        # APT package installations
│   ├── snap.sh       # Snap package installations
│   ├── flatpak.sh    # Flatpak package installations
│   ├── brew.sh       # Homebrew installations
│   ├── manual.sh     # Manual installations (Zed, Bun, fonts)
│   ├── docker.sh     # Docker and Compose setup
│   ├── git.sh        # Git configuration
│   └── system.sh     # System configuration
└── README.md
```

## Menu Options

```
 1) Run complete setup
 2) Update system
 3) Setup Snapd
 4) Setup directories
 5) Install Git
 6) Install text editors (Zed, Sublime)
 7) Install security tools
 8) Install Python environment
 9) Install Snap applications
10) Install Node.js tools
11) Install Docker
12) Install browsers
13) Install fonts
14) Install system tools
15) Install Flatpak applications
16) Install databases
17) Install Homebrew
18) Install Homebrew packages
19) Install Zsh
20) Configure Git
21) Install Bun
22) View installation log
 0) Exit
```

## Post-Installation

1. **Log out and log back in** for Docker group changes
2. **Restart terminal** for shell configurations (Homebrew, Pyenv, NVM, Starship)
3. **Set Zsh as default**: `chsh -s $(which zsh)`
4. **Install Python**: `pyenv install 3.11.0 && pyenv global 3.11.0`
5. **Install Node.js**: `nvm install --lts && nvm use --lts`
6. **Install Flutter**: `fvm install stable && fvm global stable`
7. **Start services**: `brew services start mysql && brew services start nginx`

## Docker Usage

Docker Compose V2 is installed as a plugin:

```bash
docker compose up
docker compose down
docker compose version
```

## Log Files

Logs are created at: `~/debian_setup_YYYYMMDD_HHMMSS.log`

## Troubleshooting

**Snap apps not appearing:**
```bash
sudo systemctl restart snapd
```

**Docker permission denied:**
```bash
# Log out and log back in, then:
docker run hello-world
```

**Flatpak issues:**
```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

## License

MIT License

## Author

Victor Zarzar
