-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- <пробел>r — собрать и запустить текущий файл в терминале снизу (Python, C, C++, Bash)
local function run_file()
  vim.cmd("silent! write")
  local file = vim.fn.expand("%:p")
  local out = vim.fn.expand("%:p:r")
  local ft = vim.bo.filetype
  local cmd
  if ft == "python" then
    cmd = { "python3", file }
  elseif ft == "c" then
    cmd = { "sh", "-c", ("gcc -Wall -g -o %q %q && %q"):format(out, file, out) }
  elseif ft == "cpp" then
    cmd = { "sh", "-c", ("g++ -std=c++20 -Wall -g -o %q %q && %q"):format(out, file, out) }
  elseif ft == "sh" or ft == "bash" then
    cmd = { "bash", file }
  elseif ft == "lua" then
    cmd = { "lua", file }
  else
    vim.notify("Не знаю, как запустить файл типа «" .. ft .. "»", vim.log.levels.WARN)
    return
  end
  -- терминал принимает ввод (scanf, input() и т.п.); после завершения окно остаётся — закрыть: q
  Snacks.terminal(cmd, {
    cwd = vim.fn.expand("%:p:h"),
    interactive = true,
    auto_close = false,
    win = { position = "bottom", height = 0.4, keys = { q = "hide" } },
  })
end
vim.keymap.set("n", "<leader>r", run_file, { desc = "Запустить файл" })
