# swayca
sway-config-appender, a bash script that allows you to append config files for your Sway needs
## what
this script allows you to append a different Sway config to the "main" config, effectively allowing you to have presets that you can activate during Sway runtime. i made this script in a way that modifies the main Sway config file as little as possible.
## why
you can switch between configs to append to Sway's main config, allowing you to cycle through your configs that may modify Sway's functionality and appearance (like custom made themes!). as to why i made this script, it's fun
## how (it works)
it uses Sway's `include` to point to a symlink, which the script modifies to point to different files (i.e. the configs).

# prerequisites
- your Sway config directory is located at `$HOME/.config/sway`, with the main config named `config`
- Sway is installed on your device
- make a backup of your sway config folder, just in case

# installation
```
wget -O swayca https://raw.githubusercontent.com/bash-ful/swayca/main/swayca.sh
chmod +x swayca
```

# usage
```
swayca -i
```
**NOTE: this command will create a backup of your main Sway config, and append a line at the end of it. that's the only time it should/will alter your main config file!**

this makes a backup of the main config file, appends an `include` command on your main config, and creates a `swayca` folder in your config directory.
you can create your config files on `swayca/configs`, following Sway's config file format (`man 5 sway`).

to apply/change the currently appended config, use
```
swayca <config-name>
```
where `config-name` is the name of the config file located at `swayca/configs`.

# plans (probably maybe)
[ ] deal with `bindsym` and other conflicting commands

[ ] configurable locations of various files/directories used in the script
