#!/usr/bin/env bash
readonly SWAY_CONFIG_DIR="$HOME/.config/sway"
readonly SWAY_CONFIG_MAIN="config"
readonly CURRENT_CONFIG_PATH="$SWAY_CONFIG_DIR/appended-config"
readonly CONFIGS_DIR="$SWAY_CONFIG_DIR/config-appender"
readonly DEFAULT_CONFIG="default"

enable_swaynag=true

printerr() {
    >&2 echo -e "\033[0;31m$1\033[0m"
}

create_default() {
    cat >"$CONFIGS_DIR/$DEFAULT_CONFIG" <<EOF
# This is the default config-append file
# swayca will try to fall back to this when
# something goes wrong.
EOF
}

link_selected_config() {
    ln -sf "$CONFIGS_DIR/$1" "$CURRENT_CONFIG_PATH"
    swaymsg reload
}

init() {
    if [ ! -d "$SWAY_CONFIG_DIR" ]; then
        printerr "Sway config directory \"$SWAY_CONFIG_DIR\" not found!"
        if [ $enable_swaynag = true ]; then
            swaynag -m "Sway config directory \"$SWAY_CONFIG_DIR\" not found!"
        fi
        exit 1
    elif [ ! -f "$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN" ]; then
        printerr "Sway config directory \"$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN\" not found!"
        if [ $enable_swaynag = true ]; then
            swaynag -m "Sway config directory \"$SWAY_CONFIG_DIR/$SWAY_CONFIG_MAIN\" not found!"
        fi
        exit 1
    fi

    [ ! -d "$CONFIGS_DIR" ] && mkdir -p "$CONFIGS_DIR"
    [ ! -f "$CONFIGS_DIR/$DEFAULT_CONFIG" ] && create_default
    link_selected_config "$DEFAULT_CONFIG"
}

# Function to print help (assuming it's defined elsewhere)
print_help() {
    echo "Usage: swayca [options] [config-name]"
    echo "       swayca [config-name]"
    echo "Options:"
    echo "  -c [config-name]     set the config"
    echo "  -n                  disable swaynag messages"
    echo "  -h                  display this help message and exit"
}

while getopts ":nc:h" opt; do
    case $opt in
    n)
        enable_swaynag=false
        ;;
    c)
        selected_config=$OPTARG
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
    selected_config=$1
fi

if [[ -z "$selected_config" ]]; then
    printerr "config name argument missing!"
    print_help
    exit 1
fi

if [ ! -f "$CONFIGS_DIR/$selected_config" ]; then
    printerr "config file \"$1\" not found."
    if [ $enable_swaynag = true ]; then
        swaynag -m "config file \"$1\" not found. Would you like to use the default config?" \
            -Z "Use default" "exec $0 $DEFAULT_CONFIG" \
            -Z "Retry" "exec $0 $1"
    fi
    exit 1
fi
link_selected_config "$selected_config"

