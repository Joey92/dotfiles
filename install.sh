#!/bin/bash

#Setup script for Dotfiles
CWD=$(pwd)
arg=$1

function install_OhMyZsh {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

function install_Brew {
	/usr/local/bin/brew
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install $(< brew-packages)
	brew cask install $(< brew-cask-packages)
	# To install useful key bindings and fuzzy completion:
	$(brew --prefix)/opt/fzf/install
}

function install_Vundle {
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}

function backup {
	mv -iv ~/$1 ~/$1.old
}

function symlink {
	ln -sfnv $CWD/$1 ~/$1
}

function updateDotfile {
	echo -e "Backing up $1"
	backup $1
	echo -e "Adding symlinks ~/$1"
	symlink $1
}

function install_Scripts {
	FILES=$CWD/scripts/*
	for f in $FILES
	do
		ln -sfnv $f /usr/local/bin/$(basename $f)
	done
}

function install_PowerlineFont {
    # clone
    git clone https://github.com/powerline/fonts.git --depth=1
    # install
    cd fonts
    ./install.sh
    # clean-up a bit
    cd ..
    rm -rf fonts
}

echo -e "Setting up Dotfiles..."

if [[ "$arg" == "-i" || "$arg" == "--install" ]]; then
	echo -e "Select an option:"
	echo -e "  1) for Oh-My-Zsh"
	echo -e "  2) for brew install packages"
	echo -e "  3) for Vundle"
	echo -e "  4) for Scripts"
	echo -e "  5) for all"
	echo -e "  0) to Exit"

	read option

	case $option in

	"1")echo -e "Installing Oh-My-Zsh..."
	install_OhMyZsh
	;;

	
	"2")echo -e "Installing Brew packages..."
	install_Brew
	;;

	"3")echo -e "Installing Vundle..."
	install_Vundle
	;;

	"4")echo -e "Installing scripts..."
	install_Scripts
	;;

	"5")echo -e "Installing everything..."
	install_PowerlineFont
	install_Brew
	install_OhMyZsh
	install_Vundle
	install_Scripts
	;;

	"0")echo -e "Bye"
	exit 0
	;;

	*)echo -e "Invalid option entered."
	exit 1
	;;
	esac

	exit 0
fi

updateDotfile .fzf.zsh
updateDotfile .zshrc
updateDotfile .vimrc
updateDotfile .tmux.conf

echo -e "Done."

