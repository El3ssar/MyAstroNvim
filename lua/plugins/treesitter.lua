-- AstroNvim v6 configures treesitter through astrocore.opts.treesitter.
-- nvim-treesitter still runs under the hood as a parser installer (on its main branch now).
-- No plugin-level config override needed.

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    opts = {
      -- v6-style treesitter config (highlight, indent, ensure_installed, etc.)
      treesitter = {
        highlight = true,
        indent = true,
        auto_install = true, -- automatically install parsers for detected filetypes
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "bash",
          "python",
          "markdown",
          "markdown_inline",
          "json",
          "c",
          "cpp",
          "javascript",
          "typescript",
          "rust",
          "yaml",
        },
      },

      -- Global fold settings — open all folds by default, use TS when available
      options = {
        opt = {
          foldcolumn = "0",    -- no fold gutter column
          foldlevel = 99,      -- start with everything unfolded
          foldlevelstart = 99,
          foldenable = true,
          foldnestmax = 4,
          foldtext = "",       -- show first line of fold verbatim (nvim 0.10+)
        },
      },

      autocmds = {
        -- Pick treesitter folding when a parser + fold query exist, else indent.
        -- Uses Neovim 0.12 nil-safe get_parser() (returns nil on failure, no throw).
        treesitter_folds = {
          {
            event = { "BufReadPost", "FileType" },
            desc = "Enable treesitter folding if parser available, else indent folding",
            callback = function(args)
              local bufnr = args.buf
              -- Neovim 0.12: get_parser returns nil (never throws) — check directly
              local parser = vim.treesitter.get_parser(bufnr, nil, { error = false })
              local has_fold_query = false
              if parser then
                local ft = vim.bo[bufnr].filetype
                has_fold_query = ft ~= "" and vim.treesitter.query.get(ft, "folds") ~= nil
              end

              if parser and has_fold_query then
                vim.opt_local.foldmethod = "expr"
                vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
              else
                vim.opt_local.foldmethod = "indent"
                vim.opt_local.foldexpr = "0"
              end
            end,
          },
        },
      },
    },
  },
}
