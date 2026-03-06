#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

set -euo pipefail

# Grab sudo password
if [ "$EUID" -ne 0 ]; then
    echo -e "${CYAN}${BOLD}Gamescope Session Installer — sudo required${RESET}"
    echo ""
    sudo -v 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗ Failed to authenticate. Exiting.${RESET}"
        exit 1
    fi
    exec sudo bash "$0" "$@"
fi

clear
echo -e "${BOLD}${CYAN}"
echo "  ╔═════════════════════════════════╗"
echo "  ║   Gamescope Session Installer   ║"
echo "  ╚═════════════════════════════════╝"
echo -e "${RESET}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

STEAMOS_POLKIT_HELPERS_DIR="steamos-polkit-helpers"
USR_BIN_DIR="/usr/bin"
WAYLAND_SESSIONS_DIR="/usr/share/wayland-sessions"

SRC_BIN="$SCRIPT_DIR$USR_BIN_DIR"
SRC_WAYLAND="$SCRIPT_DIR$WAYLAND_SESSIONS_DIR"

require_file() {
    if [ ! -f "$1" ]; then
        echo -e "${RED}✗ Missing source file: $1${RESET}"
        exit 1
    fi
}

info()    { echo -e "${CYAN}  →  $1${RESET}"; }
success() { echo -e "${GREEN}  ✔  $1${RESET}"; }
warn()    { echo -e "${YELLOW}  ⚠  $1${RESET}"; }
fatal()   { echo -e "${RED}  ✗  $1${RESET}"; exit 1; }

# checks
echo -e "${BOLD}Verifying source files...${RESET}"

require_file "$SRC_BIN/gamescope-session"
require_file "$SRC_BIN/jupiter-biosupdate"
require_file "$SRC_BIN/$STEAMOS_POLKIT_HELPERS_DIR/jupiter-biosupdate"
require_file "$SRC_BIN/steamos-select-branch"
require_file "$SRC_BIN/steamos-session-select"
require_file "$SRC_BIN/steamos-update"
require_file "$SRC_BIN/$STEAMOS_POLKIT_HELPERS_DIR/steamos-update"
require_file "$SRC_BIN/$STEAMOS_POLKIT_HELPERS_DIR/steamos-set-timezone"
require_file "$SRC_WAYLAND/gamescope.desktop"

success "All source files present"
echo ""

# Create directories
echo -e "${BOLD}Preparing directories...${RESET}"

mkdir -p "$USR_BIN_DIR/$STEAMOS_POLKIT_HELPERS_DIR"
success "Polkit helpers directory ready"
echo ""

# Copy files
echo -e "${BOLD}Installing files...${RESET}"

cp "$SRC_BIN/gamescope-session"                                    "$USR_BIN_DIR/gamescope-session"
info "gamescope-session"

cp "$SRC_BIN/jupiter-biosupdate"                                   "$USR_BIN_DIR/jupiter-biosupdate"
cp "$SRC_BIN/$STEAMOS_POLKIT_HELPERS_DIR/jupiter-biosupdate"       "$USR_BIN_DIR/$STEAMOS_POLKIT_HELPERS_DIR/jupiter-biosupdate"
info "jupiter-biosupdate"

cp "$SRC_BIN/steamos-select-branch"                                "$USR_BIN_DIR/steamos-select-branch"
info "steamos-select-branch"

cp "$SRC_BIN/steamos-session-select"                               "$USR_BIN_DIR/steamos-session-select"
info "steamos-session-select"

cp "$SRC_BIN/steamos-update"                                       "$USR_BIN_DIR/steamos-update"
cp "$SRC_BIN/$STEAMOS_POLKIT_HELPERS_DIR/steamos-update"           "$USR_BIN_DIR/$STEAMOS_POLKIT_HELPERS_DIR/steamos-update"
info "steamos-update"

cp "$SRC_BIN/$STEAMOS_POLKIT_HELPERS_DIR/steamos-set-timezone"     "$USR_BIN_DIR/$STEAMOS_POLKIT_HELPERS_DIR/steamos-set-timezone"
info "steamos-set-timezone"

cp "$SRC_WAYLAND/gamescope.desktop"                                    "$WAYLAND_SESSIONS_DIR/gamescope.desktop"
info "gamescope.desktop"

success "All files installed"
echo ""

# Set permissions
echo -e "${BOLD}Setting permissions...${RESET}"

chmod 755 "$USR_BIN_DIR/gamescope-session"
chmod 755 "$USR_BIN_DIR/jupiter-biosupdate"
chmod 755 "$USR_BIN_DIR/$STEAMOS_POLKIT_HELPERS_DIR/jupiter-biosupdate"
chmod 755 "$USR_BIN_DIR/steamos-select-branch"
chmod 755 "$USR_BIN_DIR/steamos-session-select"
chmod 755 "$USR_BIN_DIR/steamos-update"
chmod 755 "$USR_BIN_DIR/$STEAMOS_POLKIT_HELPERS_DIR/steamos-update"
chmod 755 "$USR_BIN_DIR/$STEAMOS_POLKIT_HELPERS_DIR/steamos-set-timezone"
chmod 644 "$WAYLAND_SESSIONS_DIR/gamescope.desktop"

success "Permissions applied"
echo ""

echo -e "${BOLD}${GREEN}"
echo "  ╔═══════════════════════════════════╗"
echo "  ║      Installation Complete  ✔     ║"
echo "  ╚═══════════════════════════════════╝"
echo -e "${RESET}"
