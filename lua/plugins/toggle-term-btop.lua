-- NOTE: This is to replace the default AstroNvim mapping for <Leader>tt (btm) to btop
-- if btop is installed on the system.
-- If btop is not installed, the default mapping (btm) remains unchanged.

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      local astro = require "astrocore"

      -- If btop exists, override <Leader>tt to open btop in a floating ToggleTerm.
      if vim.fn.executable "btop" == 1 then
        maps.n["<Leader>tt"] = {
          function() astro.toggle_term_cmd { cmd = "btop", direction = "float" } end,
          desc = "ToggleTerm btop",
        }
      end
      -- Otherwise do nothing: the default mapping (btm) stays as-is.
    end,
  },
}
