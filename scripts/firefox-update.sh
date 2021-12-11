#!/bin/bash

# Check if sudo (shouldn't be)
[ "$(id -u)" -ne 0 ] && printf "This script must be run using sudo!\n" && exit 1

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [OPTION]...
Update Firefox using the provided archive FILE. If FILE is not provided,
download the latest binaries for update.

    -h          display this help and exit
    -f FILE     update firefox using the archive FILE instead of downloading
                the binaries automatically.
EOF
}

# Initialize our own variables
binary_archive=""
install_path="/opt"

# Get command line options
while getopts "hf:" opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        f)
            binary_archive=$OPTARG
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND - 1))"   # Remove all options passed by getopts options

pidof -q firefox && printf "Firefox is currenly running, please close firefox and rerun the script.\n" && exit 1

if [[ -z "$binary_archive" ]]; then
    printf "Binary files not provided, downloading binaries...\n\n"
    wget --directory-prefix=/tmp --content-disposition "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
    binary_archive=$(ls -t /tmp/firefox-*.tar.bz2 | head -n1)
fi
printf "Removing previous firefox files...\n"
rm -r ${install_path}/firefox
printf "Extracting firefox...\n"
tar --extract --bzip2 --directory $install_path --file $binary_archive
printf "Removing archive file...\n"
rm $binary_archive
printf "Firefox update complete\n"
