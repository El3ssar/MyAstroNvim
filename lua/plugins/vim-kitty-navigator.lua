return {
  {
    "knubie/vim-kitty-navigator",
    lazy = false, -- ⬅ force load at startup
    build = "cp ./*.py ~/.config/kitty/",
    init = function() vim.g.kitty_navigator_no_mappings = 1 end,
    config = function()
      local map, o = vim.keymap.set, { silent = true, noremap = true }
      map("n", "<M-Left>", "<Cmd>KittyNavigateLeft<CR>", o)
      map("n", "<M-Down>", "<Cmd>KittyNavigateDown<CR>", o)
      map("n", "<M-Up>", "<Cmd>KittyNavigateUp<CR>", o)
      map("n", "<M-Right>", "<Cmd>KittyNavigateRight<CR>", o)
    end,
  },
}
