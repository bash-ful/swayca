# sway-config-appender
a bash script that allows you to append config files for your Sway needs

this script allows you to append a different Sway config to the "main" config, effectively allowing you to have presets that you can select and activate during Sway runtime. i made this script in a way that modifies the main Sway config file as little as possible. the script uses Sway's `include` to point to a symlink, which the script modifies to point to different files (i.e. the configs)

# prerequisites
- Sway
- your Sway config directory is located at `$HOME/.config/sway`, with the main config named `config`
- a backup of your Sway config folder, just in case

# installation
```
wget -O swayca https://raw.githubusercontent.com/bash-ful/swayca/main/swayca.sh
chmod +x swayca
```

# usage
```
swayca -i
```
**NOTE: this command will create a backup of your main Sway config `config.bak`, and append a line at the end of it. that's the only time it should/will alter your main config file! unless something has gone horribly wrong, you only really need to run this once.**

this makes a backup of the main config file, appends an `include` command on your main config, and creates a `swayca-config` folder in your `$HOME` directory.

you can create your config files on `swayca-config/configs`, following Sway's config file format (`man 5 sway`).


to apply/change the currently appended config, use
```
swayca -c CONFIG [CONFIG-2 CONFIG-3 ...]
```
where `CONFIG` is the name of the config file located at `swayca-config/configs`. ideally you'd use this script with `bindsym` to change configs.

you can also pass multiple config names, allowing you to cycle/toggle between them.

to uninstall, simply delete the `swayca-config` folder, and delete the generated `include` lines on your main config file.

# plans (probably maybe)

- [ ] configurable locations of various files/directories used in the script

- [x] ability to toggle/cycle between configs

- [ ] fix option/argument parsing because holy hell it sucks
