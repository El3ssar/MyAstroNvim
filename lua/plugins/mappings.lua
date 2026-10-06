-- All custom key mappings.
-- macOS notes: Alt = left Option in kitty (`macos_option_as_alt left`).
-- Ctrl+arrows are taken by macOS (Mission Control / Spaces), so splits are
-- resized with Ctrl+Shift+arrows instead (kitty.conf passes them to nvim).

--- Move the current line `delta` lines (respects count), re-indent, keep cursor column.
local function move_line(delta)
  local count = vim.v.count1 * delta
  local lnum, last = vim.fn.line ".", vim.fn.line "$"
  local dest = math.max(1, math.min(last, lnum + count))
  if dest == lnum then return end
  local col = vim.fn.col "."
  local indent = vim.fn.indent(lnum)
  vim.cmd(("silent move %d"):format(dest > lnum and dest or dest - 1))
  vim.cmd "silent normal! =="
  local new_col = math.max(1, col + vim.fn.indent(dest) - indent)
  vim.api.nvim_win_set_cursor(0, { dest, new_col - 1 })
end

--- Move the visual/select-mode selection `delta` lines, re-indent and reselect it.
local function move_selection(delta)
  local mode = vim.fn.mode()
  local first, last = vim.fn.line "v", vim.fn.line "."
  if first > last then
    first, last = last, first
  end
  local count = vim.v.count1 * delta
  local dest_first = math.max(1, math.min(vim.fn.line "$" - (last - first), first + count))
  if dest_first == first then return end
  vim.cmd.normal { vim.keycode "<Esc>", bang = true }
  vim.cmd(
    ("silent %d,%dmove %d"):format(first, last, dest_first > first and last + (dest_first - first) or dest_first - 1)
  )
  vim.cmd "silent normal! gv=gv"
  if mode:match "^[sS\19]" then vim.cmd.normal { vim.keycode "<C-g>", bang = true } end
end

local function format_buffer() vim.lsp.buf.format(require("astrolsp").format_opts) end

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          [";"] = { ":", desc = "Command line" },
          ["<C-a>"] = { "ggVG", desc = "Select all" },

          ["<A-S-Up>"] = { function() move_line(-1) end, desc = "Move line up" },
          ["<A-S-Down>"] = { function() move_line(1) end, desc = "Move line down" },

          ["<A-[>"] = { "zc", desc = "Close fold" },
          ["<A-]>"] = { "zo", desc = "Open fold" },

          ["<C-S-Up>"] = { function() require("smart-splits").resize_up() end, desc = "Resize split up" },
          ["<C-S-Down>"] = { function() require("smart-splits").resize_down() end, desc = "Resize split down" },
          ["<C-S-Left>"] = { function() require("smart-splits").resize_left() end, desc = "Resize split left" },
          ["<C-S-Right>"] = { function() require("smart-splits").resize_right() end, desc = "Resize split right" },

          ["<Leader>c"] = {
            function()
              local last = not vim.fn.getbufinfo({ buflisted = 1 })[2]
              require("astrocore.buffer").close(0)
              if last then require("snacks").dashboard.open() end
            end,
            desc = "Close buffer",
          },
          -- prefer btop over AstroNvim's default (btm) when available
          ["<Leader>tt"] = vim.fn.executable "btop" == 1
              and {
                function() require("astrocore").toggle_term_cmd { cmd = "btop", direction = "float" } end,
                desc = "ToggleTerm btop",
              }
            or nil,
        },
        i = {
          ["<C-a>"] = { "<Esc>ggVG", desc = "Select all" },

          ["<A-S-Up>"] = { function() move_line(-1) end, desc = "Move line up" },
          ["<A-S-Down>"] = { function() move_line(1) end, desc = "Move line down" },

          ["<A-[>"] = { "<C-o>zc", desc = "Close fold" },
          ["<A-]>"] = { "<C-o>zo", desc = "Open fold" },
        },
        v = { -- visual + select
          ["<A-S-Up>"] = { function() move_selection(-1) end, desc = "Move selection up" },
          ["<A-S-Down>"] = { function() move_selection(1) end, desc = "Move selection down" },
        },
        x = {
          ["<C-a>"] = { "<Esc>ggVG", desc = "Select all" },

          -- arrows collapse the selection to its edge
          ["<Left>"] = { "<Esc>`<", desc = "Cursor to left edge of selection" },
          ["<Right>"] = {
            function()
              if vim.fn.mode() == "v" and vim.o.selection ~= "inclusive" then return "<Esc>`>h" end
              return "<Esc>`>"
            end,
            expr = true,
            desc = "Cursor to right edge of selection",
          },
          ["<Up>"] = { "<Esc>`<0", desc = "Cursor to top line of selection" },
          ["<Down>"] = { "<Esc>`>$", desc = "Cursor to bottom line of selection" },
        },
        s = {
          ["<Right>"] = { "<Esc>`>", desc = "Stop selection at its end" },
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = { ["<F4>"] = { format_buffer, desc = "Format file", cond = "textDocument/formatting" } },
        i = { ["<F4>"] = { format_buffer, desc = "Format file", cond = "textDocument/formatting" } },
        x = { ["<F4>"] = { format_buffer, desc = "Format selection", cond = "textDocument/rangeFormatting" } },
      },
    },
  },
}
