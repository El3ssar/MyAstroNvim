return {
  {
    "AstroNvim/astrocore",
    init = function() vim.opt.keymodel:append { "startsel", "stopsel" } end,
    opts = {
      mappings = {
        n = {

          -- Simple yet very useful (Thanks nvchad)
          [";"] = { ":", desc = "Colon when semicolon" },

          -- Move current line
          ["<C-Up>"] = { ":m .-2<CR>==", desc = "Move line up", silent = true, noremap = true },
          ["<C-Down>"] = { ":m .+1<CR>==", desc = "Move line down", silent = true, noremap = true },

          -- Folding
          ["<A-[>"] = { "zc", desc = "Close fold" },
          ["<A-]>"] = { "zo", desc = "Open fold" },

          -- Select all
          ["<C-a>"] = { "ggVG", desc = "Select all" },
        },
        i = {
          -- Move current line
          ["<A-S-Up>"] = { "<Esc>:m .-2<CR>==gi", desc = "Move line up", silent = true, noremap = true },
          ["<A-S-Down>"] = { "<Esc>:m .+1<CR>==gi", desc = "Move line down", silent = true, noremap = true },

          -- Folding
          ["<A-[>"] = { "<C-o>zc", desc = "Close fold" },
          ["<A-]>"] = { "<C-o>zo", desc = "Open fold" },

          -- Select all
          ["<C-a>"] = { "<Esc>ggVG", desc = "Select all" },
        },
        v = {

          -- Move selection
          ["<A-S-Up>"] = { ":m '<-2<CR>gv=gv", desc = "Move block up", silent = true, noremap = true },
          ["<A-S-Down>"] = { ":m '>+1<CR>gv=gv", desc = "Move block down", silent = true, noremap = true },

          -- Select all
          ["<C-a>"] = { "ggVG", desc = "Select all" },
        },
        x = {
          ["<Left>"] = { "<Esc>`<", desc = "Cursor to left edge of selection" },
          ["<Right>"] = {
            function()
              local vtype = vim.fn.visualmode()
              if vtype == "v" and vim.o.selection ~= "inclusive" then
                return "<Esc>`>h"
              else
                return "<Esc>`>"
              end
            end,
            expr = true,
            desc = "Cursor to right edge of selection",
          },
          ["<Up>"] = { "<Esc>`<0", desc = "Cursor to top line of selection" },
          ["<Down>"] = { "<Esc>`>$", desc = "Cursor to bottom line of selection" },

          ["<A-S-Up>"] = { ":m '<-2<CR>gv-gv", desc = "Move block up", silent = true, noremap = true },
          ["<A-S-Down>"] = { ":m '>+1<CR>gv-gv", desc = "Move block down", silent = true, noremap = true },
        },
        s = {
          ["<Right>"] = { "<Esc>`>", desc = "Stop Select at end of selection" },

          ["<A-S-Up>"] = { "<Esc>:m '<-2<CR>gv-gv", desc = "Move block up", silent = true, noremap = true },
          ["<A-S-Down>"] = { "<Esc>:m '>+1<CR>gv-gv", desc = "Move block down", silent = true, noremap = true },
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    opts = {
      mappings = {
        n = {
          ["<F4>"] = { function() vim.cmd "Format" end, desc = "Format file" },
        },
        i = {
          ["<F4>"] = { function() vim.cmd "Format" end, desc = "Format file" },
        },
        v = {
          ["<F4>"] = { function() vim.cmd "Format" end, desc = "Format file" },
        },
      },
    },
  },
}
