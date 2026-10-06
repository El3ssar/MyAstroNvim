-- Treesitter (AstroNvim v6 configures it through astrocore.opts.treesitter) and folding.

local git_fts = { gitcommit = true, gitrebase = true, gitsendemail = true }

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      -- Off for git buffers so Neovim's builtin syntax runs instead: it has the
      -- subject-overflow colouring (gitcommitOverflow) the TS parser lacks.
      enabled = function(lang, bufnr)
        bufnr = bufnr or 0
        if git_fts[vim.bo[bufnr].filetype] or git_fts[lang] then return false end
        return not require("astrocore.buffer").is_large(bufnr)
      end,
      highlight = true,
      indent = true,
      auto_install = true,
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
    options = {
      opt = {
        foldcolumn = "0",
        foldenable = true,
        foldlevel = 99, -- start with everything unfolded
        foldlevelstart = 99,
        foldnestmax = 4,
        foldtext = "", -- show the fold's first line as-is
      },
    },
    autocmds = {
      treesitter_folds = {
        {
          event = "FileType",
          desc = "Treesitter folding when a parser + fold query exist, else indent folding",
          callback = function(args)
            local ft = vim.bo[args.buf].filetype
            local lang = vim.treesitter.language.get_lang(ft) or ft
            local has_folds = vim.treesitter.get_parser(args.buf, nil, { error = false }) ~= nil
              and vim.treesitter.query.get(lang, "folds") ~= nil
            vim.opt_local.foldmethod = has_folds and "expr" or "indent"
            vim.opt_local.foldexpr = has_folds and "v:lua.vim.treesitter.foldexpr()" or "0"
          end,
        },
      },
    },
  },
}
