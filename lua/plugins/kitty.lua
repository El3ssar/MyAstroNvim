-- Kitty terminal integration. Everything here is a no-op outside kitty.
--  * `in_editor` user var: lets kitty.conf send keys straight to nvim (`--when-focus-on var:in_editor`)
--  * Alt+arrows: move between nvim splits and kitty windows (vim-kitty-navigator)
--  * kitty.conf syntax highlighting

local in_kitty = vim.env.KITTY_WINDOW_ID ~= nil

-- On macOS, `kitten` lives inside kitty.app and may be missing from PATH
-- (e.g. when the shell rc rebuilds PATH). The navigator needs it.
if in_kitty and vim.fn.executable "kitten" == 0 then
  for _, dir in ipairs {
    "/Applications/kitty.app/Contents/MacOS",
    vim.env.HOME .. "/Applications/kitty.app/Contents/MacOS",
  } do
    if vim.fn.executable(dir .. "/kitten") == 1 then
      vim.env.PATH = dir .. ":" .. vim.env.PATH
      break
    end
  end
end

--- Set (value) or unset (nil) a kitty user variable via OSC 1337.
local function set_user_var(name, value)
  local seq = ("\27]1337;SetUserVar=%s%s\7"):format(name, value and "=" .. vim.base64.encode(value) or "")
  vim.api.nvim_ui_send(seq) -- reaches the terminal even though the TUI is a separate process
end

local nav_keys = {
  { "<M-Left>", "Left", "h" },
  { "<M-Down>", "Down", "j" },
  { "<M-Up>", "Up", "k" },
  { "<M-Right>", "Right", "l" },
}

---@type LazySpec
return {
  { "fladson/vim-kitty", ft = "kitty" },
  {
    "knubie/vim-kitty-navigator",
    cond = in_kitty,
    lazy = false,
    build = "cp ./*.py ~/.config/kitty/",
    init = function() vim.g.kitty_navigator_no_mappings = 1 end,
  },
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      local maps = opts.mappings.n
      for _, k in ipairs(nav_keys) do
        local key, dir, wincmd = k[1], k[2], k[3]
        maps[key] = in_kitty and { "<Cmd>KittyNavigate" .. dir .. "<CR>", desc = "Navigate " .. dir:lower() }
          or { "<C-w>" .. wincmd, desc = "Window " .. dir:lower() }
      end

      if in_kitty then
        opts.autocmds.kitty_in_editor = {
          {
            event = { "VimEnter", "VimResume" },
            desc = "Tell kitty nvim is focused",
            callback = function() set_user_var("in_editor", "1") end,
          },
          {
            event = { "VimLeavePre", "VimSuspend" },
            desc = "Tell kitty nvim is gone",
            callback = function() set_user_var "in_editor" end,
          },
        }
      end
    end,
  },
}
