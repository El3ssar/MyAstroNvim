-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "bash",
        "python",
        "markdown",
        "json",
        "c",
        "cpp",
        "javascript",
        "typescript",
        "rust",
        "yaml",
      },
    },
    config = function(_, opts)
      -- run Astro’s default config first
      require "astronvim.plugins.configs.nvim-treesitter"(_, opts)

      -- helpers: check if TS folds are available
      local function ts_can_fold(bufnr)
        local okp = pcall(vim.treesitter.get_parser, bufnr)
        local okq = pcall(vim.treesitter.query.get, vim.bo[bufnr].filetype, "folds")
        return okp and okq
      end

      -- apply foldmethod depending on parser/query availability
      local function apply_folds(bufnr)
        if ts_can_fold(bufnr) then
          vim.opt_local.foldmethod = "expr"
          vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        else
          vim.opt_local.foldmethod = "indent"
          vim.opt_local.foldexpr = "0"
        end
      end

      -- global fold defaults (per your taste)
      vim.opt.foldcolumn = "0" -- no extra column
      vim.opt.foldlevel = 99 -- open all folds by default
      vim.opt.foldlevelstart = 99 -- start unfolded
      vim.opt.foldenable = true -- enable folding
      vim.opt.foldnestmax = 4 -- max nesting
      pcall(function() vim.opt.foldtext = "" end) -- don’t overwrite folded line

      -- reapply when buffers open or filetype changes
      vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
        callback = function(args) apply_folds(args.buf) end,
      })
    end,
  },
}
