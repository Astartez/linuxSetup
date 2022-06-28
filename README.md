# ✨ linuxSetup ✨
Script for setting up my Debian/Ubuntu environment 😍

- `fish` (shell)
- `fisher` (fish plugin manager) + fish colors config
    - `pure-fish/pure`: theme
    - `decors/fish-colored-man`
- `fzf` (fuzzy search)
    - `ctrl+r` history search
    - `ctrl+t` file search
- `micro` (editor)
- `grc` (colored outputs) + fish functions (`ll`;`la`;`apt`)
    - `ll` & `la`: add `--group-directories-first`
    - `apt-update-upgrade-autoremove-clean`: perform `sudo apt-get [update,upgrade,autoremove,clean]`
- Audio scripts + libnotify (for kde notifications)
    - `audio_input_mute_toggle.sh`
    - `audio_output_toggle.sh`
    - `audio_output_headphone_monitor.py` (possibly obsolete)
- Audio fixes
    - Audio power save fix: 
        - Fixes annoying ticking sound when no active audio output.
    - PulseAudio configuration file: 
        - Disable automatic switching between outputs.
        - Enable Echo/Noise-Cancellation on input

Run as non-superuser: `./mysetup.sh`

Enjoy 🥝
