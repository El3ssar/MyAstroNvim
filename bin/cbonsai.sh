#!/usr/bin/env bash
set -e

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
BIN_DIR="$CONFIG_DIR/bin"
CBONSAI_BIN="$BIN_DIR/cbonsai"
REPO="https://github.com/El3ssar/cbonsai.git"

mkdir -p "$BIN_DIR"

if [ ! -x "$CBONSAI_BIN" ]; then
	echo "[cbonsai] binary not found, building..."
	tmpdir=$(mktemp -d)
	CLONED_REPO="$tmpdir/cbonsai"
	git clone --depth 1 "$REPO" "$CLONED_REPO"

	cc -Wall -Wextra -Wshadow -Wpointer-arith -Wcast-qual -pedantic $(pkg-config --cflags ncursesw panelw) -o "$BIN_DIR/cbonsai" "$CLONED_REPO/cbonsai.c" $(pkg-config --libs ncursesw panelw || echo "-lncursesw -ltinfo -lpanelw")

	rm -rf "$tmpdir"
	echo "[cbonsai] built at $CBONSAI_BIN"
fi

exec "$CBONSAI_BIN" "$@"
