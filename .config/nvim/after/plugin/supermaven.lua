local ok, supermaven = pcall(require, "supermaven-nvim")
if not ok then
  return
end

supermaven.setup({
  keymaps = {
    accept_suggestion = "<C-l>",
    accept_word = "<C-j>",
    clear_suggestion = "<C-k>",
  },
})

vim.keymap.set("n", "<leader>sm", function()
  if vim.fn.exists(":SupermavenToggle") == 2 then
    vim.cmd("SupermavenToggle")
    return
  end

  if type(supermaven.toggle) == "function" then
    supermaven.toggle()
    return
  end

  vim.notify("Supermaven toggle is unavailable", vim.log.levels.WARN)
end, { desc = "Toggle Supermaven" })
