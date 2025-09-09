---@type LazySpec
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.window = opts.window or {}
      opts.window.mappings = vim.tbl_extend("force", opts.window.mappings or {}, {
        ["<Left>"] = "parent_or_close",
        ["<Right>"] = "child_or_open", -- or "toggle_node" if you prefer
      })
    end,
  },
}
