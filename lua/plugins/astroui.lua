-- Colorscheme, highlight overrides and icons (see `:h astroui`).

---@type LazySpec
return {
  { "projekt0n/github-nvim-theme", name = "github-theme", lazy = true },
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "github_dark_dimmed",
      highlights = {
        init = { -- applies to every colorscheme
          -- Builtin gitcommit syntax (treesitter is off for git buffers, see treesitter.lua):
          -- subject text past 50 chars turns red, the rest of the subject is coloured.
          gitcommitOverflow = { link = "Error" },
          gitcommitSummary = { link = "String" },
        },
      },
      icons = {
        -- LSP loading spinner in the statusline
        LSPLoading1 = "⠋",
        LSPLoading2 = "⠙",
        LSPLoading3 = "⠹",
        LSPLoading4 = "⠸",
        LSPLoading5 = "⠼",
        LSPLoading6 = "⠴",
        LSPLoading7 = "⠦",
        LSPLoading8 = "⠧",
        LSPLoading9 = "⠇",
        LSPLoading10 = "⠏",
      },
    },
  },
}
