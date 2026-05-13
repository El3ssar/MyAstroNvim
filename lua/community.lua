-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.rust" },
  -- blink-copilot is the correct Copilot integration for blink.cmp (AstroNvim v5 default)
  -- copilot-lua-cmp was for nvim-cmp and is incompatible with blink.cmp
  { import = "astrocommunity.completion.blink-copilot" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },

  -- import/override with your plugins folder
}
