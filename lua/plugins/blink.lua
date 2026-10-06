-- Completion: Enter accepts (selecting the first item if needed), Esc closes the menu.
-- Alt+Space opens the menu manually (macOS grabs Ctrl+Space for switching input source).

---@type LazySpec
return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      ["<M-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<CR>"] = { "select_and_accept", "fallback" },
      ["<Esc>"] = {
        function(cmp)
          if cmp.is_visible() then
            cmp.cancel()
            return true
          end
        end,
        "fallback",
      },
    },
  },
}
