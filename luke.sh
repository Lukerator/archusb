#!/bin/bash
set -e

# Create necessary directories
mkdir -p /home/luke/.config/zsh/antidote

# Set ZDOTDIR by adding it to .zshenv
echo "ZDOTDIR=/home/luke/.config/zsh" > /home/luke/.zshenv

# Create .zshrc
echo "# Source Antidote" > /home/luke/.config/zsh/.zshrc
echo "source \$ZDOTDIR/antidote/antidote.zsh" >> /home/luke/.config/zsh/.zshrc
echo "antidote load" >> /home/luke/.config/zsh/.zshrc
echo "" >> /home/luke/.config/zsh/.zshrc
echo "# Set prompt" >> /home/luke/.config/zsh/.zshrc
echo "PROMPT='%F{cyan}%~%f %(?.%F{green}%(#.➼.➜)%f.%F{red}%(#.➼.➜)%f) '" >> /home/luke/.config/zsh/.zshrc
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
echo "zsh-users/zsh-history-substring-search" >> /home/luke/.config/zsh/.zsh_plugins.txt
echo "zdharma-continuum/fast-syntax-highlighting kind:defer" >> /home/luke/.config/zsh/.zsh_plugins.txt

# Clone antidote repo
git clone --depth 1 https://github.com/mattmc3/antidote.git /home/luke/.config/zsh/antidote

# Install paru
mkdir -p ~/.config/paru/tmp
rm -rf ~/.config/paru/tmp
echo "[options]" > ~/.config/paru/paru.conf
echo "BottomUp" >> ~/.config/paru/paru.conf
echo "CleanAfter" >> ~/.config/paru/paru.conf
echo "" >> ~/.config/paru/paru.conf
echo "[bin]" >> ~/.config/paru/paru.conf
echo "Sudo = doas" >> ~/.config/paru/paru.conf

# Clean up bash files and cache
rm -rf ~/.bash* ~/.cache

echo "Edit refind_linux.conf if needed. Add 'root=LABEL=ROOT rw splash'"
doas nvim /boot/refind_linux.conf