-- Snacks: smooth scrolling and the start dashboard (with a live cbonsai tree).

local cbonsai = vim.fn.stdpath "config" .. "/bin/cbonsai.sh"

---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = {
    scroll = {
      animate = {
        duration = { step = 15, total = 200 },
        easing = "linear",
      },
      -- faster animation when repeating a scroll shortly after the last one
      animate_repeat = {
        delay = 100,
        duration = { step = 5, total = 50 },
        easing = "linear",
      },
      filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype ~= "terminal"
      end,
    },
    dashboard = {
      preset = {
        header = table.concat({
          "███╗   ██╗ ██████╗ ██╗   ██╗ █████╗ ",
          "████╗  ██║██╔═══██╗██║   ██║██╔══██╗",
          "██╔██╗ ██║██║   ██║██║   ██║███████║",
          "██║╚██╗██║██║   ██║╚██╗ ██╔╝██╔══██║",
          "██║ ╚████║╚██████╔╝ ╚████╔╝ ██║  ██║",
          "╚═╝  ╚═══╝ ╚═════╝   ╚═══╝  ╚═╝  ╚═╝",
          "                                    ",
          "███╗   ██╗██╗   ██╗██╗███╗   ███╗   ",
          "████╗  ██║██║   ██║██║████╗ ████║   ",
          "██╔██╗ ██║██║   ██║██║██╔████╔██║   ",
          "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║   ",
          "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║   ",
          "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝   ",
          "                                    ",
        }, "\n"),
        keys = {
          { icon = " ", key = "n", desc = "New file", action = "<Leader>n" },
          { icon = " ", key = "f", desc = "Find files", action = "<Leader>ff" },
          { icon = " ", key = "r", desc = "Recent files", action = "<Leader>fo" },
          { icon = " ", key = "e", desc = "Explorer", action = "<Leader>e" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, align = "left", padding = 1 },
        { section = "startup" },
        -- right pane: live cbonsai (built on first run, see bin/cbonsai.sh)
        {
          pane = 2,
          section = "terminal",
          enabled = function() return vim.fn.executable(cbonsai) == 1 end,
          cmd = vim.fn.shellescape(cbonsai) .. " --live -c 0,1 -i",
          height = 30,
          padding = 0,
          ttl = 0, -- don't cache the animation output
        },
      },
    },
  },
}
