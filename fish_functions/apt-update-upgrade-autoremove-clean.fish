function apt-update-upgrade-autoremove-clean --description 'sudo apt-get [update,upgrade,autoremove,clean]'
  sudo sh -c "apt-get -y update && apt-get -y upgrade && apt-get -y autoremove && apt-get -y clean" $argv; 
end
