import subprocess

def run_command(command):
    try:
        print(f"🔹 Executando: {command}")
        subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"❌ Erro ao executar {command}: {e}")

commands = [
    "sudo apt update",
    "sudo apt upgrade -y",
    "sudo apt install git",
    "sudo snap install sublime-text --classic",
    "sudo snap install code --classic",  
    "sudo apt install -y keepassxc",
    "sudo snap install localsend",
    "sudo apt install -y python3-pip python3-venv",
    "pip3 install fastapi uvicorn",
    "curl https://pyenv.run | bash",
    "sudo snap install postman",
    "sudo apt install -y snapd",
    "sudo systemctl enable --now snapd.socket",
    "sudo ln -s /var/lib/snapd/snap /snap",
    "sudo snap install chatgpt-desktop",
    "sudo snap install notion-snap-reborn",
    "sudo snap install trello-desktop",
    "sudo snap install whatsapp-for-linux",
    "sudo snap install deepseek-desktop",
    "sudo snap install android-studio --classic",
    "sudo apt install -y flatpak npm",
    "sudo npm install -g pnpm",
    "sudo apt install -y docker.io docker-compose",
    "sudo groupadd docker || true",
    "sudo usermod -aG docker $USER",
    "sudo systemctl enable docker.service",
    "sudo systemctl enable containerd.service",
    "sudo snap install firefox",
    "wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb && sudo apt install -y /tmp/chrome.deb",
    "sudo snap install opera",
    "sudo snap install spotify",
    "sudo snap install slack --classic",
    "sudo apt install -y fonts-jetbrains-mono",
    "sudo apt install -y nginx openssh-server",
    "sudo apt install -y nano exa",
    "sudo apt install -y network-manager-openvpn openvpn",
    "sudo apt install -y kde-spectacle",
    "sudo apt install -y cmake automake ninja-build clang",
    "flatpak install -y flathub org.libreoffice.LibreOffice",
    "flatpak install -y flathub io.github.thetumultuousunicornofdarkness.cpu-x",
    "flatpak install -y flathub com.github.jeromerobert.pdfarranger",
    "mkdir -p ~/Projects",
    "git config --global user.name 'victorzarzar'",
    "git config --global user.email 'victor@example.com'",
    "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"",
    "echo 'eval \"$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"' >> ~/.bashrc",
    "eval \"$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"",
    "brew tap leoafarias/fvm",
    "brew install fvm",
    "brew install zsh-autosuggestions",
    "brew install openjdk@21",
    "sudo apt install -y sqlite3 mysql-server",
    "sudo apt install -y zsh",
]

for cmd in commands:
    run_command(cmd)

print("\n✅ Configuração concluída! Reinicie para aplicar todas as mudanças.")
