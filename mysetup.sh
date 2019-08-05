#!/bin/bash

# Check if curl is installed
command -v curl >/dev/null 2>&1 || { echo "I require curl but it's not installed.  Aborting." >&2; exit 1; }
command -v apt >/dev/null 2>&1 || { echo "I require curl but it's not installed.  Aborting." >&2; exit 1; }
command -v git >/dev/null 2>&1 || { echo "I require curl but it's not installed.  Aborting." >&2; exit 1; }

printf "======| Installing fish...\n"
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt-get update
sudo apt-get install fish

printf "\n======| Installing fisher + pure theme + colored man pages...\n"
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fish -c "fisher add rafaelrinaldi/pure"
fish -c "fisher add decors/fish-colored-man"

printf "\n======| Installing fzf...\n"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

printf "\n======| Installing micro...\n"
cd /usr/local/bin; curl https://getmic.ro | sudo bash
cd
sudo apt-get install xclip

printf "\n======| Installing grc and configuring ll...\n"
sudo apt install grc
echo "source /etc/grc.fish" >> ~/.config/fish/config.fish
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
