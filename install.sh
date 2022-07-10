#!/usr/bin/env bash

CreateDirectories() {
    echo "Creating Downloads/YouTube,Documents,Work,Sources,Dev,Org,Work,Pictures/Screenshots"
    mkdir -pv ~/{Downloads/YouTube,Documents,Work,Sources,Dev,Org,Work,Pictures/Screenshots,OneDrive}/
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
    yay -S cmake
    yay -S visual-studio-code-insiders-bin
    yay -S google-chrome
    yay -S bat
    yay -S ripgrep
    yay -S fd
    yay -S tldr
    yay -S wezterm
    yay -S flameshot
    yay -S tmux
    yay -S astrill
    yay -S deepin-file-manager
    yay -S ncdu
    yay -S prettyping
    yay -S exa
    yay -S yt-dlp
    yay -S vlc
    yay -S miniconda3
    yay -S onedriver

    # Install input method
    yay -S fcitx
    yay -S fcitx-configtool
    yay -S fcitx-googlepinyin

    # fonts
    yay -S ttf-fira-code
    yay -S nerd-fonts-hermit
    yay -S ttf-cascadia-code
    fc-cache -fv

    # ruby
    yay -S ruby
    gem install webrick
}

InstallDebPackages() {
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install $(grep -vE "^\s*#" ~/dotfiles/packages.deb.txt  | tr "\n" " ")
    sudo apt-get autoremove
    sudo apt-get autoclean
    sudo apt-get clean

    cd /tmp/

    wget https://github.com/sharkdp/bat/releases/download/v0.18.1/bat-musl_0.18.1_amd64.deb
    sudo dpkg -i bat-musl_0.18.1_amd64.deb

    wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
    sudo dpkg -i ripgrep_13.0.0_amd64.deb

    wget https://github.com/sharkdp/fd/releases/download/v8.2.1/fd_8.2.1_amd64.deb
    sudo dpkg -i fd_8.2.1_amd64.deb
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
    yay -S fzf

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
    yay -S neovim

    rm -rf ${HOME}/.config/nvim

    git clone https://github.com/isqiwen/UNvChad.git ${HOME}/.config/nvim
}

CreateSymlinks() {
    for f in "$1"/* "$1"/.[^.]*; do
        if echo "$f" | egrep '.*\/?((\.){1,2}|.git|assets|README.md|install.sh|matlab_install.sh|matlab_crack.sh|tags)$' > /dev/null; then
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
