# MyAstroNvim

Personal Neovim config on top of [AstroNvim](https://github.com/AstroNvim/AstroNvim) **v6** (Neovim **0.12+**), set up for **macOS** + **kitty**.

## Install (macOS)

```shell
brew install neovim git ripgrep fd lazygit node btop ncurses pkg-config
xcode-select --install                 # C compiler (treesitter parsers, cbonsai)
rustup component add rust-analyzer     # Rust LSP
```

Use a [Nerd Font](https://www.nerdfonts.com/) in your terminal. Back up any existing config, then:

```shell
git clone https://github.com/El3ssar/MyAstroNvim ~/.config/nvim
nvim
```

Plugins, LSPs (via Mason) and treesitter parsers install on first start.
The dashboard's cbonsai is compiled into `bin/` on first launch (not tracked in git).

### kitty

- `macos_option_as_alt left` — left Option acts as Alt for the mappings below.
- `allow_remote_control yes` + `listen_on unix:/tmp/mykitty` — needed by vim-kitty-navigator.
- Its `*.py` kittens are copied into `~/.config/kitty/` when the plugin is installed/updated.

## Layout

```
init.lua                bootstrap lazy.nvim
lua/lazy_setup.lua      AstroNvim + lazy.nvim options
lua/community.lua       AstroCommunity packs: lua, python (basedpyright + ruff), rust, copilot, rainbow delimiters
lua/plugins/
  astrocore.lua         options, diagnostics, autocmds
  astroui.lua           colorscheme (github_dark_dimmed), highlights, icons
  mappings.lua          all custom keymaps
  treesitter.lua        parsers + folding
  snacks.lua            dashboard (live cbonsai) + smooth scroll
  kitty.lua             kitty integration (no-op outside kitty)
  cheatsheet.lua        F1 cheatsheet generated from your leader maps
  blink.lua, neotree.lua, which-key.lua, flatten.lua   small plugin tweaks
bin/cbonsai.sh          builds + runs cbonsai for the dashboard
```

## Custom keys

| Key | Mode | Action |
| --- | --- | --- |
| `F1` | n | Cheatsheet |
| `F4` | n/i/x | Format file / selection |
| `;` | n | `:` |
| `Ctrl-a` | n/i/x | Select all |
| `Alt-Shift-Up/Down` | n/i/x/s | Move line / selection (re-indents) |
| `Alt-[` / `Alt-]` | n/i | Close / open fold |
| `Alt-Arrows` | n | Move between splits (and kitty windows) |
| `Ctrl-Shift-Arrows` | n | Resize split |
| `Alt-Space` | i | Open completion menu |
| `Shift-Arrows` | n/i | Start a selection |
| `Arrows` | x | Collapse selection to that edge |
| `<Leader>c` | n | Close buffer (dashboard if it was the last) |
| `<Leader>tt` | n | btop in a float |
| `Enter` / `Esc` | completion | Accept / close menu |
| `Left` / `Right` | neo-tree | Collapse / expand |

macOS takes `Ctrl-Arrows` (Mission Control / Spaces) and `Ctrl-Space` (input source),
hence the Ctrl-Shift / Alt alternatives. kitty.conf passes `Ctrl-Shift-Arrows` to nvim
via the `in_editor` user var.
