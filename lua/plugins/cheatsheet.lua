local M = { "smartinellimarco/nvcheatsheet.nvim" }

-- --- dynamic collector (leader-only, dedupe, robust normalization)
-- leader-only dynamic collector, prints "<leader>", merges unknown into "Misc"
local function build_sections()
  local leader = vim.g.mapleader or " "
  local localleader = vim.g.maplocalleader or ","

  local function esc(s) return (s:gsub("(%W)", "%%%1")) end

  -- normalize raw lhs to start with "<leader>" or "<localleader>"
  local function norm_leader(lhs)
    local s = lhs or ""
    s = s:gsub("^<Leader>", "<leader>")
    if leader == " " then
      s = s:gsub("^<Space>", "<leader>")
      if s:sub(1, 1) == " " then s = "<leader>" .. s:sub(2) end
    elseif #leader == 1 then
      s = s:gsub("^" .. esc(leader), "<leader>")
    end
    return s
  end

  -- pretty-print WITHOUT expanding leader/localleader tokens
  local function prettify(lhs)
    local s = lhs
    -- keep these literal
    s = s:gsub("<leader>", "<leader>")
    s = s:gsub("<localleader>", "<localleader>")
    -- cosmetics
    s = s:gsub("<CR>", "⏎")
      :gsub("<Tab>", "Tab")
      :gsub("<S%-Tab>", "S-Tab")
      :gsub("<Esc>", "Esc")
      :gsub("<BS>", "Backspace")
      :gsub("<Up>", "↑")
      :gsub("<Down>", "↓")
      :gsub("<Left>", "←")
      :gsub("<Right>", "→")
      :gsub("<C%-([%w%p])>", "⌃%1")
      :gsub("<S%-([%w%p])>", "⇧%1")
      :gsub("<A%-([%w%p])>", "⎇%1")
      :gsub("<M%-([%w%p])>", "⎇%1")
      :gsub("<F(%d+)>", "F%1")
    return s
  end

  local GROUP = setmetatable({
    b = "Buffers",
    l = "LSP",
    d = "Debugger",
    f = "Find / Pickers",
    g = "Git",
    t = "Terminal",
    p = "Packages",
    S = "Sessions",
    u = "UI / UX",
    x = "Diagnostics / Lists",
    e = "Explorer",
    h = "Dashboard",
  }, { __index = function() return "Misc" end }) -- <— single Misc bucket

  local sections, seen = {}, {}
  local function add(sec, desc, key)
    sections[sec] = sections[sec] or {}
    local sig = desc .. "\001" .. key
    if not seen[sig] then
      table.insert(sections[sec], { desc, key })
      seen[sig] = true
    end
  end

  local function collect(mode)
    local ok, maps = pcall(vim.keymap.get, mode)
    if not ok then maps = vim.api.nvim_get_keymap(mode) end
    for _, m in ipairs(vim.api.nvim_buf_get_keymap(0, mode)) do
      maps[#maps + 1] = m
    end
    return maps
  end

  for _, m in ipairs(collect "n") do
    local lhs, desc = m.lhs or m.lhsraw or m[1], m.desc
    if lhs and desc and desc ~= "" then
      local ks = norm_leader(lhs)
      if ks:find "^<leader>" then
        local k1 = ks:match "^<leader>(.)"
        add(GROUP[k1], desc, prettify(ks))
      elseif ks:find "^<localleader>" then
        add("Local Leader", desc, prettify(ks))
      end
    end
  end

  for _, list in pairs(sections) do
    table.sort(list, function(a, b) return a[2] < b[2] end)
  end
  return sections
end

-- --- end collector

M.opts = {
  header = {
    "                                      ",
    "                                      ",
    "                                      ",
    "█▀▀ █░█ █▀▀ ▄▀█ ▀█▀ █▀ █░█ █▀▀ █▀▀ ▀█▀",
    "█▄▄ █▀█ ██▄ █▀█ ░█░ ▄█ █▀█ ██▄ ██▄ ░█░",
    "                                      ",
    "                                      ",
    "                                      ",
  },
  keymaps = {}, -- build at runtime, not here
}

function M.config(_, opts)
  local nv = require "nvcheatsheet"

  local function refresh() nv.setup(vim.tbl_extend("force", opts, { keymaps = build_sections() })) end

  -- Dynamic colors for nvcheatsheet groups (per current colorscheme)
  local function setup_cheatsheet_hl()
    local function hlget(name)
      local ok, h = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
      return ok and h or {}
    end
    local function hlset(name, val) vim.api.nvim_set_hl(0, name, val) end

    local norm = hlget "Normal"
    local bg = norm.bg or 0x1e1e2e

    -- Pick “foreground” colors from your theme to use as section header **backgrounds**
    local picks = {
      White = 0xcdd6f4,
      Gray = 0x9399b2,
      Blue = 0x89b4fa,
      Cyan = 0x89dceb,
      Red = 0xf38ba8,
      Green = 0xa6e3a1,
      Yellow = 0xf9e2af,
      Orange = 0xfab387,
      Purple = 0xcba6f7,
      Magenta = 0xf5c2e7,
    }

    -- Card background (the “tile” itself). Tweak if you want more contrast.
    hlset("NvChSection", { bg = hlget("CursorLine").bg or bg })

    -- Section headers: different bg per color name
    for name, col in pairs(picks) do
      hlset("NvCheatsheet" .. name, { bg = col, fg = bg, bold = true })
    end

    -- Optional: header banner with background color
    local header_fg = 0x006620
    hlset("NvChAsciiHeader", { fg = header_fg, bold = true })
  end

  -- Apply now and whenever the colorscheme changes
  vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_cheatsheet_hl })
  setup_cheatsheet_hl()

  -- build once after plugins finish loading
  refresh()

  -- F1: rebuild then toggle (so it’s never empty)
  vim.keymap.set("n", "<F1>", function()
    refresh()
    nv.toggle()
  end, { desc = "Toggle Cheatsheet" })

  -- optional: manual refresh + auto refresh on LSP attach & VeryLazy
  vim.api.nvim_create_user_command("CheatsheetRefresh", refresh, {})
  vim.api.nvim_create_autocmd("User", { pattern = "VeryLazy", callback = refresh, desc = "Cheatsheet refresh" })
  vim.api.nvim_create_autocmd("LspAttach", { callback = refresh, desc = "Cheatsheet refresh on LSP attach" })
end

return M
