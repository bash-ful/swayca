# sway-config-appender
a bash script that allows you to append config files for your Sway needs

this script allows you to append a different Sway config to the "main" config, effectively allowing you to have presets that you can select and activate during Sway runtime. i made this script in a way that modifies the main Sway config file as little as possible. the script uses Sway's `include` to point to a symlink, which the script modifies to point to different files (i.e. the configs)

# prerequisites
- Sway
- your Sway config directory is located at `XDG_CONFIG_HOME/sway/config`
- a backup of your main Sway config file, just in case

# installation
```
wget -O swayca https://raw.githubusercontent.com/bash-ful/swayca/main/swayca.sh
chmod +x swayca
```

# usage
## initialization
```
swayca -i
```
**NOTE: this command will create a backup of your main Sway config `config.bak`, and append a line at the end of your main config. that's the only time it should/will alter your main config file! unless something has gone horribly wrong, you only really need to run this once**

this makes a backup of the main config file, appends an `include` command on your main config, and creates a `swayca-config` folder in your `$HOME` directory

you can create your config files on `swayca-config/configs`, following Sway's config file format (`man 5 sway`)


## change to/between configs
```
swayca [-n] -c CONFIG [CONFIG-2 CONFIG-3 ...]
```
where `CONFIG` is the name of the config file located at `swayca-config/configs`. ideally you'd use this script with `bindsym` to change configs, i.e.
```
bindsym $mod+t exec "path/to/swayca -c CONFIG"
```

you can also pass multiple config names, allowing you to cycle/toggle between them

there is a fallback config `.default` found on the `configs` folder. swayca will prompt you via `swaynag` to choose this config if the currently selected config is not found. this prompt is disabled if `-n` is passed

to uninstall, simply delete the `swayca-config` folder, and delete the generated `include` lines on your main config file. you can also choose to restore or delete the generated `config.bak` file/s.

# plans (probably maybe)

- [ ] configurable locations of various files/directories used in the script
- [x] ability to toggle/cycle between configs
- [ ] fix option/argument parsing because holy hell it sucks
- [ ] optimize the code because it's absolute dog water

# notes
  - Sway quirks (the config version of `gaps` not updating on existing workspaces, `bindsym` overwrite warnings, etc) still apply here
