#!/bin/bash

#Mengecek apakah zsh sudah terinstal
if ! command -v zsh &> /dev/null
then
    echo "Zsh tidak ditemukan, menginstal Zsh..."
    # Untuk Debian/Ubuntu-based images
    if [ -f /etc/debian_version ]; then
        apt-get update
        apt-get install -y zsh curl git wget
    # Untuk Alpine-based images
    elif [ -f /etc/alpine-release ]; then
        apk update
        apk add zsh curl git wget
    else
        echo "Distribusi sistem tidak dikenali, harap instal zsh secara manual."
        exit 1
    fi
fi

# Mengecek apakah oh-my-zsh sudah terinstal
rm -rf /home/devilbox/.oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh-My-Zsh belum terinstal, menginstal Oh-My-Zsh..."
    # Instalasi Oh-My-Zsh
    # sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    sudo -H -u devilbox bash -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
    sed -i -r 's/^plugins=\(.*?\)$/plugins=(laravel composer colorize git)/' /home/devilbox/.zshrc
    sed -i -r 's/^ZSH_THEME=.*$/ZSH_THEME="daveverwer"/' /home/devilbox/.zshrc

     echo '\n\
    bindkey "^[OB" down-line-or-search\n\
    bindkey "^[OC" forward-char\n\
    bindkey "^[OD" backward-char\n\
    bindkey "^[OF" end-of-line\n\
    bindkey "^[OH" beginning-of-line\n\
    bindkey "^[[1~" beginning-of-line\n\
    bindkey "^[[3~" delete-char\n\
    bindkey "^[[4~" end-of-line\n\
    bindkey "^[[5~" up-line-or-history\n\
    bindkey "^[[6~" down-line-or-history\n\
    bindkey "^?" backward-delete-char\n' >> /home/devilbox/.zshrc

    sh -c "git clone https://github.com/zsh-users/zsh-autosuggestions /home/devilbox/.oh-my-zsh/custom/plugins/zsh-autosuggestions" && \
    sed -i 's~plugins=(~plugins=(zsh-autosuggestions ~g' /home/devilbox/.zshrc && \
    sed -i '1iZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20' /home/devilbox/.zshrc && \
    sed -i '1iZSH_AUTOSUGGEST_STRATEGY=(history completion)' /home/devilbox/.zshrc && \
    sed -i '1iZSH_AUTOSUGGEST_USE_ASYNC=1' /home/devilbox/.zshrc && \
    sed -i '1iTERM=xterm-256color' /home/devilbox/.zshrc \

else
    echo "Oh-My-Zsh sudah terinstal!"
fi
echo "Instalasi Oh-My-Zsh selesai!"

echo "Running supervisord php-fpm"
/usr/bin/supervisord -n
