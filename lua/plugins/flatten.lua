---@type LazySpec
return {
  {
    "willothy/flatten.nvim",
    lazy = false, -- load ASAP so forwarding has no delay
    priority = 1001,
    opts = {
      -- Don't steal your terminal window; open in your last non-terminal window
      window = { open = "alternate" },
      -- Block only when it makes sense (git commits/rebases). Defaults already do this.
      -- block_for = { gitcommit = true, gitrebase = true },
      hooks = {
        -- Keep defaults; no need to hide your terminal
        -- You can add custom behavior later if you want (see README).
      },
    },
  },
}
