-- Core features, vim options, diagnostics and autocmds (see `:h astrocore`).
-- Mappings live in mappings.lua, treesitter/folding in treesitter.lua.

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    -- AstroNvim sets the `jump.float` diagnostic option, which Neovim 0.12 deprecates.
    -- Drop it: the full message is already shown under the cursor line, so no popup on ]d/[d.
    opts = function(_, opts)
      local jump = vim.tbl_get(opts, "diagnostics", "jump")
      if jump then jump.float = nil end
    end,
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      features = {
        large_buf = { size = 1024 * 256, lines = 10000 }, -- disable heavy features above this size
        autopairs = true,
        cmp = true,
        diagnostics = true,
        highlighturl = true,
        notifications = true,
      },
      -- Passed to vim.diagnostic.config(): short message at the end of every line,
      -- full multi-line message only under the cursor line (no duplicates).
      -- Toggle with <Leader>uv (text) / <Leader>uV (lines).
      diagnostics = {
        virtual_text = { current_line = false },
        virtual_lines = { current_line = true },
        underline = true,
        update_in_insert = false,
      },
      options = {
        opt = {
          number = true,
          relativenumber = false,
          signcolumn = "yes",
          spell = false,
          wrap = true,
          mouse = "a",
          mousemodel = "extend",
          -- Shift+arrows start/stop a selection, like a regular editor
          keymodel = "startsel,stopsel",
        },
      },
      autocmds = {
        gitcommit_settings = {
          {
            event = "FileType",
            pattern = "gitcommit",
            desc = "Git commit message: spell check, wrap at 72, guides at 51 and 73",
            callback = function()
              vim.opt_local.spell = true
              vim.opt_local.textwidth = 72
              vim.opt_local.colorcolumn = "51,+1" -- subject overflow / body wrap
              vim.cmd "normal! gg"
            end,
          },
        },
      },
    },
  },
}
