-- flatten: `nvim file` inside a :terminal opens the file in this nvim instead of nesting.
-- Git commit/rebase buffers block until closed (plugin default).

---@type LazySpec
return {
  "willothy/flatten.nvim",
  lazy = false, -- must load early so forwarding has no delay
  priority = 1001,
  opts = {
    window = { open = "alternate" }, -- open in the last non-terminal window
  },
}
