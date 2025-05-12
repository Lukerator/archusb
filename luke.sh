#!/bin/bash
set -e

# Create necessary directories
mkdir -p /home/luke/.config/zsh/antidote

# Set ZDOTDIR by adding it to .zshenv
echo "export ZDOTDIR=/home/luke/.config/zsh" > /home/luke/.zshenv

# Create .zshrc
echo "# Source Antidote" > /home/luke/.config/zsh/.zshrc
echo "source \$ZDOTDIR/antidote/antidote.zsh" >> /home/luke/.config/zsh/.zshrc
echo "antidote load" >> /home/luke/.config/zsh/.zshrc
echo "" >> /home/luke/.config/zsh/.zshrc
echo "# Set prompt" >> /home/luke/.config/zsh/.zshrc
echo "PROMPT='%F{cyan}%~%f %(?.%F{green}%(#.root.%F{red}⟼%f.%F{green}➜%f)%f.%F{red}⟼%f.%F{green}➜%f)%f '" >> /home/luke/.config/zsh/.zshrc
echo "" >> /home/luke/.config/zsh/.zshrc
echo "# Bindings for history" >> /home/luke/.config/zsh/.zshrc
echo "bindkey '^[[A' history-substring-search-up" >> /home/luke/.config/zsh/.zshrc
echo "bindkey '^[[B' history-substring-search-down" >> /home/luke/.config/zsh/.zshrc
echo "" >> /home/luke/.config/zsh/.zshrc
echo "# Enable history" >> /home/luke/.config/zsh/.zshrc
echo "HISTFILE=\$ZDOTDIR/.zshist" >> /home/luke/.config/zsh/.zshist
echo "HISTSIZE=5000" >> /home/luke/.config/zsh/.zshist
echo "SAVEHIST=5000" >> /home/luke/.config/zsh/.zshist
echo "setopt HIST_IGNORE_DUPS" >> /home/luke/.config/zsh/.zshrc
echo "" >> /home/luke/.config/zsh/.zshrc
echo "# Enable completion for doas" >> /home/luke/.config/zsh/.zshrc
echo "autoload -Uz compinit && compinit -f" >> /home/luke/.config/zsh/.zshrc
echo "compdef doas=sudo" >> /home/luke/.config/zsh/.zshrc
echo "" >> /home/luke/.config/zsh/.zshrc
echo "# Aliases" >> /home/luke/.config/zsh/.zshrc
echo "alias grep='grep --color=auto'" >> /home/luke/.config/zsh/.zshrc

# Create .zsh_plugins.txt for Antidote
echo "zsh-users/zsh-autosuggestions" > /home/luke/.config/zsh/.zsh_plugins.txt
echo "zsh-users/zsh-substring-history-search" >> /home/luke/.config/zsh/.zsh_plugins.txt
echo "zdharma-continuum/fast-syntax-highlighting kind:defer" >> /home/luke/.config/zsh/.zsh_plugins.txt

# Clone antidote repo
git clone --depth 1 https://github.com/mattmc3/antidote.git /home/luke/.config/zsh/antidote

# Install Chaotic-AUR
doas pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
doas pacman-key --lsign-key 3056513887B78AEB

doas pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
doas pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

doas echo "" > /etc/pacman.conf
doas echo "[chaotic-aur]" > /etc/pacman.conf
doas echo "Include = /etc/pacman.d/chaotic-mirrorlist" > /etc/pacman.conf

# Install paru
mkdir ~/.config/paru
echo "[options]" > ~/.config/paru/paru.conf
echo "BottomUp" > ~/.config/paru/paru.conf
echo "CleanAfter" > ~/.config/paru/paru.conf
echo "" > ~/.config/paru/paru.conf
echo "[bin]" > ~/.config/paru/paru.conf
echo "Sudo = doas" > ~/.config/paru/paru.conf
doas pacman --noconfirm -S paru

# Clean up bash files and cache
rm -rf ~/.bash* ~/.cache

doas nvim /etc/refind_linux.conf