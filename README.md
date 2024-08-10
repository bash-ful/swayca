# swayca
sway-config-appender, a bash script that allows you to append config files for your Sway needs
## what
this script allows you to append a different Sway config to the "main" config, effectively allowing you to have presets that you can activate during Sway runtime. i made this script in a way that modifies the main Sway config file as little as possible
## why
you can switch between configs to append to Sway's main config, allowing you to cycle through your configs that may modify Sway's functionality and appearance (like custom made themes!). as to why i made this script, it's fun
## how (it works)
it uses Sway's `include` to point to a symlink, which the script modifies to point to different files (i.e. the configs)

# prerequisites
- Sway
- your Sway config directory is located at `$HOME/.config/sway`, with the main config named `config`
- a backup of your Sway config folder, just in case

# installation
```sh
wget -O swayca https://raw.githubusercontent.com/bash-ful/swayca/main/swayca.sh
chmod +x swayca
```

# usage
```sh
swayca -i
```
**NOTE: this command will create a backup of your main Sway config `config.bak`, and append a line at the end of it. that's the only time it should/will alter your main config file!**

this makes a backup of the main config file, appends an `include` command on your main config, and creates a `swayca-config` folder in your config directory.
you can create your config files on `swayca-config/configs`, following Sway's config file format (`man 5 sway`)

unless something has gone horribly wrong, you only really need to run this **once**.

to apply/change the currently appended config, use
```sh
swayca -c <config-name>
```
where `config-name` is the name of the config file located at `swayca-config/configs`. ideally you'd use this script with `bindsym exec` to have hotkeys that change configs.
commands that may conflict with duplicates (like `bindsym`) may arise, and at the moment the script does not have features to deal with this

to uninstall, simply delete the `swayca-config` folder, and delete the `include` lines on your main config file.

# plans (probably maybe)
[ ] deal with `bindsym` and other commands that conflict with duplicates

[ ] configurable locations of various files/directories used in the script

[ ] ability to toggle/cycle between themes
