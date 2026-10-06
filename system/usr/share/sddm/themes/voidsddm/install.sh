#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERROR] This script must be run as root.${NC}"
  echo -e "${YELLOW}Please run with sudo: ${NC}sudo $0"
  exit 1
fi

if ! command -v git &> /dev/null; then
    echo -e "${RED}[ERROR] 'git' is not installed. Please install it first to continue.${NC}"
    exit 1
fi

THEME_FLAG=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --theme) THEME_FLAG="$2"; shift ;;
        *) echo -e "${RED}[ERROR] Unknown parameter passed: $1${NC}"; exit 1 ;;
    esac
    shift
done

if [ -n "$THEME_FLAG" ]; then
    case "${THEME_FLAG,,}" in
        default) THEME_FILE="configs/default.conf"; THEME_NAME="Default" ;;
        gruvbox) THEME_FILE="configs/gruvbox.conf"; THEME_NAME="Gruvbox" ;;
        everforest) THEME_FILE="configs/everforest.conf"; THEME_NAME="Everforest" ;;
        catppuccin) THEME_FILE="configs/catppuccin.conf"; THEME_NAME="Catppuccin Mocha" ;;
        nord) THEME_FILE="configs/nord.conf"; THEME_NAME="Nord" ;;
        tokyonight) THEME_FILE="configs/tokyonight.conf"; THEME_NAME="Tokyo Night" ;;
        *) echo -e "${RED}[ERROR] Invalid theme. Valid options: default, gruvbox, everforest, catppuccin, nord, tokyonight.${NC}"; exit 1 ;;
    esac
fi

if [ -z "$THEME_NAME" ]; then
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}        Void SDDM Theme Installer         ${NC}"
    echo -e "${CYAN}==========================================\n${NC}"

    echo -e "${BLUE}Choose the desired color scheme:${NC}"
    echo "1) Default (Black)"
    echo "2) Gruvbox"
    echo "3) Everforest"
    echo "4) Catppuccin Mocha"
    echo "5) Nord"
    echo "6) Tokyo Night"
    echo ""

    while true; do
        read -p "Enter the option number (1-6): " OPTION
        case $OPTION in
            1) THEME_FILE="configs/default.conf"; THEME_NAME="Default"; break;;
            2) THEME_FILE="configs/gruvbox.conf"; THEME_NAME="Gruvbox"; break;;
            3) THEME_FILE="configs/everforest.conf"; THEME_NAME="Everforest"; break;;
            4) THEME_FILE="configs/catppuccin.conf"; THEME_NAME="Catppuccin Mocha"; break;;
            5) THEME_FILE="configs/nord.conf"; THEME_NAME="Nord"; break;;
            6) THEME_FILE="configs/tokyonight.conf"; THEME_NAME="Tokyo Night"; break;;
            *) echo -e "${RED}[ERROR] Invalid option. Please try again.${NC}";;
        esac
    done
fi

echo -e "\n${YELLOW}[INFO] Preparing to install version: ${THEME_NAME}...${NC}"

LOCAL_INSTALL=false
if [ -f "metadata.desktop" ] && [ -d "configs" ]; then
    LOCAL_INSTALL=true
    echo -e "${YELLOW}[INFO] Local repository detected. Using local files...${NC}"
    SOURCE_DIR="."
else
    echo -e "${YELLOW}[INFO] Cloning GitHub repository...${NC}"
    TEMP_DIR=$(mktemp -d)
    if git clone https://github.com/talyamm/voidsddm.git "$TEMP_DIR/voidsddm" --quiet; then
        echo -e "${GREEN}[SUCCESS] Repository cloned successfully.${NC}"
        SOURCE_DIR="$TEMP_DIR/voidsddm"
    else
        echo -e "${RED}[ERROR] Failed to clone repository.${NC}"
        rm -rf "$TEMP_DIR"
        exit 1
    fi
fi

echo -e "${YELLOW}[INFO] Copying files to /usr/share/sddm/themes/...${NC}"
mkdir -p /usr/share/sddm/themes/voidsddm
rm -rf /usr/share/sddm/themes/voidsddm/*
if cp -r "$SOURCE_DIR/." /usr/share/sddm/themes/voidsddm/; then
    rm -rf /usr/share/sddm/themes/voidsddm/.git
    echo -e "${GREEN}[SUCCESS] Files copied.${NC}"
else
    echo -e "${RED}[ERROR] Failed to copy files. Installation aborted.${NC}"
    [ "$LOCAL_INSTALL" = false ] && rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "${YELLOW}[INFO] Applying color scheme: ${THEME_NAME}...${NC}"
METADATA_FILE="/usr/share/sddm/themes/voidsddm/metadata.desktop"
if [ -f "$METADATA_FILE" ]; then
    sed -i "s|^ConfigFile=.*|ConfigFile=$THEME_FILE|" "$METADATA_FILE"
    echo -e "${GREEN}[SUCCESS] Color scheme applied.${NC}"
else
    echo -e "${RED}[ERROR] metadata.desktop file not found. Theme may not work properly.${NC}"
fi

echo -e "${YELLOW}[INFO] Configuring SDDM...${NC}"
SDDM_CONF="/etc/sddm.conf"

if [ ! -f "$SDDM_CONF" ]; then
    echo -e "[Theme]\nCurrent=voidsddm" > "$SDDM_CONF"
else
    if grep -q "^\[Theme\]" "$SDDM_CONF"; then
        if grep -q "^Current=" "$SDDM_CONF"; then
            sed -i 's/^Current=.*/Current=voidsddm/' "$SDDM_CONF"
        else
            sed -i '/^\[Theme\]/a Current=voidsddm' "$SDDM_CONF"
        fi
    else
        echo -e "\n[Theme]\nCurrent=voidsddm" >> "$SDDM_CONF"
    fi
fi
echo -e "${GREEN}[SUCCESS] SDDM configured to use 'voidsddm'.${NC}"

[ "$LOCAL_INSTALL" = false ] && rm -rf "$TEMP_DIR"

echo -e "\n${CYAN}==========================================${NC}"
echo -e "${GREEN}[SUCCESS] Installation completed successfully!${NC}"
echo -e "${CYAN}==========================================${NC}"
echo -e "Theme: ${THEME_NAME}"
echo -e "\nTo preview the theme without logging out, run:"
echo -e "${BLUE}sddm-greeter --test-mode --theme /usr/share/sddm/themes/voidsddm${NC}\n"