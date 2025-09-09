---@type LazySpec
return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      -- Stop auto triggers in visual/select (no ModeChanged there),
      -- but keep normal & operator-pending auto behavior.
      opts.triggers = { { "<leader>", mode = { "n", "x", "o" } } }
      return opts
    end,
  },
}
