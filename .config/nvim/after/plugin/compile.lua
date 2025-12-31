local last_compile = ""
local compile_bufnr

local function sanitize_lines(data)
  if not data or #data == 0 then
    return {}
  end
  if data[#data] == "" then
    data[#data] = nil
  end
  return data
end

local function append_lines(bufnr, data)
  data = sanitize_lines(data)
  if #data == 0 or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
  vim.bo[bufnr].modifiable = false
end

local function get_compile_buf()
  if compile_bufnr and vim.api.nvim_buf_is_valid(compile_bufnr) then
    return compile_bufnr
  end

  compile_bufnr = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(compile_bufnr, "Compile")
  vim.bo[compile_bufnr].buftype = "nofile"
  vim.bo[compile_bufnr].bufhidden = "hide"
  vim.bo[compile_bufnr].swapfile = false
  vim.bo[compile_bufnr].modifiable = false

  return compile_bufnr
end

local function open_compile_window(bufnr)
  local win = vim.fn.bufwinid(bufnr)
  if win ~= -1 then
    vim.api.nvim_set_current_win(win)
    return
  end

  vim.cmd("botright split")
  vim.api.nvim_win_set_height(0, 12)
  vim.api.nvim_win_set_buf(0, bufnr)
end

local function run_compile(cmd)
  local bufnr = get_compile_buf()
  open_compile_window(bufnr)

  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "> " .. cmd, "" })
  vim.bo[bufnr].modifiable = false

  local start = vim.loop.hrtime()
  local job_id = vim.fn.jobstart(cmd, {
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = function(_, data)
      vim.schedule(function()
        append_lines(bufnr, data)
      end)
    end,
    on_stderr = function(_, data)
      vim.schedule(function()
        append_lines(bufnr, data)
      end)
    end,
    on_exit = function(_, code)
      local elapsed = (vim.loop.hrtime() - start) / 1e9
      vim.schedule(function()
        append_lines(bufnr, { "", string.format("[done] exit %d in %.2fs", code, elapsed) })
        local level = code == 0 and vim.log.levels.INFO or vim.log.levels.WARN
        vim.notify(string.format("Compile finished in %.2fs (exit %d)", elapsed, code), level)
      end)
    end,
  })

  if job_id <= 0 then
    vim.notify("Failed to start compile job", vim.log.levels.ERROR)
  end
end

vim.keymap.set("n", "<leader>cc", function()
  local cmd = vim.fn.input("Compile: ", last_compile)
  if cmd == nil or cmd == "" then
    return
  end
  last_compile = cmd
  run_compile(cmd)
end, { desc = "Compile command" })
