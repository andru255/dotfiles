#!/bin/bash
#Script to install emacs 24.5 from the emacs mirror hosted in github

version="emacs-24.5"
url="https://github.com/emacs-mirror/emacs/tarball/$version"
uninstall_flag=$1

function main {
    if [[ $uninstall_flag == "--uninstall" ]]; then
        uninstall_emacs
    else
        install_dependencies
        install_emacs
        install_success
    fi
}

function install_dependencies {
    sudo apt-get install build-essential \
         texinfo libx11-dev libxpm-dev libjpeg-dev libpng-dev \
         libgif-dev libtiff-dev libgtk2.0-dev libncurses-dev \
         autoconf automake
}

function install_emacs {
    echo "Go $HOME"
    cd $HOME

    echo "Creating the emacs folder..."
    mkdir emacs

    echo "Go to the created emacs folder..."
    cd $HOME/emacs

    echo "Invoque and untar from the mirror hosted in github"
    echo $url
    curl -o emacs-$version.tar.gz -L $url 

    info_tar=$(tar -axvf emacs-$version.tar.gz)
    
    echo "info_tar: $info_tar"

    tmp_folder=$(echo $info_tar | cut -f1 -d" ")

    echo "Go to $tmp_folder folder"
    cd $tmp_folder

    echo "Executing the autogen.sh"
    ./autogen.sh

    echo "Executing the default settings"
    ./configure

    echo "Making the installer"
    make

    echo "Execute the installer with superuser mode, "
    echo "basically the binary copy to the path /usr/local/bin"
    sudo make install

    echo "done!"
}

function uninstall_emacs {
    read -p "Are you sure to uninstall emacs? (y/n)" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Go to source folder"
        cd "$HOME/emacs/emacs-$version"
        echo "uninstalling..."
        sudo make uninstall
        cd $HOME
        sudo rm -fr "$HOME/emacs/emacs-$version"
        echo "done."
    else
        exit 1
    fi
}

function install_success {
    echo "emacs has been successfully installed :D"
    emacs --version
}

main
