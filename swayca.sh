#!/usr/bin/env bash

readonly SWAY_CONFIG_DIR="$HOME/.config/sway"
readonly SWAY_CONFIG_MAIN="config"

readonly SWAYCA_CONFIG_DIR="$HOME/swayca-config"
readonly SELECTED_CONFIG_SYMLINK="$SWAYCA_CONFIG_DIR/appended-config"
readonly CURRENT_CONFIG_NAME="$SWAYCA_CONFIG_DIR/.current"
readonly CONFIGS_DIR="$SWAYCA_CONFIG_DIR/configs"
readonly DEFAULT_CONFIG=".default"

enable_swaynag=true
selected_config=""

printerr() {
    >&2 echo -e "\033[0;31m$1\033[0m"
}

create_default_config() {
    cat >"$CONFIGS_DIR/$DEFAULT_CONFIG" <<EOF
    # This is the default config-append file
    # swayca will try to fall back to this when
    # things go wrong or something.
EOF
}

backup_sway_config() {
    local backup_file="$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN.bak"
    local suffix=1
    while [ -f "$backup_file" ]; do
        backup_file="$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN.bak.$suffix"
        ((suffix++))
    done
    cp "$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN" "$backup_file"
    echo "main config backup created at: $backup_file"
}

link_config() {
    local config_name="$1"
    ln -sf "$CONFIGS_DIR/$config_name" "$SELECTED_CONFIG_SYMLINK"
    echo "$config_name" >"$CURRENT_CONFIG_NAME"
    swaymsg reload
}

cycle() {
    local selected_config_name config_list target_index next_index

    if [ "$#" -lt 1 ]; then
        echo "Usage: $0 -c CONFIG [CONFIG-2 CONFIG-3 ...]"
        exit 1
    fi

    # return first arg if there's only one arg passed
    if [ "$#" -eq 1 ]; then
        echo "$1"
        return
    fi

    selected_config_name=$(head -n 1 "$CURRENT_CONFIG_NAME")
    config_list=("$@")
    for ((i = 0; i < ${#config_list[@]}; i++)); do
        if [[ "${config_list[$i]}" == "$selected_config_name" ]]; then
            target_index=$i
            break
        fi
    done

    next_index=$(((target_index + 1) % ${#config_list[@]}))
    echo "${config_list[$next_index]}"
}

init() {
    if [ ! -d "$SWAY_CONFIG_DIR" ]; then
        printerr "Sway config directory \"$SWAY_CONFIG_DIR\" not found!"
        if [ "$enable_swaynag" = true ]; then
            swaynag -m "Sway config directory \"$SWAY_CONFIG_DIR\" not found!"
        fi
        exit 1
    fi
    if [ ! -f "$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN" ]; then
        printerr "Sway config file \"$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN\" not found!"
        if [ "$enable_swaynag" = true ]; then
            swaynag -m "Sway config file \"$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN\" not found!"
        fi
        exit 1
    fi

    backup_sway_config
    echo "include $SELECTED_CONFIG_SYMLINK" >>"$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN"
    mkdir -p "$CONFIGS_DIR"
    [ ! -f "$CONFIGS_DIR/$DEFAULT_CONFIG" ] && create_default_config
    link_config "$DEFAULT_CONFIG"
}

print_help() {
    local filename
    filename=$(basename "$0")
    echo "Usage: $filename [-n] -c CONFIG [CONFIG-2 CONFIG-3 ...]"
    echo "       $filename -i|h"
    echo "Options:"
    echo "  -i                                           initialize $filename"
    echo "  -c CONFIG [CONFIG-2 CONFIG-3 ...]            set the config to append"
    echo "                                               if multiple configs are given, cycle through each one"
    echo "  -n                                           disable swaynag messages"
    echo "  -h                                           display this help message and exit"
}

while getopts ":hinc:" opt; do
    case $opt in
    i)
        init
        exit 0
        ;;
    h)
        print_help
        exit 0
        ;;
    n)
        enable_swaynag=false
        ;;
    c)
        shift
        selected_config=$(cycle "$@")

        ;;
    *)
        print_help
        exit 1
        ;;
    esac
done

shift $((OPTIND - 1))

if [[ -z "$selected_config" ]]; then
    if [ "$enable_swaynag" = true ]; then
        swaynag -m "Config name argument is missing!"
    fi
    printerr "Config name argument is missing!"
    print_help
    exit 1
fi

if [ ! -f "$SWAY_CONFIG_DIR/$DEFAULT_CONFIG" ]; then
    create_default_config
fi

if [ ! -f "$CONFIGS_DIR/$selected_config" ]; then
    printerr "Config file \"$CONFIGS_DIR/$selected_config\" not found."
    if [ "$enable_swaynag" = true ]; then
        swaynag -m "Config file \"$CONFIGS_DIR/$selected_config\" not found. Would you like to use the default config?" \
            -Z "Use default" "exec $0 -c $DEFAULT_CONFIG" \
            -Z "Retry" "exec $0 -c $selected_config"
    fi
    exit 1
fi

link_config "$selected_config"
