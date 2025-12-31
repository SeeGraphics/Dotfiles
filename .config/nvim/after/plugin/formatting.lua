local ok, conform = pcall(require, 'conform')
if not ok then
  return
end

conform.setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    rust = { 'rustfmt' },
    c = { 'clang_format' },
    cpp = { 'clang_format' },
    python = { 'black' },
    javascript = { 'prettierd', 'prettier' },
    typescript = { 'prettierd', 'prettier' },
    javascriptreact = { 'prettierd', 'prettier' },
    typescriptreact = { 'prettierd', 'prettier' },
    json = { 'prettierd', 'prettier' },
    html = { 'prettierd', 'prettier' },
    css = { 'prettierd', 'prettier' },
    markdown = { 'prettierd', 'prettier' },
  },
  format_on_save = function()
    return {
      timeout_ms = 1000,
      lsp_fallback = false,
    }
  end,
})
