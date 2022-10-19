#!/bin/bash

# Check if sudo (shouldn't be)
[ "$(id -u)" -eq 0 ] && printf "This script must NOT be run using sudo!\n" && exit 1

printf "======| Initializing setup.. don't look away, I need you to answer some questions.. \n"

# ========================================
# FUNCTIONS
# ========================================

# Generic dependency checking function. Requires (only) one parameter.
function check_dependency {
    if [[ $# != 1 ]]; then
        echo "Error: function check_dependency requires (only) one parameter. Aborting."
        exit 1
    fi
    command -v $1 >/dev/null 2>&1 || { echo "I require $1 but it's not installed.  Aborting." >&2; exit 1; }
}

# Ask user if $1 should be installed (default option yes)
function check_if_install_yes {
    local current_install_string=$1
    printf "\n======| Do you want to install $current_install_string? ([y]/n)\n"
    read user_input
    if [[ $user_input == "" || $user_input == "y" ]]; then
        printf "======| Installing $current_install_string...\n"
        return 0
    else
        printf "Skipping $current_install_string installation...\n"
        return 1
    fi
}

# Ask user if $1 should be installed (default option no)
function check_if_install_no {
    local current_install_string=$1
    printf "\n======| Do you want to install $current_install_string? (y/[n])\n"
    read user_input
    if [[ $user_input == "y" ]]; then
        printf "======| Installing $current_install_string...\n"
        return 0
    else
        printf "Skipping $current_install_string installation...\n"
        return 1
    fi
}

# ========================================
# VARIABLES
# ========================================

base_dir=$(cd "$(dirname "$0")"; pwd -P) 
machine=$(uname -s)

# ========================================
# RUN
# ========================================

if check_if_install_yes "fish"; then
    if [[ $machine == "Linux" ]]; then
        check_dependency apt-get
        if [[ $(cat /etc/debian_version) == "10"* ]]; then # debian 10
            check_dependency curl
            check_dependency gpg
            echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
            curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
        elif [[ $(cat /etc/debian_version) == "11"* ]]; then # debian 11
            check_dependency curl
            check_dependency gpg
            echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_11/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
            curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_11/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
        else # ubuntu
            sudo apt-add-repository ppa:fish-shell/release-3
        fi
        sudo apt-get update && sudo apt-get install --no-install-recommends --yes fish
    elif [[ $machine == "Darwin" ]]; then # macOS
        check_dependency brew
        brew install fish
    else
        echo "Not linux or macOS. Aborting." && exit 1
    fi
fi

if check_if_install_yes "fisher + pure theme + colored man pages + fish colors"; then
    check_dependency fish
    check_dependency curl
    fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
    fish -c "fisher install pure-fish/pure"
    fish -c "fisher install decors/fish-colored-man"
    # fish colors: Set syntax highlighting variables
    fish -c "set -U fish_color_command 0087ff;
        set -U fish_color_quote ffd700;
        set -U fish_color_redirection 00d7af;
        set -U fish_color_end 00d75f;
        set -U fish_color_error ff005f;
        set -U fish_color_param 00d7ff;
        set -U fish_color_comment 808080;
        set -U fish_color_autosuggestion 949494"
fi

if check_if_install_yes "fzf"; then
    check_dependency git
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

if check_if_install_yes "micro"; then
    if [[ $machine == "Linux" ]]; then
        check_dependency curl
        curl https://getmic.ro | sudo bash
        sudo mv micro /usr/bin
        # If X server is running install xclip
        if timeout 1s xset q &>/dev/null; then
            check_dependency apt-get
            sudo apt-get update && sudo apt-get install --no-install-recommends --yes xclip
        fi
    elif [[ $machine == "Darwin" ]]; then # macOS
        check_dependency brew
        arch -arm64 brew install micro
    else
        echo "Not linux or macOS. Aborting." && exit 1
    fi
fi

if check_if_install_yes "grc and fish functions (ll;la;apt)"; then
    check_dependency fish
    rm ~/.config/fish/functions/ll.fish
    rm ~/.config/fish/functions/la.fish
    cp $(fish -c "type -p ll") ~/.config/fish/functions/
    cp $(fish -c "type -p la") ~/.config/fish/functions/
    if [[ $machine == "Linux" ]]; then
        check_dependency apt-get
        sudo apt-get update && sudo apt-get install --no-install-recommends --yes grc
        cp $base_dir/config_files/fish_functions/apt-update-upgrade-autoremove-clean.fish ~/.config/fish/functions/
        fish -c "fisher install orefalo/grc"
        sed -i 's/ls -lh $argv/ls -lh --group-directories-first $argv/g' ~/.config/fish/functions/ll.fish
        sed -i 's/ls -lAh $argv/ls -lAh --group-directories-first $argv/g' ~/.config/fish/functions/la.fish
    elif [[ $machine == "Darwin" ]]; then # macOS
        check_dependency brew
        arch -arm64 brew install grc
        brew install coreutils
        arch -arm64 brew install gnu-sed
        fish -c "fisher install usami-k/gls"
        fish -c "fisher install orefalo/grc"
        gsed -i 's/ls -lh $argv/gls -lh --group-directories-first $argv/g' ~/.config/fish/functions/ll.fish
        gsed -i 's/ls -lAh $argv/gls -lAh --group-directories-first $argv/g' ~/.config/fish/functions/la.fish
    else
        echo "Not linux or macOS. Aborting." && exit 1
    fi
fi

if check_if_install_no "audio scripts + libnotify"; then
    mkdir ~/scripts
    cp $base_dir/scripts/audio_input_mute_toggle.sh ~/scripts
    cp $base_dir/scripts/audio_output_toggle.sh ~/scripts
    cp $base_dir/scripts/audio_output_headphone_monitor.py ~/scripts
    # notification system (kde)
    check_dependency apt-get
    sudo apt-get update && sudo apt-get install --no-install-recommends --yes libnotify-bin
fi

# Audio power save fix: 
#   Fixes annoying ticking sound when no active audio output.
# PulseAudio configuration file: 
#   Disable automatic switching between outputs.
#   Enable Echo/Noise-Cancellation on input
if check_if_install_no "audio fixes"; then
    # Audio power save fix
    sudo sh -c 'echo "options snd_hda_intel power_save=0" > /etc/modprobe.d/audio-power_save.conf'
    # PulseAudio configuration file
    mkdir -p ~/.config/pulse && cp $base_dir/config_files/pulse/default.pa ~/.config/pulse
fi

printf "\n======| End of setup :).\n"
