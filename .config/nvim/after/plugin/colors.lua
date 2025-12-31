vim.opt.termguicolors = true
vim.opt.background = "dark"

function ColorMyPencils(color)
  color = color or "gruber-darker"
  vim.cmd.colorscheme(color)
end

ColorMyPencils()
