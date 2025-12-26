vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)

-- move around highlighted blocks
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- rename
vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")

-- splits
vim.keymap.set("n", "<leader>sv", ":vsplit<CR><C-w>l")
vim.keymap.set("n", "<leader>sh", ":split<CR><C-w>j")

-- append lines
vim.keymap.set("n", "J", "mzJ`z")

-- navigation while cursor stays in the middle
vim.keymap.set("n", "<C-z>", "<C-d>zz") -- jump half page
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- (when replacing) paste while not chaning clipboard
vim.keymap.set("x", "<leader>p", '"_dP')

-- Best remap: copy into system clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y') -- yank entire line

vim.keymap.set("n", "<leader>d", '"_d') -- delete into void
vim.keymap.set("v", "<leader>d", '"_d')

-- dont press Q
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("v", "Q", "<nop>")

-- tmux
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
