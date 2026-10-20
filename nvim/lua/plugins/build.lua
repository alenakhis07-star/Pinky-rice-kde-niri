-- Сборка проектов: make и CMake. Все команды — в меню <пробел>m
local function make_root()
  -- ближайшая папка с Makefile вверх от текущего файла, иначе текущая папка
  return vim.fs.root(0, { "Makefile", "makefile", "GNUmakefile" }) or vim.uv.cwd()
end

-- make в фоне, ошибки компиляции — в список (по ним можно прыгать к строкам)
local function make(target)
  vim.cmd("silent! wall")
  local dir = make_root()
  vim.notify("make " .. (target or "") .. " …", vim.log.levels.INFO, { title = "make" })
  vim.cmd(("silent make! -C %s %s"):format(vim.fn.fnameescape(dir), target or ""))
  local errors = vim.tbl_filter(function(i) return i.valid == 1 end, vim.fn.getqflist())
  if #errors > 0 then
    vim.notify(("Ошибок и предупреждений: %d"):format(#errors), vim.log.levels.WARN, { title = "make" })
    local ok = pcall(vim.cmd, "Trouble qflist open")
    if not ok then vim.cmd("copen") end
  else
    vim.notify("Готово ♡", vim.log.levels.INFO, { title = "make " .. (target or "") })
  end
end

-- make run — в терминале снизу, с вводом данных
local function make_run()
  vim.cmd("silent! wall")
  Snacks.terminal({ "make", "-C", make_root(), "run" }, {
    interactive = true,
    auto_close = false,
    win = { position = "bottom", height = 0.4, keys = { q = "hide" } },
  })
end

return {
  -- make
  {
    "folke/which-key.nvim",
    opts = { spec = { { "<leader>m", group = "make / cmake", icon = { icon = "󰣪 ", color = "red" } } } },
  },
  {
    "LazyVim/LazyVim",
    keys = {
      { "<leader>mm", function() make() end, desc = "make (собрать)" },
      { "<leader>mc", function() make("clean") end, desc = "make clean" },
      { "<leader>mr", make_run, desc = "make run (запустить)" },
      {
        "<leader>mt",
        function()
          vim.ui.input({ prompt = "make — цель: " }, function(t)
            if t and t ~= "" then make(t) end
          end)
        end,
        desc = "make <цель>",
      },
    },
  },

  -- CMake
  {
    "Civitasv/cmake-tools.nvim",
    cmd = { "CMakeGenerate", "CMakeBuild", "CMakeRun", "CMakeDebug", "CMakeClean",
            "CMakeSelectBuildType", "CMakeSelectLaunchTarget", "CMakeSelectBuildTarget", "CMakeQuickBuild" },
    opts = {
      cmake_build_directory = "build/${variant:buildType}",
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      -- compile_commands.json появляется в корне проекта — clangd сразу видит флаги и заголовки
      cmake_soft_link_compile_commands = true,
      cmake_compile_commands_from_lsp = false,
      cmake_executor = { name = "quickfix" }, -- ошибки сборки — в список
      cmake_runner = { name = "terminal" },   -- запуск — в терминале, с вводом данных
    },
    keys = {
      { "<leader>mg", "<cmd>CMakeGenerate<cr>", desc = "CMake: сгенерировать" },
      { "<leader>mb", function() require("cmake-tools").build({ target = "all" }, function() end) end, desc = "CMake: собрать всё" },
      { "<leader>mB", "<cmd>CMakeSelectBuildTarget<cr>", desc = "CMake: выбрать цель сборки" },
      { "<leader>mx", "<cmd>CMakeRun<cr>", desc = "CMake: запустить" },
      { "<leader>md", "<cmd>CMakeDebug<cr>", desc = "CMake: отладка" },
      { "<leader>ms", "<cmd>CMakeSelectBuildType<cr>", desc = "CMake: тип сборки (Debug/Release)" },
      { "<leader>ml", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "CMake: что запускать" },
      { "<leader>mC", "<cmd>CMakeClean<cr>", desc = "CMake: очистить" },
    },
  },
}
