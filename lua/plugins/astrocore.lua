-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- disable heavy features above this size
      autopairs = true,       -- enable autopairs at start
      cmp = true,             -- enable completion at start
      -- virtual_lines intentionally kept on: shows full diagnostics inline.
      -- Set virtual_lines = false if you find it too noisy alongside virtual_text.
      diagnostics = { virtual_text = true, virtual_lines = true },
      highlighturl = true,    -- highlight URLs at start
      notifications = true,   -- enable notifications at start
    },
    -- Diagnostics configuration passed to vim.diagnostic.config()
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options
    options = {
      opt = {
        relativenumber = false,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = true,
        mouse = "a",
        mousemodel = "extend",
      },
    },
    mappings = {
      n = {
        ["<Leader>c"] = {
          function()
            local bufs = vim.fn.getbufinfo { buflisted = 1 }
            require("astrocore.buffer").close(0)
            -- snacks.dashboard is a module table, not a function — use .open()
            if not bufs[2] then require("snacks").dashboard.open() end
          end,
          desc = "Close buffer",
        },
      },
    },
  },
}
