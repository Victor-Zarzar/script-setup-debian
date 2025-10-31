# Debian/Ubuntu Development Environment Setup

A comprehensive automated setup script for Debian/Ubuntu that helps install and configure your complete development environment with a single command.

## Features

- **System Updates**: Automatic APT updates and upgrades
- **Text Editors**: VS Code (official Microsoft repository), Sublime Text
- **Shell Tools**: Zsh, Zsh autosuggestions, Exa
- **Databases**: SQLite, MySQL
- **Development Tools**: Git, Node.js (NPM), PNPM, Docker
- **Python Environment**: Pip, Venv, FastAPI, Uvicorn, Pyenv
- **Flutter Tools**: FVM (Flutter Version Manager) via Homebrew
- **Snap Applications**: Postman, ChatGPT, Notion, Trello, WhatsApp, Android Studio, and more
- **Flatpak Applications**: LibreOffice, CPU-X, PDF Arranger
- **Browsers**: Firefox, Google Chrome, Opera
- **Security Tools**: KeePassXC, LocalSend, OpenVPN
- **Homebrew on Linux**: Optional Homebrew installation for additional packages
- **Interactive Configuration**: Git username and email setup
- **Automatic log generation**: Detailed installation logs

## Requirements

- Debian 10+ or Ubuntu 20.04+
- Terminal access
- Internet connection
- Sudo privileges

## Installation

Clone the repository:

```bash
git clone https://github.com/Victor-Zarzar/script-setup-debian
```

Navigate to the directory:

```bash
cd script-setup-debian
```

Make the script executable:

```bash
chmod +x setup_debian.sh
```

## Usage

Run the script:

```bash
./setup_debian.sh
```

The script will display an interactive menu with the following options:

1. Run complete setup
2. Update system
3. Setup Snapd
4. Setup directories
5. Install Git
6. Install text editors (VS Code, Sublime)
7. Install security tools
8. Install Python environment
9. Install Snap applications
10. Install Node.js tools
11. Install Docker
12. Install browsers
13. Install fonts
14. Install system tools
15. Install Flatpak applications
16. Install databases
17. Install Homebrew
18. Install Homebrew packages
19. Install Zsh
20. Configure Git
21. View installation log

## What Gets Installed

### Text Editors & IDEs
- **Visual Studio Code**: Installed via official Microsoft repository (not snap)
- **Sublime Text**: Modern text editor
- **Android Studio**: Android development IDE

### Shell & Terminal
- **Zsh**: Advanced shell
- **Zsh Autosuggestions**: Fish-like autosuggestions
- **Exa**: Modern replacement for ls
- **Nano**: Simple text editor

### Databases
- **SQLite**: Lightweight database
- **MySQL**: Relational database server

### Development Tools
- **Git**: Version control system
- **NPM**: Node package manager
- **PNPM**: Fast, disk space efficient package manager
- **Docker**: Container platform
- **Docker Compose V2**: Multi-container orchestration (manual plugin installation)
- **Nginx**: Web server
- **OpenSSH Server**: Secure shell server

### Python Tools
- **Python3-pip**: Python package installer
- **Python3-venv**: Virtual environment support
- **FastAPI**: Modern Python web framework
- **Uvicorn**: ASGI server
- **Alembic**: Database migration tool
- **Pyenv**: Python version manager

### Build Tools
- **CMake**: Cross-platform build system
- **Automake**: Build automation tool
- **Ninja**: Small build system
- **Clang**: C/C++ compiler

### Snap Applications
- **Communication**: Slack, WhatsApp, Telegram
- **Productivity**: Notion, Trello, Postman
- **AI Tools**: ChatGPT Desktop, DeepSeek Desktop
- **Entertainment**: Spotify
- **Browsers**: Firefox, Opera

### Flatpak Applications
- **LibreOffice**: Office suite
- **CPU-X**: System information tool
- **PDF Arranger**: PDF manipulation tool

### Browsers
- **Firefox**: Open source browser (snap)
- **Google Chrome**: Downloaded directly from Google
- **Opera**: Feature-rich browser (snap)

