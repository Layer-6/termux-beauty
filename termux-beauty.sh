#!/usr/bin/env bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
BLACK='\033[1;30m'
GRAY='\033[0;37m'
BOLD='\033[1m'
RESET='\033[0m'

ETC_DIR="/data/data/com.termux/files/usr/etc"
MOTD_FILE="${ETC_DIR}/motd"
BASHRC_FILE="${ETC_DIR}/bash.bashrc"
BACKUP_DIR="$HOME/.termux_beauty_backups"
ART_FILE="art.txt"
PROMPT_FILE="Ps1.txt"

mkdir -p "$BACKUP_DIR"

show_help() {
    echo -e "${CYAN}Termux Beauty Script${RESET}"
    echo "Usage: $0 [OPTION]"
    echo "  --help, -h        Show this help"
    echo "  --motd            Change banner (logo + text)"
    echo "  --prompt          Change command prompt"
    echo "  --reset           Restore to default"
    echo "  --menu            Interactive menu (default)"
}

backup_files() {
    rm -rf "$BACKUP_DIR"/*
    if [ -f "$MOTD_FILE" ]; then
        cp "$MOTD_FILE" "$BACKUP_DIR/motd.backup"
    fi
    if [ -f "$BASHRC_FILE" ]; then
        cp "$BASHRC_FILE" "$BACKUP_DIR/bashrc.backup"
    fi
    echo -e "${GREEN}[✓] Backup done${RESET}"
}

restore_default() {
    if [ -f "$BACKUP_DIR/motd.backup" ]; then
        cp "$BACKUP_DIR/motd.backup" "$MOTD_FILE"
        echo -e "${GREEN}[✓] MOTD restored${RESET}"
    else
        > "$MOTD_FILE"
    fi
    if [ -f "$BACKUP_DIR/bashrc.backup" ]; then
        cp "$BACKUP_DIR/bashrc.backup" "$BASHRC_FILE"
        echo -e "${GREEN}[✓] bash.bashrc restored${RESET}"
    else
        echo "PS1='\\[\\e[0;32m\\]\\w\\[\\e[0m\\] \\$ '" > "$BASHRC_FILE"
    fi
    echo -e "${CYAN}[*] Restart Termux to see changes${RESET}"
}

load_logos() {
    LOGOS=()
    local current=""
    local in_logo=0

    if [ ! -f "$ART_FILE" ]; then
        echo -e "${RED}art.txt not found!${RESET}"
        return 1
    fi

    while IFS= read -r line || [ -n "$line" ]; do
        if [[ "$line" == "(ascii art)" ]]; then
            if [ -n "$current" ]; then
                LOGOS+=("$current")
            fi
            current=""
            in_logo=1
        else
            if [ $in_logo -eq 1 ]; then
                current+="$line"$'\n'
            fi
        fi
    done < "$ART_FILE"

    if [ -n "$current" ]; then
        LOGOS+=("$current")
    fi
}

list_logos() {
    if [ ${#LOGOS[@]} -eq 0 ]; then
        echo -e "${RED}No logos found in $ART_FILE${RESET}"
        return 1
    fi

    echo -e "${CYAN}════════════════════════════════════${RESET}"
    echo -e "${YELLOW}   Available Logos  ${RESET}"
    echo -e "${CYAN}════════════════════════════════════${RESET}"

    for i in "${!LOGOS[@]}"; do
        echo -e "${RED}$((i+1))${RESET}) Logo $((i+1))"
        echo -e "${CYAN}────────────────────────────${RESET}"
        echo -e "${LOGOS[$i]}"
        echo -e "${CYAN}────────────────────────────${RESET}"
        echo ""
    done

    local choice
    while true; do
        echo -en "${YELLOW}Select logo number [1-${#LOGOS[@]}]: ${RESET}"
        read choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#LOGOS[@]} ]; then
            SELECTED_LOGO="${LOGOS[$((choice-1))]}"
            break
        else
            echo -e "${RED}Invalid choice${RESET}"
        fi
    done
}

change_motd() {
    load_logos
    if [ ${#LOGOS[@]} -eq 0 ]; then
        return 1
    fi

    list_logos

    echo -e "${YELLOW}Logo color selection:${RESET}"
    echo -e "  1) Black"
    echo -e "  2) Gray"
    echo -e "  3) Red"
    echo -e "  4) Green"
    echo -e "  5) Yellow"
    echo -e "  6) Blue"
    echo -e "  7) Purple"
    echo -e "  8) Cyan"
    echo -e "  9) White"
    echo -e "  10) Light Red"
    echo -e "  11) Light Green"
    echo -e "  12) Light Yellow"

    local color_choice
    while true; do
        echo -en "${YELLOW}Select logo color [1-12]: ${RESET}"
        read color_choice
        if [[ "$color_choice" =~ ^[0-9]+$ ]] && [ "$color_choice" -ge 1 ] && [ "$color_choice" -le 12 ]; then
            break
        else
            echo -e "${RED}Invalid choice${RESET}"
        fi
    done

    local logo_color
    case $color_choice in
        1) logo_color="$BLACK" ;;
        2) logo_color="$GRAY" ;;
        3) logo_color="$RED" ;;
        4) logo_color="$GREEN" ;;
        5) logo_color="$YELLOW" ;;
        6) logo_color="$BLUE" ;;
        7) logo_color="$PURPLE" ;;
        8) logo_color="$CYAN" ;;
        9) logo_color="$WHITE" ;;
        10) logo_color="\033[1;91m" ;;
        11) logo_color="\033[1;92m" ;;
        12) logo_color="\033[1;93m" ;;
    esac

    echo -e "${CYAN}Enter your extra text (e.g., My Channel: t.me/Red_Rooted_Ghost):${RESET}"
    echo -en "${YELLOW}Text: ${RESET}"
    read extra_text

    echo -e "${YELLOW}Text color selection:${RESET}"
    echo -e "  1) Black"
    echo -e "  2) Gray"
    echo -e "  3) Red"
    echo -e "  4) Green"
    echo -e "  5) Yellow"
    echo -e "  6) Blue"
    echo -e "  7) Purple"
    echo -e "  8) Cyan"
    echo -e "  9) White"
    echo -e "  10) Light Red"
    echo -e "  11) Light Green"
    echo -e "  12) Light Yellow"

    local text_color_choice
    while true; do
        echo -en "${YELLOW}Select text color [1-12]: ${RESET}"
        read text_color_choice
        if [[ "$text_color_choice" =~ ^[0-9]+$ ]] && [ "$text_color_choice" -ge 1 ] && [ "$text_color_choice" -le 12 ]; then
            break
        else
            echo -e "${RED}Invalid choice${RESET}"
        fi
    done

    local text_color
    case $text_color_choice in
        1) text_color="$BLACK" ;;
        2) text_color="$GRAY" ;;
        3) text_color="$RED" ;;
        4) text_color="$GREEN" ;;
        5) text_color="$YELLOW" ;;
        6) text_color="$BLUE" ;;
        7) text_color="$PURPLE" ;;
        8) text_color="$CYAN" ;;
        9) text_color="$WHITE" ;;
        10) text_color="\033[1;91m" ;;
        11) text_color="\033[1;92m" ;;
        12) text_color="\033[1;93m" ;;
    esac

    > "$MOTD_FILE"
    echo -e "${logo_color}${SELECTED_LOGO}${RESET}" >> "$MOTD_FILE"
    echo "" >> "$MOTD_FILE"
    if [ -n "$extra_text" ]; then
        echo -e "${text_color}${extra_text}${RESET}" >> "$MOTD_FILE"
    fi

    echo -e "${GREEN}[✓] MOTD updated successfully${RESET}"
    echo -e "${CYAN}Restart Termux to see the new banner${RESET}"
}

get_color_code() {
    case $1 in
        1) echo "\\[\\033[1;31m\\]" ;;
        2) echo "\\[\\033[1;32m\\]" ;;
        3) echo "\\[\\033[1;33m\\]" ;;
        4) echo "\\[\\033[1;34m\\]" ;;
        5) echo "\\[\\033[1;35m\\]" ;;
        6) echo "\\[\\033[1;36m\\]" ;;
        7) echo "\\[\\033[1;37m\\]" ;;
        8) echo "\\[\\033[1;91m\\]" ;;
        9) echo "\\[\\033[1;92m\\]" ;;
        10) echo "\\[\\033[1;93m\\]" ;;
        *) echo "\\[\\033[1;37m\\]" ;;
    esac
}

build_prompt() {
    local emoji="$1"
    local username="$2"
    local at_sign="$3"
    local hostname="$4"
    local symbol="$5"
    local main_color="$6"
    local emoji_color="$7"
    local user_color="$8"
    local at_color="$9"
    local host_color="${10}"
    local path_color="${11}"
    local symbol_color="${12}"

    local ps1="PS1='${main_color}┌─[${emoji_color}${emoji}${RESET} ${user_color}${username}${RESET}${at_color}${at_sign}${RESET}${host_color}${hostname}${RESET}${main_color}]─[${path_color}\\w${main_color}]\\n${main_color}└──╼ ${symbol_color}${symbol}${RESET}${main_color} \\[\\033[0m\\] '"

    local final_ps1="PS1='${main_color}┌─[${emoji_color}${emoji}${RESET} ${user_color}${username}${RESET}${at_color}${at_sign}${RESET}${host_color}${hostname}${RESET}${main_color}]─[${path_color}\\w${main_color}]\\n${main_color}└──╼ ${symbol_color}${symbol}${RESET}${main_color} \\[\\033[0m\\] '"

    local final="PS1='${main_color}┌─[${emoji_color}${emoji}\[\\033[0m\] ${user_color}${username}\[\\033[0m\]${at_color}${at_sign}\[\\033[0m\]${host_color}${hostname}\[\\033[0m\]${main_color}]─[${path_color}\\w${main_color}]\\n${main_color}└──╼ ${symbol_color}${symbol}\[\\033[0m\]${main_color} \\[\\033[0m\\] '"

    echo "$final"
}

change_prompt() {
    echo -e "${YELLOW}Select prompt style:${RESET}"
    echo "  1) Default prompt (with customization)"
    echo "  2) Custom manual prompt"

    local style_choice
    while true; do
        echo -en "${YELLOW}Select [1-2]: ${RESET}"
        read style_choice
        if [[ "$style_choice" =~ ^[1-2]$ ]]; then
            break
        else
            echo -e "${RED}Invalid choice${RESET}"
        fi
    done

    if [ "$style_choice" -eq 2 ]; then
        echo -e "${CYAN}Enter your custom PS1 template:${RESET}"
        echo -e "${YELLOW}Use {emoji}, {user}, {at}, {host}, {symbol} as placeholders${RESET}"
        echo -e "${YELLOW}Example: PS1='┌─[{emoji}] {user}{at}{host}]─[\\w]\n└──╼ {symbol} '${RESET}"
        echo -en "${CYAN}Enter PS1: ${RESET}"
        read -r custom_template
        if [ -z "$custom_template" ]; then
            custom_template="PS1='┌─[{emoji}] {user}{at}{host}]─[\\w]\n└──╼ {symbol} '"
        fi

        # Get customization values
        echo -e "\n${CYAN}Customize your prompt:${RESET}"
        echo -en "${YELLOW}Enter emoji (default 💀): ${RESET}"
        read emoji
        [ -z "$emoji" ] && emoji="💀"

        echo -en "${YELLOW}Enter username (default Red): ${RESET}"
        read username
        [ -z "$username" ] && username="Red"

        echo -en "${YELLOW}Enter @ sign or separator (default @): ${RESET}"
        read at_sign
        [ -z "$at_sign" ] && at_sign="@"

        echo -en "${YELLOW}Enter hostname (default Rooted): ${RESET}"
        read hostname
        [ -z "$hostname" ] && hostname="Rooted"

        echo -en "${YELLOW}Enter symbol (default #): ${RESET}"
        read symbol
        [ -z "$symbol" ] && symbol="#"

        # Replace placeholders
        local final_ps1=$(echo "$custom_template" | sed -e "s/{emoji}/$emoji/g" -e "s/{user}/$username/g" -e "s/{at}/$at_sign/g" -e "s/{host}/$hostname/g" -e "s/{symbol}/$symbol/g")

        # Write to bashrc
        local tmpfile="${BASHRC_FILE}.tmp"
        cp "$BASHRC_FILE" "$tmpfile"
        sed -i '/^PS1=/d' "$BASHRC_FILE"
        echo "$final_ps1" >> "$BASHRC_FILE"
        rm "$tmpfile"

        echo -e "${GREEN}[✓] Custom prompt applied${RESET}"
        echo -e "${CYAN}Restart Termux or run 'source $BASHRC_FILE' to see changes${RESET}"
        return
    fi

    echo -e "\n${CYAN}Customize your default prompt:${RESET}"

    echo -en "${YELLOW}Enter emoji (default 💀): ${RESET}"
    read emoji
    [ -z "$emoji" ] && emoji="💀"

    echo -en "${YELLOW}Enter username (default Red): ${RESET}"
    read username
    [ -z "$username" ] && username="Red"

    echo -en "${YELLOW}Enter @ sign or separator (default @): ${RESET}"
    read at_sign
    [ -z "$at_sign" ] && at_sign="@"

    echo -en "${YELLOW}Enter hostname (default Rooted): ${RESET}"
    read hostname
    [ -z "$hostname" ] && hostname="Rooted"

    echo -en "${YELLOW}Enter symbol (default #): ${RESET}"
    read symbol
    [ -z "$symbol" ] && symbol="#"

    echo -e "\n${YELLOW}Select color for main structure (┌─[...]─[...] and lines):${RESET}"
    echo -e "  1) ${RED}Red${RESET}     2) ${GREEN}Green${RESET}     3) ${YELLOW}Yellow${RESET}"
    echo -e "  4) ${BLUE}Blue${RESET}    5) ${PURPLE}Purple${RESET}   6) ${CYAN}Cyan${RESET}"
    echo -e "  7) ${WHITE}White${RESET}   8) ${BOLD}Light Red${RESET}  9) ${BOLD}Light Green${RESET}"
    echo -e "  10) ${BOLD}Light Yellow${RESET}"

    local main_color_choice
    while true; do
        echo -en "${YELLOW}Select main color [1-10]: ${RESET}"
        read main_color_choice
        if [[ "$main_color_choice" =~ ^[0-9]+$ ]] && [ "$main_color_choice" -ge 1 ] && [ "$main_color_choice" -le 10 ]; then
            break
        else
            echo -e "${RED}Invalid choice${RESET}"
        fi
    done
    local main_color=$(get_color_code $main_color_choice)

    echo -e "\n${YELLOW}Select color for emoji:${RESET}"
    echo -e "  1) ${RED}Red${RESET}     2) ${GREEN}Green${RESET}     3) ${YELLOW}Yellow${RESET}"
    echo -e "  4) ${BLUE}Blue${RESET}    5) ${PURPLE}Purple${RESET}   6) ${CYAN}Cyan${RESET}"
    echo -e "  7) ${WHITE}White${RESET}   8) ${BOLD}Light Red${RESET}  9) ${BOLD}Light Green${RESET}"
    echo -e "  10) ${BOLD}Light Yellow${RESET}"

    local emoji_color_choice
    while true; do
        echo -en "${YELLOW}Select emoji color [1-10]: ${RESET}"
        read emoji_color_choice
        if [[ "$emoji_color_choice" =~ ^[0-9]+$ ]] && [ "$emoji_color_choice" -ge 1 ] && [ "$emoji_color_choice" -le 10 ]; then
            break
        else
            echo -e "${RED}Invalid choice${RESET}"
        fi
    done
    local emoji_color=$(get_color_code $emoji_color_choice)

    echo -e "\n${YELLOW}Select color for username:${RESET}"
    echo -e "  1) ${RED}Red${RESET}     2) ${GREEN}Green${RESET}     3) ${YELLOW}Yellow${RESET}"
    echo -e "  4) ${BLUE}Blue${RESET}    5) ${PURPLE}Purple${RESET}   6) ${CYAN}Cyan${RESET}"
    echo -e "  7) ${WHITE}White${RESET}   8) ${BOLD}Light Red${RESET}  9) ${BOLD}Light Green${RESET}"
    echo -e "  10) ${BOLD}Light Yellow${RESET}"

    local user_color_choice
    while true; do
        echo -en "${YELLOW}Select username color [1-10]: ${RESET}"
        read user_color_choice
        if [[ "$user_color_choice" =~ ^[0-9]+$ ]] && [ "$user_color_choice" -ge 1 ] && [ "$user_color_choice" -le 10 ]; then
            break
        else
            echo -e "${RED}Invalid choice${RESET}"
        fi
    done
    local user_color=$(get_color_code $user_color_choice)

    echo -e "\n${YELLOW}Select color for separator (${at_sign}):${RESET}"
    echo -e "  1) ${RED}Red${RESET}     2) ${GREEN}Green${RESET}     3) ${YELLOW}Yellow${RESET}"
    echo -e "  4) ${BLUE}Blue${RESET}    5) ${PURPLE}Purple${RESET}   6) ${CYAN}Cyan${RESET}"
    echo -e "  7) ${WHITE}White${RESET}   8) ${BOLD}Light Red${RESET}  9) ${BOLD}Light Green${RESET}"
    echo -e "  10) ${BOLD}Light Yellow${RESET}"

    local at_color_choice
    while true; do
        echo -en "${YELLOW}Select separator color [1-10]: ${RESET}"
        read at_color_choice
        if [[ "$at_color_choice" =~ ^[0-9]+$ ]] && [ "$at_color_choice" -ge 1 ] && [ "$at_color_choice" -le 10 ]; then
            break
        else
            echo -e "${RED}Invalid choice${RESET}"
        fi
    done
    local at_color=$(get_color_code $at_color_choice)

    echo -e "\n${YELLOW}Select color for hostname:${RESET}"
    echo -e "  1) ${RED}Red${RESET}     2) ${GREEN}Green${RESET}     3) ${YELLOW}Yellow${RESET}"
    echo -e "  4) ${BLUE}Blue${RESET}    5) ${PURPLE}Purple${RESET}   6) ${CYAN}Cyan${RESET}"
    echo -e "  7) ${WHITE}White${RESET}   8) ${BOLD}Light Red${RESET}  9) ${BOLD}Light Green${RESET}"
    echo -e "  10) ${BOLD}Light Yellow${RESET}"

    local host_color_choice
    while true; do
        echo -en "${YELLOW}Select hostname color [1-10]: ${RESET}"
        read host_color_choice
        if [[ "$host_color_choice" =~ ^[0-9]+$ ]] && [ "$host_color_choice" -ge 1 ] && [ "$host_color_choice" -le 10 ]; then
            break
        else
            echo -e "${RED}Invalid choice${RESET}"
        fi
    done
    local host_color=$(get_color_code $host_color_choice)

    echo -e "\n${YELLOW}Select color for path (\\w):${RESET}"
    echo -e "  1) ${RED}Red${RESET}     2) ${GREEN}Green${RESET}     3) ${YELLOW}Yellow${RESET}"
    echo -e "  4) ${BLUE}Blue${RESET}    5) ${PURPLE}Purple${RESET}   6) ${CYAN}Cyan${RESET}"
    echo -e "  7) ${WHITE}White${RESET}   8) ${BOLD}Light Red${RESET}  9) ${BOLD}Light Green${RESET}"
    echo -e "  10) ${BOLD}Light Yellow${RESET}"

    local path_color_choice
    while true; do
        echo -en "${YELLOW}Select path color [1-10]: ${RESET}"
        read path_color_choice
        if [[ "$path_color_choice" =~ ^[0-9]+$ ]] && [ "$path_color_choice" -ge 1 ] && [ "$path_color_choice" -le 10 ]; then
            break
        else
            echo -e "${RED}Invalid choice${RESET}"
        fi
    done
    local path_color=$(get_color_code $path_color_choice)

    echo -e "\n${YELLOW}Select color for symbol (${symbol}):${RESET}"
    echo -e "  1) ${RED}Red${RESET}     2) ${GREEN}Green${RESET}     3) ${YELLOW}Yellow${RESET}"
    echo -e "  4) ${BLUE}Blue${RESET}    5) ${PURPLE}Purple${RESET}   6) ${CYAN}Cyan${RESET}"
    echo -e "  7) ${WHITE}White${RESET}   8) ${BOLD}Light Red${RESET}  9) ${BOLD}Light Green${RESET}"
    echo -e "  10) ${BOLD}Light Yellow${RESET}"

    local symbol_color_choice
    while true; do
        echo -en "${YELLOW}Select symbol color [1-10]: ${RESET}"
        read symbol_color_choice
        if [[ "$symbol_color_choice" =~ ^[0-9]+$ ]] && [ "$symbol_color_choice" -ge 1 ] && [ "$symbol_color_choice" -le 10 ]; then
            break
        else
            echo -e "${RED}Invalid choice${RESET}"
        fi
    done
    local symbol_color=$(get_color_code $symbol_color_choice)

    local final_ps1="PS1='${main_color}┌─[${emoji_color}${emoji}\[\\033[0m\] ${user_color}${username}\[\\033[0m\]${at_color}${at_sign}\[\\033[0m\]${host_color}${hostname}\[\\033[0m\]${main_color}]─[${path_color}\\w${main_color}]\\n${main_color}└──╼ ${symbol_color}${symbol}\[\\033[0m\]${main_color} \\[\\033[0m\\] '"

    local tmpfile="${BASHRC_FILE}.tmp"
    cp "$BASHRC_FILE" "$tmpfile"
    sed -i '/^PS1=/d' "$BASHRC_FILE"
    echo "$final_ps1" >> "$BASHRC_FILE"
    rm "$tmpfile"

    echo -e "${GREEN}[✓] Prompt customized successfully${RESET}"
    echo -e "${CYAN}Restart Termux or run 'source $BASHRC_FILE' to see changes${RESET}"
}

main_menu() {
    while true; do
        echo -e "\n${CYAN}════════════════════════════════════${RESET}"
        echo -e "${YELLOW}   Termux Beauty  ${RESET}"
        echo -e "${CYAN}════════════════════════════════════${RESET}"
        echo "1) Change Banner (MOTD) - Logo + Text"
        echo "2) Change Prompt - Customize your prompt"
        echo "3) Reset to default"
        echo "4) Exit"
        echo -en "${YELLOW}Choose [1-4]: ${RESET}"
        read opt

        case $opt in
            1) backup_files; change_motd ;;
            2) backup_files; change_prompt ;;
            3) restore_default ;;
            4) echo -e "${GREEN}Goodbye!${RESET}"; break ;;
            *) echo -e "${RED}Invalid option${RESET}" ;;
        esac
    done
}

case "$1" in
    --help|-h) show_help ;;
    --motd) backup_files; change_motd ;;
    --prompt) backup_files; change_prompt ;;
    --reset) restore_default ;;
    --menu) main_menu ;;
    *) main_menu ;;
esac
