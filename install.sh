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

    yay -S git
    yay -S curl
    yay -S unrar
    yay -S wget
    yay -S base-devel
    yay -S make
    yay -S ninja
    yay -S cmake
    yay -S clang
    yay -S visual-studio-code-bin
    yay -S google-chrome
    yay -S bat
    yay -S ripgrep
    yay -S fd
    yay -S tldr
    yay -S flameshot
    yay -S tmux
    yay -S astrill
    yay -S deepin-file-manager
    yay -S ncdu
    yay -S prettyping
    yay -S htop
    yay -S tree
    yay -S exa
    yay -S fzf
    yay -S yt-dlp
    yay -S vlc
    yay -S miniconda3
    yay -S autojump

    # Install input method
    yay -S fcitx
    yay -S fcitx-configtool
    yay -S fcitx-googlepinyin

    yay -S python3
    yay -S python-pip
    python3 -m pip install conan -i https://pypi.tuna.tsinghua.edu.cn/simple
}

InstallDebPackages() {
    sudo sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get autoremove
    sudo apt-get autoclean
    sudo apt-get clean

    sudo apt install git
    sudo apt install curl
    sudo apt install unrar
    sudo apt install wget
    sudo apt install build-essential
    sudo apt install make
    sudo apt install ninja-build
    sudo apt install cmake
    sudo apt install clang
    sudo apt install bat
    sudo apt install ripgrep
    sudo apt install tldr
    sudo apt install flameshot
    sudo apt install tmux
    sudo apt install astrill
    sudo apt install ncdu
    sudo apt install prettyping
    sudo apt install htop
    sudo apt install tree
    sudo apt install exa
    sudo apt install fzf
    sudo apt install yt-dlp
    sudo apt install vlc
    sudo apt install autojump

    # Install input method
    sudo apt install fcitx
    sudo apt install fcitx-googlepinyin

    sudo apt install python3
    sudo apt install python3-pip
    python -m pip install conan -i https://pypi.tuna.tsinghua.edu.cn/simple

    sudo snap install --classic code

    cd /tmp/

    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb

    wget https://github.com/sharkdp/fd/releases/download/v8.2.1/fd_8.2.1_amd64.deb
    sudo dpkg -i fd_8.2.1_amd64.deb

    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    sudo chmod +x Miniconda3-latest-Linux-x86_64.sh
    ./Miniconda3-latest-Linux-x86_64.sh -u
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
        yay -S zsh
    elif [[ -f /etc/debian_version ]]; then
        sudo apt install zsh
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
        yay -S neovim
    elif [[ -f /etc/debian_version ]]; then
        sudo apt install neovim
    else
        echo "Unsupported OS"
    fi


    rm -rf ${HOME}/.config/nvim

    git clone https://github.com/isqiwen/UNvChad.git ${HOME}/.config/nvim
}

CreateSymlinks() {
    for f in "$1"/* "$1"/.[^.]*; do
        if echo "$f" | egrep '.*\/?((\.){1,2}|.git|assets|README.md|install.sh|.dev|tags)$' > /dev/null; then
            continue
        fi
        if [[ -f $f ]]; then
            echo ""$HOME/$f" -> `realpath "$f"`"
            ln -sfn `realpath "$f"` "$HOME/$f"
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

    select action in "${items[@]}"
    do
        case $action in
            ${ACreateDirectories})
                CreateDirectories;;
            ${AInstallPackages})
                InstallPackages;;
            ${AInstallOhMyZsh})
                InstallOhMyZsh;;
            ${AInstallOhMyZshPlugins})
                InstallOhMyZshPlugins;;
            ${AInstallNeovim})
                InstallNeovim;;
            ${ACreateSymlinks})
                CreateSymlinks .;;
            ${AQuit})
                echo "You must log out of the system so that all changes take into effect."
                break;;
            *)
        esac
    done

}

Main
