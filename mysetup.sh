#!/bin/bash

# Check if sudo (shouldn't be)
[ "$(id -u)" -eq 0 ] && printf "This script must NOT be run using sudo!\n" && exit 1

# Generic dependency checking function. Requires (only) one parameter.
function check_dependency {
    if [[ $# != 1 ]]; then
        echo "Error: function check_dependency requires (only) one parameter. Aborting."
        exit 1
    fi
    command -v $1 >/dev/null 2>&1 || { echo "I require $1 but it's not installed.  Aborting." >&2; exit 1; }
}

current_install_string="fish"
printf "\n======| Do you want to install $current_install_string? ([yes]/no)\n"
read user_input
if [[ $user_input == "" || $user_input == "yes" ]]; then
    printf "======| Installing $current_install_string...\n"
    check_dependency curl
    check_dependency gpg
    check_dependency apt
    if [[ $(cat /etc/debian_version) == "10"* ]]; then # debian 10
            echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
            curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
    elif [[ $(cat /etc/debian_version) == "11"* ]]; then # debian 11
            echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_11/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
            curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_11/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
    else # ubuntu
            sudo apt-add-repository ppa:fish-shell/release-3
    fi
    sudo apt update
    sudo apt install fish
else
    printf "======| Skipping $current_install_string installation...\n"
fi

current_install_string="fisher + pure theme + colored man pages"
printf "\n======| Do you want to install $current_install_string? ([yes]/no)\n"
read user_input
if [[ $user_input == "" || $user_input == "yes" ]]; then
    printf "======| Installing $current_install_string...\n"
    check_dependency fish
    check_dependency curl
    fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
    fish -c "fisher install pure-fish/pure"
    fish -c "fisher install decors/fish-colored-man"
    # Set syntax highlighting variables
    fish -c "set -U fish_color_command 0087ff"
    fish -c "set -U fish_color_quote ffd700"
    fish -c "set -U fish_color_redirection 00d7af"
    fish -c "set -U fish_color_end 00d75f"
    fish -c "set -U fish_color_error ff005f"
    fish -c "set -U fish_color_param 00d7ff"
    fish -c "set -U fish_color_comment 808080"
    fish -c "set -U fish_color_autosuggestion 949494"
else
    printf "======| Skipping $current_install_string installation...\n"
fi

current_install_string="fzf"
printf "\n======| Do you want to install $current_install_string? ([yes]/no)\n"
read user_input
if [[ $user_input == "" || $user_input == "yes" ]]; then
    printf "======| Installing $current_install_string...\n"
    check_dependency git
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
else
    printf "======| Skipping $current_install_string installation...\n"
fi

current_install_string="micro"
printf "\n======| Do you want to install $current_install_string? ([yes]/no)\n"
read user_input
if [[ $user_input == "" || $user_input == "yes" ]]; then
    printf "======| Installing $current_install_string...\n"
    check_dependency curl
    check_dependency apt
    curl https://getmic.ro | sudo bash
    sudo mv micro /usr/bin
    sudo apt install xclip
else
    printf "======| Skipping $current_install_string installation...\n"
fi

current_install_string="grc and ll config"
printf "\n======| Do you want to install $current_install_string? ([yes]/no)\n"
read user_input
if [[ $user_input == "" || $user_input == "yes" ]]; then
    printf "======| Installing $current_install_string...\n"
    check_dependency apt
    sudo apt install grc
    fish -c "fisher install orefalo/grc"
    sudo sed -i 's/ls -lh $argv/ls -lh --group-directories-first $argv/g' /usr/share/fish/functions/ll.fish
    sudo sed -i 's/ls -lAh $argv/ls -lAh --group-directories-first $argv/g' /usr/share/fish/functions/la.fish
else
    printf "======| Skipping $current_install_string installation...\n"
fi

current_install_string="audio power save fix + scripts"
printf "\n======| Do you want to install $current_install_string? (yes/[no])\n"
read user_input
if [[ $user_input == "yes" ]]; then
    printf "======| Installing $current_install_string...\n"
    # power save fix
    sudo sh -c 'echo "options snd_hda_intel power_save=0" > /etc/modprobe.d/audio-power_save.conf'
    # copy scripts + install notification system
    mkdir ~/scripts
    cp ./scripts/audio_input_mute_toggle.sh ~/scripts/audio_input_mute_toggle.sh
    cp ./scripts/audio_output_toggle.sh ~/scripts/audio_output_toggle.sh
    sudo apt install libnotify-bin
else
    printf "======| Skipping $current_install_string installation...\n"
fi

printf "\n======| End of installation.\n"
