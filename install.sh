#!/bin/bash

#Setup script for Dotfiles
CWD=$(pwd)
arg=$1

echo -e "Setting up Dotfiles..."

if [[ "$arg" == "-i" || "$arg" == "--install" ]]; then
	echo -e "Select an option:"
	echo -e "  1) for Oh-My-Zsh"
	echo -e "  3) for Vundle"
	echo -e "  0) to Exit"

	read option

	case $option in

	"1")echo -e "Installing Oh-My-Zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	;;

	"3")echo -e "Installing Vundle..."
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	;;

	"0")echo -e "Bye"
	exit 0
	;;

	*)echo -e "Invalid option entered."
	exit 1
	;;
	esac

	exit 0
	# brew install $(< brew-packages)	
fi

echo -e "Backing up old files"
mv -iv ~/.zshrc ~/.zshrc.old
mv -iv ~/.vimrc ~/.vimrc.old
mv -iv ~/.tmux.conf ~/.tmux.conf.old
mv -iv ~/.gitconfig ~/.gitconfig.old

echo -e "Adding symlinks..."
ln -sfnv $CWD/.zshrc ~/.zshrc
ln -sfnv $CWD/.vimrc ~/.vimrc
ln -sfnv $CWD/.tmux.conf ~/.tmux.conf
ln -sfnv $CWD/.gitconfig ~/.gitconfig

echo -e "Done."

