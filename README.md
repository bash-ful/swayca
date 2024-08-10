# swayca
sway-config-appender, a bash script that allows you to append config files for your Sway needs
# what
this script allows you to append a different Sway config to the "main" config, effectively allowing you to have presets that you can activate during Sway runtime. i made this script with a non-intrusive approach in mind, modifying the main Sway config file as little as possible and ensuring most of the files made by the script is contained and easy to remov.
# why
you can switch between configs to append to Sway's main config, allowing you to cycle through your configs that may modify Sway's functionality and appearance (like custom made themes!). as to why i made this script, it's fun
# how (it works)
it uses Sway's `include` to point to a symlink, which the script modifies to point to different files (i.e. the configs).
