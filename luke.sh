#!/bin/sh
set -e

mkdir -p ~/.config/paru

echo "[options]" > ~/.config/paru/paru.conf
echo "BottomUp" >> ~/.config/paru/paru.conf
echo "CleanAfter" >> ~/.config/paru/paru.conf
echo "" >> ~/.config/paru/paru.conf
echo "[bin]" >> ~/.config/paru/paru.conf
echo "Sudo = doas" >> ~/.config/paru/paru.conf

rm -rf ~/.bash* ~/.cache
