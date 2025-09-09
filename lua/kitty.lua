-- Signal Kitty when entering/exiting Neovim
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
  group = vim.api.nvim_create_augroup("KittyInEditorOn", { clear = true }),
  callback = function()
    if os.getenv "KITTY_WINDOW_ID" then io.stdout:write "\x1b]1337;SetUserVar=in_editor=MQo\007" end
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = vim.api.nvim_create_augroup("KittyInEditorOff", { clear = true }),
  callback = function()
    if os.getenv "KITTY_WINDOW_ID" then io.stdout:write "\x1b]1337;SetUserVar=in_editor\007" end
  end,
})
