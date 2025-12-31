local spectre = require("spectre")

spectre.setup()

vim.keymap.set("n", "<leader>rn", function()
  spectre.open_visual({ select_word = true })
end)

vim.keymap.set("v", "<leader>rn", function()
  spectre.open_visual()
end)
