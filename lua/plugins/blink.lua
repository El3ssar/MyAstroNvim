return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- make sure keymap table exists
      opts.keymap = opts.keymap or {}

      -- add/override your mappings
      opts.keymap["<CR>"] = { "select_and_accept", "fallback" }
      opts.keymap["<Esc>"] = {
        function(cmp)
          if cmp.is_visible() then
            cmp.cancel() -- or cmp.hide()
            return true
          end
        end,
        "fallback",
      }
      return opts
    end,
  },
}
