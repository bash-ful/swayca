#!/usr/bin/env bash

readonly SWAY_CONFIG_DIR="$HOME/.config/sway"
readonly SWAY_CONFIG_MAIN="config"
readonly SWAYCA_CONFIG_DIR="$SWAY_CONFIG_DIR/swayca-config"
readonly CURRENT_CONFIG_PATH="$SWAYCA_CONFIG_DIR/appended-config"
readonly CONFIGS_DIR="$SWAYCA_CONFIG_DIR/configs"
readonly DEFAULT_CONFIG="default"

enable_swaynag=true

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
    ln -sf "$CONFIGS_DIR/$config_name" "$CURRENT_CONFIG_PATH"
    swaymsg reload
}

initialize() {
    if [ ! -d "$SWAY_CONFIG_DIR" ]; then
        printerr "Sway config directory \"$SWAY_CONFIG_DIR\" not found!"
        [ "$enable_swaynag" = true ] && swaynag -m "Sway config directory \"$SWAY_CONFIG_DIR\" not found!"
        exit 1
    elif [ ! -f "$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN" ]; then
        printerr "Sway config file \"$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN\" not found!"
        [ "$enable_swaynag" = true ] && swaynag -m "Sway config file \"$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN\" not found!"
        exit 1
    fi
    backup_sway_config
    echo "include $CURRENT_CONFIG_PATH" >>"$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN"
    mkdir -p "$CONFIGS_DIR"
    [ ! -f "$CONFIGS_DIR/$DEFAULT_CONFIG" ] && create_default_config
    link_config "$DEFAULT_CONFIG"
}

print_help() {
    echo "Usage: swayca [options] [config-name]"
    echo "       swayca [config-name]"
    echo "       swayca -i"
    echo "Options:"
    echo "  -i                  initialize swayca on your Sway config folder"
    echo "  -c [config-name]    set the config to append"
    echo "  -n                  disable swaynag messages"
    echo "  -h                  display this help message and exit"
}

while getopts ":nc:hi" opt; do
    case $opt in
    i)
        initialize
        exit 0
        ;;
    n)
        enable_swaynag=false
        ;;
    c)
        selected_config="$OPTARG"
        ;;
    h)
        print_help
        exit 0
        ;;
    *)
        print_help
        exit 1
        ;;
    esac
done

shift $((OPTIND - 1))

if [[ -z "$selected_config" && $# -eq 1 ]]; then
    selected_config="$1"
fi

if [[ -z "$selected_config" ]]; then
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
            -Z "Use default" "exec $0 $DEFAULT_CONFIG" \
            -Z "Retry" "exec $0 $selected_config"
    fi
    exit 1
fi

link_config "$selected_config"
