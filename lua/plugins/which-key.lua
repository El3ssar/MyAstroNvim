-- which-key: only pop up for <Leader> (normal, visual, operator-pending).
-- Avoids the popup appearing on every mode change in visual/select mode.

---@type LazySpec
return {
  "folke/which-key.nvim",
  opts = {
    triggers = { { "<Leader>", mode = { "n", "x", "o" } } },
  },
}
