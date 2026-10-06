-- Neo-tree: Left/Right arrows collapse/expand like a regular file tree.

---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        ["<Left>"] = "parent_or_close",
        ["<Right>"] = "child_or_open",
      },
    },
  },
}
