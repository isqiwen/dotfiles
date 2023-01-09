#!/usr/bin/env bash

set -e

CreateDirectories() {
    echo "Creating Downloads,Documents,Pictures/Screenshots,workspace"
    mkdir -pv ~/{Downloads,Documents,Pictures/Screenshots,workspace}/
}

InstallArchPackages() {
    # Force to refresh download fresh package databases from the server even if up to date.
    sudo pacman -Syy

    # Change to a fast download server, depending on your physical location.
    sudo pacman-mirrors -i -c China -m rank

    # Force to upgrade all installed packages
    sudo pacman -Syyu

    sudo pacman -S yay

    yay -Sy --needed git
    yay -Sy --needed curl
    yay -Sy --needed unrar
    yay -Sy --needed wget
    yay -Sy --needed base-devel
    yay -Sy --needed make
    yay -Sy --needed ninja
    yay -Sy --needed cmake
    yay -Sy --needed clang
    yay -Sy --needed visual-studio-code-bin
    yay -Sy --needed google-chrome
    yay -Sy --needed bat
    yay -Sy --needed ripgrep
    yay -Sy --needed fd
    yay -Sy --needed tldr
    yay -Sy --needed flameshot
    yay -Sy --needed tmux
    yay -Sy --needed astrill
    yay -Sy --needed deepin-file-manager
    yay -Sy --needed ncdu
    yay -Sy --needed prettyping
    yay -Sy --needed htop
    yay -Sy --needed tree
    yay -Sy --needed exa
    yay -Sy --needed fzf
    yay -Sy --needed yt-dlp
    yay -Sy --needed vlc
    yay -Sy --needed miniconda3
    yay -Sy --needed autojump
    yay -Sy --needed gperftools
    yay -Sy --needed libunwind
    yay -Sy --needed neofetch
    yay -Sy --needed proxychains

    # Install input method
    yay -Sy --needed fcitx
    yay -Sy --needed fcitx-configtool
    yay -Sy --needed fcitx-googlepinyin

    yay -Sy --needed python3
    yay -Sy --needed python-pip
    python3 -m pip install conan -i https://pypi.tuna.tsinghua.edu.cn/simple
}

InstallDebPackages() {
    sudo sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get autoremove
    sudo apt-get autoclean
    sudo apt-get clean

    sudo apt install -y git
    sudo apt install -y curl
    sudo apt install -y unrar
    sudo apt install -y wget
    sudo apt install -y build-essential
    sudo apt install -y make
    sudo apt install -y ninja-build
    sudo apt install -y cmake
    sudo apt install -y clang
    sudo apt install -y bat
    sudo apt install -y ripgrep
    sudo apt install -y tldr
    sudo apt install -y flameshot
    sudo apt install -y tmux
    sudo apt install -y astrill
    sudo apt install -y ncdu
    sudo apt install -y prettyping
    sudo apt install -y htop
    sudo apt install -y tree
    sudo apt install -y exa
    sudo apt install -y fzf
    sudo apt install -y yt-dlp
    sudo apt install -y vlc
    sudo apt install -y autojump
    sudo apt install -y libgoogle-perftools-dev
    sudo apt install -y google-perftools
    sudo apt install -y libunwind-dev
    sudo apt install -y golang-github-google-pprof-dev
    sudo apt install -y gnome-tweaks
    sudo apt install -y neofetch
    sudo apt install -y proxychains

    sudo apt install -y python3
    sudo apt install -y python3-pip
    python3 -m pip install conan -i https://pypi.tuna.tsinghua.edu.cn/simple

    cd /tmp/

    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb

    wget https://github.com/sharkdp/fd/releases/download/v8.2.1/fd_8.2.1_amd64.deb
    sudo dpkg -i fd_8.2.1_amd64.deb

    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    sudo chmod +x Miniconda3-latest-Linux-x86_64.sh
    ./Miniconda3-latest-Linux-x86_64.sh
}

InstallPackages() {
    echo "Installing packages"

    if [[ -f /etc/arch-release ]]; then
        InstallArchPackages
    elif [[ -f /etc/debian_version ]]; then
        InstallDebPackages
    else
        echo "Unsupported OS"
    fi
}

InstallOhMyZsh() {
    echo "Installing ohmyzsh"

    if [[ -f /etc/arch-release ]]; then
        yay -Sy --needed zsh
    elif [[ -f /etc/debian_version ]]; then
        sudo apt install -y zsh
    else
        echo "Unsupported OS"
    fi

    chsh -s $(which zsh)

    # Check for Oh My Zsh and install if we don't have it
    if [ -d ~/.oh-my-zsh ]; then
        echo "oh-my-zsh is installed"
        sh ${HOME}/.oh-my-zsh/tools/uninstall.sh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
    else
        echo "oh-my-zsh is not installed"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
    fi
}

InstallOhMyZshPlugins() {
    echo "Installing ohmyzsh plugins"

    if [ ! -d ~/.oh-my-zsh ]; then
        echo "oh-my-zsh is not installed, please install ohmyzsh first"
        exit 0
    fi

    rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate
    git clone https://github.com/wfxr/forgit ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/forgit
    git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
}

InstallNeovim() {
    if [[ -f /etc/arch-release ]]; then
        yay -Sy --needed neovim
    elif [[ -f /etc/debian_version ]]; then
        sudo apt install -y neovim
    else
        echo "Unsupported OS"
    fi

    rm -rf ${HOME}/.config/nvim

    git clone https://github.com/isqiwen/UNvChad.git ${HOME}/.config/nvim
}

CreateSymlinks() {
    for f in "$1"/* "$1"/.[^.]*; do
        if echo "$f" | egrep '.*\/?((\.){1,2}|.git|assets|README.md|install.sh|.dev|tags)$' >/dev/null; then
            continue
        fi
        if [[ -f $f ]]; then
            echo ""$HOME/$f" -> $(realpath "$f")"
            ln -sfn $(realpath "$f") "$HOME/$f"
        fi
        if [[ -d $f ]]; then
            mkdir -p "$HOME"/"$f"
            CreateSymlinks "$f"
        fi
    done
}

Main() {

    echo "######################################"
    echo "      Setting up your linux...        "
    echo "######################################"

    echo "                                      "
    echo "      Select your action:             "
    echo "                                      "

    ACreateDirectories="CreateDirectories"
    AInstallPackages="InstallPackages"
    AInstallOhMyZsh="InstallOhMyZsh"
    AInstallOhMyZshPlugins="InstallOhMyZshPlugins"
    AInstallNeovim="InstallNeovim"
    ACreateSymlinks="CreateSymlinks"
    AQuit="Quit"

    items=(${ACreateDirectories} ${AInstallPackages} ${AInstallOhMyZsh} ${AInstallOhMyZshPlugins} ${AInstallNeovim} ${ACreateSymlinks} ${AQuit})

    select action in "${items[@]}"; do
        case $action in
        ${ACreateDirectories})
            CreateDirectories
            ;;
        ${AInstallPackages})
            InstallPackages
            ;;
        ${AInstallOhMyZsh})
            InstallOhMyZsh
            ;;
        ${AInstallOhMyZshPlugins})
            InstallOhMyZshPlugins
            ;;
        ${AInstallNeovim})
            InstallNeovim
            ;;
        ${ACreateSymlinks})
            CreateSymlinks .
            ;;
        ${AQuit})
            echo "You must log out of the system so that all changes take into effect."
            break
            ;;
        *) ;;
        esac
    done

}

Main
