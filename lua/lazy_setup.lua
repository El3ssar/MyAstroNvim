require("lazy").setup({
  {
    "AstroNvim/AstroNvim",
    version = "^6", -- AstroNvim v6 targets Neovim 0.12+
    import = "astronvim.plugins",
    opts = { -- AstroNvim options must be set here with the `import` key
      mapleader = " ",
      maplocalleader = ",",
      icons_enabled = true, -- requires a Nerd Font in the terminal
      pin_plugins = nil, -- pin plugins when tracking a `version` of AstroNvim
      update_notifications = true,
    },
  },
  { import = "community" },
  { import = "plugins" },
} --[[@as LazySpec]], {
  install = { colorscheme = { "github_dark_dimmed", "astrotheme", "habamax" } },
  ui = { backdrop = 100 },
  rocks = { enabled = false }, -- no plugin needs luarocks
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
} --[[@as LazyConfig]])
