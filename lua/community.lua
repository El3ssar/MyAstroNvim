-- AstroCommunity imports. Loaded before lua/plugins/ so user specs can override them.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- language packs
  { import = "astrocommunity.pack.lua" },
  -- python: basedpyright (types/completion) + ruff (lint, format, imports)
  { import = "astrocommunity.pack.python.base" },
  { import = "astrocommunity.pack.python.basedpyright" },
  { import = "astrocommunity.pack.python.ruff" },
  { import = "astrocommunity.pack.rust" },
  -- Copilot as a blink.cmp source
  { import = "astrocommunity.completion.blink-copilot" },
  -- editing
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
}
