#!/usr/bin/env bash
CONFIGS_DIR="$HOME/.config/sway/config-appender"
DEFAULT_CONFIG_PATH="$CONFIGS_DIR/default"
CURRENT_CONFIG_PATH="$HOME/.config/sway/appended-config"

function printerr() {
    >&2 echo -e "\033[0;31m$1\033[0m"
}

function is_uint() {
    case $1 in '' | *[!0-9]*) return 1 ;;
    esac
}

function get_file_from_index() {
    local number="$1"
    for file in "$CONFIGS_DIR"/*; do
        if [ -f "$file" ]; then
            first_line=$(head -n 1 "$file")
            extracted_number="${first_line#\#}"
            if [ "$extracted_number" == "$number" ]; then
                echo "$file"
            fi
        fi
    done
}

function get_current_theme_index() {
    local file_path="$1"
    [ ! -f "$file_path" ] &&
        printerr "No index found for ${file_path}." &&
        exit 1
    first_line=$(head -n 1 "$file_path")
    number="${first_line#\#}"
    echo "$number"
}

function link_selected_theme() {
    ln -sf "$1" "$CURRENT_CONFIG_PATH"
}

[ ! -d "$CONFIGS_DIR" ] && mkdir -p "$CONFIGS_DIR"
[ ! -f "$DEFAULT_CONFIG_PATH" ] \
&& echo "#0" > "$HOME/.config/sway/config-appender/default"
[ ! -f "$CURRENT_CONFIG_PATH" ] \
&& link_selected_theme "$DEFAULT_CONFIG_PATH"

current_theme_index=$(get_current_theme_index "$CURRENT_CONFIG_PATH")
is_uint $current_theme_index
[ $? -eq 1 ] && printerr "invalid index found on first line: $current_theme_index" && exit 1

index=$((current_theme_index + 1))
selected_theme=$(get_file_from_index "$index")
[ ! -f "$selected_theme" ] && selected_theme=$DEFAULT_CONFIG_PATH

link_selected_theme "$selected_theme" \
&& swaymsg reload
