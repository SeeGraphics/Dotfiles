vim.opt.termguicolors = true

local inside_tmux = vim.env.TMUX ~= nil and vim.env.TMUX ~= ""

function ColorMyPencils(color)
	color = color or "rose-pine"

	if color == "rose-pine" then
		local ok, rosepine = pcall(require, "rose-pine")
		if ok then
			rosepine.setup({
				disable_italics = inside_tmux,
			})
		end
	end

	vim.cmd.colorscheme(color)

	-- transparency
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()

-- Force no cterm background for common groups
vim.cmd([[
  highlight Normal ctermbg=NONE guibg=NONE
  highlight Comment ctermbg=NONE
  highlight Special ctermbg=NONE
  highlight Identifier ctermbg=NONE
]])

vim.cmd([[
  highlight Search ctermbg=NONE
  highlight IncSearch ctermbg=NONE
]])
