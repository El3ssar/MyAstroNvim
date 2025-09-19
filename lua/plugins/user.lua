-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    -- Load on start so the dashboard is ready on VimEnter
    lazy = false,
    priority = 1000,
    opts = {
      scroll = {
        animate = {
          duration = { step = 15, total = 200 },
          easing = "linear",
        },
        -- faster animation when repeating scroll after delay
        animate_repeat = {
          delay = 100, -- delay in ms before using the repeat animation
          duration = { step = 5, total = 50 },
          easing = "linear",
        },
        -- what buffers to animate
        filter = function(buf)
          return vim.g.snacks_scroll ~= false
            and vim.b[buf].snacks_scroll ~= false
            and vim.bo[buf].buftype ~= "terminal"
        end,
      },
      dashboard = {
        preset = {
          header = table.concat({
            -- 3D-styled ASCII “NovaNvim” (shadow offset)
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

          -- Quick actions (adjust to taste)
          keys = {
            { icon = " ", key = "n", desc = "New file", action = "<leader>n" },
            { icon = " ", key = "f", desc = "Find files", action = "<leader>ff" },
            { icon = " ", key = "o", desc = "Open files", action = "<leader>o" },
            { icon = " ", key = "q", desc = "Quit", action = ":q" },
          },
        },
        -- nice margins
        sections = {
          -- LEFT:
          -- Spacer to push left column down
          -- { pane = 1, section = "text", text = " ", padding = { 6, 0 }, gap = 0 },
          -- readable header
          {
            section = "header",
          },
          -- keys
          { section = "keys", gap = 1, align = "left", padding = 1 },
          -- RIGHT:
          -- live cbonsai (PTY handled by Snacks)
          {
            pane = 2,
            section = "terminal",
            cmd = "~/.config/nvim/bin/cbonsai.sh --live -c 0,1 -i",
            height = 30,
            padding = { 0, 0 },
            gap = 0,
          },
          { section = "startup" },
        },
      },
    },
  },
}
