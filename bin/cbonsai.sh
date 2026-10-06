#!/usr/bin/env bash
# Runs cbonsai for the dashboard, building it on first use (or if the binary
# can't run on this machine, e.g. it was copied from another OS/arch).
set -euo pipefail

BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CBONSAI_BIN="$BIN_DIR/cbonsai"
REPO="https://github.com/El3ssar/cbonsai.git"

build() {
	echo "[cbonsai] building..."
	local tmpdir
	tmpdir=$(mktemp -d)
	trap 'rm -rf "$tmpdir"' RETURN
	git clone --quiet --depth 1 "$REPO" "$tmpdir/cbonsai"

	# Homebrew's ncurses is keg-only, so point pkg-config at it when present.
	if command -v brew >/dev/null 2>&1; then
		local prefix
		prefix=$(brew --prefix ncurses 2>/dev/null || true)
		[ -d "$prefix/lib/pkgconfig" ] && export PKG_CONFIG_PATH="$prefix/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
	fi

	local cflags libs
	if pkg-config --exists ncursesw panelw 2>/dev/null; then
		cflags=$(pkg-config --cflags ncursesw panelw)
		libs=$(pkg-config --libs ncursesw panelw)
	elif [ "$(uname)" = Darwin ]; then
		# macOS system ncurses already has wide-char support
		cflags="-D_XOPEN_SOURCE_EXTENDED"
		libs="-lncurses -lpanel"
	else
		cflags=""
		libs="-lncursesw -ltinfo -lpanelw"
	fi

	# shellcheck disable=SC2086
	cc -O2 -Wall -Wextra -Wshadow -Wpointer-arith -Wcast-qual -pedantic $cflags \
		-o "$CBONSAI_BIN" "$tmpdir/cbonsai/cbonsai.c" $libs
	echo "[cbonsai] built at $CBONSAI_BIN"
}

if [ ! -x "$CBONSAI_BIN" ] || ! "$CBONSAI_BIN" --help >/dev/null 2>&1; then
	build
fi

exec "$CBONSAI_BIN" "$@"
