#!/bin/bash

# Check if sudo (shouldn't be)
[ "$(id -u)" -eq 0 ] && printf "This script must NOT be run using sudo!\n" && exit 1

# Check if curl is installed
command -v curl >/dev/null 2>&1 || { echo "I require curl but it's not installed.  Aborting." >&2; exit 1; }
command -v apt >/dev/null 2>&1 || { echo "I require apt but it's not installed.  Aborting." >&2; exit 1; }
command -v git >/dev/null 2>&1 || { echo "I require git but it's not installed.  Aborting." >&2; exit 1; }

printf "======| Installing fish...\n"
if [[ $(lsb_release -i) == *"Debian"* ]]; then
        if [[ $(lsb_release -i) == *"10"* ]]; then
                echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' > /etc/apt/sources.list.d/shells:fish:release:3.list
                wget -nv https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key -O Release.key
                apt-key add - < Release.key
        fi
else
        sudo apt-add-repository ppa:fish-shell/release-3
fi
sudo apt update
sudo apt install fish

printf "\n======| Installing fisher + pure theme + colored man pages...\n"
fish -c "curl -sL git.io/fisher | source && fisher install jorgebucaran/fisher"
fish -c "fisher install rafaelrinaldi/pure"
fish -c "fisher install decors/fish-colored-man"

printf "\n======| Installing fzf...\n"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

printf "\n======| Installing micro...\n"
cd /usr/local/bin; curl https://getmic.ro | sudo bash
cd
sudo apt install xclip

printf "\n======| Installing grc and configuring ll...\n"
sudo apt install grc
fish -c "fisher add orefalo/grc"
sudo bash -c 'cat > /usr/share/fish/functions/ll.fish << EOF
#
# These are very common and useful
#
function ll --description "List contents of directory using long format"
    ls -lhF --group-directories-first --color=always \$argv
end
EOF
'

printf "\n======| End of installation.\n"
