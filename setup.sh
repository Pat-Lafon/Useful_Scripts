#!/bin/bash
# For setting up my mac

# Check if bash is the main shell
if [[ $SHELL == /bin/bash ]]; then
    echo "$SHELL"
else
    chsh -s /bin/bash
fi

# Things to be installed
brewPackages=(emacs python thefuck git htop docker erlang ocaml dune opam bash rebar3 gcc ccat mdcat starship hyperfine shellcheck yarn cmake clang-format)
brewCasks=(visual-studio-code adoptopenjdk8 firefox mactex java slack spotify zulip krita selfcontrol winds)
codeExtensions=(bmuskalla.vscode-tldr \
                DavidAnson.vscode-markdownlint \
                devine-davies.make-hidden \
                freebroccolo.reasonml \
                geoffkaile.latex-count \
                hiro-sun.vscode-emacs \
                James-Yu.latex-workshop \
                maelvalais.dune \
                mattn.Lisp \
                ms-python.python \
                ms-vscode-remote.remote-ssh \
                ms-vscode-remote.remote-ssh-edit \
                ms-vscode.cpptools \
                ms-vscode.wordcount \
                pgourlain.erlang \
                redhat.java \
                ritwickdey.LiveServer \
                rust-lang.rust \
                streetsidesoftware.code-spell-checker \
                VisualStudioExptTeam.vscodeintellicode \
                timonwong.shellcheck \
                vscjava.vscode-java-debug \
                vscjava.vscode-java-dependency \
                vscjava.vscode-java-pack \
                vscjava.vscode-java-test \
                wayou.vscode-todo-highlight \
                xaver.clang-format)

# Check if xcode is installed on mac
if [ "$(uname)" == "Darwin" ]; then
    if command -v xcode-select >/dev/null 2>&1; then
        echo "xcode-select already installed"
    else
        echo "xcode-select not found"
        xcode-select --install
    fi
fi

# Check homebrew installer is available
if command -v brew >/dev/null 2>&1; then
    echo "brew already installed"
else
    echo "brew not found"
    if [ "$(uname)" == "Darwin" ]; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    fi
    if [[ -d ~/.linuxbrew ]]; then
        eval "$(/home/pwl45/.linuxbrew/bin/brew shellenv)"
    fi
fi

# Install brew bottles
for i in "${brewPackages[@]}"; do
    if brew ls --versions "$i" > /dev/null; then
        echo "$i" was already installed
    else
        brew install "$i"
    fi
done
brew upgrade

# Install brew casks, only available on mac
if [ "$(uname)" == "Darwin" ]; then
    for i in "${brewCasks[@]}"; do
        if brew cask ls --versions "$i" > /dev/null; then
            echo "$i" was already installed
        else
            brew cask install "$i"
        fi
    done
    brew cask upgrade
fi

if command -v code >/dev/null 2>&1; then
    currentExtensions="code --list-extensions"
    for i in "${codeExtensions[@]}"; do
        if $currentExtensions|grep "$i" >/dev/null 2>&1; then
            echo "$i" is already installed for VScode
        else
            code --install-extension "$i"
        fi
    done
else
    echo "VScode was not installed so we won't do extensions"
fi

chmod +x link.sh
./link.sh