### Security & VPN
- **KeePassXC**: Password manager
- **LocalSend**: Local file sharing
- **OpenVPN**: VPN client
- **Network Manager OpenVPN**: VPN integration

### Utilities
- **KDE Spectacle**: Screenshot tool
- **Flatpak**: Universal package manager

### Fonts
- **JetBrains Mono**: Programming font with ligatures

### Homebrew Packages (Optional)
- **FVM**: Flutter Version Manager
- **Zsh Autosuggestions**: Via Homebrew
- **OpenJDK 21**: Java Development Kit
- **Pyenv**: Python version manager (alternative installation)

## Special Notes

### VS Code Installation
This script installs VS Code using the **official Microsoft repository**, not via snap. This provides:
- Better system integration
- Native file system access
- Extension compatibility
- Automatic updates via APT

### Docker Configuration
After Docker installation, you'll need to:
1. **Log out and log back in** for group changes to take effect
2. Test Docker with: `docker run hello-world`
3. Test Docker Compose V2 with: `docker compose version`

The script installs **Docker Compose V2** as a plugin (not the standalone version). Use commands like:
```bash
docker compose up
docker compose down
```

Note: The old `docker-compose` (with hyphen) command is not installed by this script.

### Zsh Setup
After installation, set Zsh as your default shell:
```bash
chsh -s $(which zsh)
```

### Pyenv Configuration
The script automatically adds Pyenv to your `.bashrc`. Restart your terminal or run:
```bash
source ~/.bashrc
```

## Interactive Configuration

During the setup, you'll be asked to provide:

- **Git Username**: Your name for Git commits
- **Git Email**: Your email for Git commits

## Safety

- The script creates a detailed log file in your home directory
- Each installation shows success/failure status
- You can run individual installations instead of full setup
- System logout/login recommended after full setup

## Log Files

Log files are automatically created with timestamp:

```
~/debian_setup_YYYYMMDD_HHMMSS.log
```

## Directory Structure

The script automatically creates:

```
~/Projects  # Main projects directory
```

## Post-Installation

After running the script:

1. **Log out and log back in** for group changes (Docker) to take effect
2. **Restart your terminal** for shell configuration changes
3. **Set Zsh as default** (optional): `chsh -s $(which zsh)`
4. **Configure Pyenv** to install Python versions: `pyenv install 3.11.0`
5. **Configure FVM** to install Flutter versions: `fvm install stable`
6. **Review the log file** for any errors or warnings

## Tips

- Run option **1** (Complete setup) for a fresh installation
- Use individual options to add specific tools later
- Check the log file if any installation fails
- Some snap apps may take time to appear in the menu after installation

## Troubleshooting

If you encounter issues:

1. **Check the log file** for detailed error messages
2. **Ensure internet connection** is stable
3. **Verify sudo access** is available
4. **Check disk space** availability
5. **Update package lists**: `sudo apt update`
6. **Snapd issues**: Restart with `sudo systemctl restart snapd`

### Common Issues

**Snap apps not appearing:**
```bash
sudo systemctl restart snapd
```

**Docker permission denied:**
```bash
# Log out and log back in, then test:
docker run hello-world
docker compose version
```

**Flatpak apps not installing:**
```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

## System Requirements

- **Debian**: 10 (Buster) or newer
- **Ubuntu**: 20.04 LTS or newer
- **Disk Space**: At least 10GB free
- **RAM**: Minimum 4GB recommended
- **Internet**: Stable connection required

## Package Managers Used

- **APT**: Primary package manager
- **Snap**: Cross-distribution packages
- **Flatpak**: Universal Linux packages
- **Homebrew**: Optional, for additional packages
- **NPM**: Node.js packages
- **Pip**: Python packages

## License

This project is open source and available under the MIT License.

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests.

## Author

Victor Zarzar

---

**Note**: This script is designed for personal use. Review the code before running and adjust according to your needs. Some packages may require additional configuration after installation.