#!/bin/bash
# For setting up my mac

# Check if bash is the main shell
if [[ $SHELL == /bin/bash ]]; then
    echo $SHELL
else
    chsh -s /bin/bash
fi

# Things to be installed
brewPackages=(emacs python thefuck git htop docker erlang ocaml opam)
brewCasks=(visual-studio-code firefox)

# Check homebrew installer is available
if command -v xcode-select >/dev/null 2>&1; then
    echo "xcode-select already installed"
else
    echo "xcode-select not found"
    xcode-select --install
fi

if command -v brew >/dev/null 2>&1; then
    echo "brew already installed"
else
    echo "brew not found"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Doing installation
for i in "${brewPackages[@]}"; do
    if brew ls --versions $i > /dev/null; then
        brew upgrade $i
    else
        brew install $i
    fi
done

for i in "${brewCasks[@]}"; do
    if brew cask ls --versions $i > /dev/null; then
        true
    else
        brew cask install $i
    fi
done
brew cask upgrade

# Set up symlinks
CodeSettings=$PWD/settings.json
ln -sf $CodeSettings ~/Library/Application\ Support/Code/User
echo Created VScode settings link

BashSettings=$PWD/.bashrc
ln -sf $BashSettings ~
echo Created Bash settings link

GitSettings=$PWD/.gitconfig
ln -sf $GitSettings ~
echo Created Git settings link