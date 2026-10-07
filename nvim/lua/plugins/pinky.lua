-- Pinky night: оформление и «почти IDE» для C/C++, Python, Bash и др.
return {
  -- тема: catppuccin, перекрашенный в палитру Strawberry Night (как KDE, niri и kitty)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true, -- просвечивает полупрозрачный фон kitty
      term_colors = true,
      float = { transparent = false, solid = false },
      color_overrides = {
        mocha = {
          rosewater = "#f0e2e9", flamingo = "#f4c6d7", pink = "#e7a3bf", mauve = "#c98ba6",
          red = "#e0788f", maroon = "#eb96a8", peach = "#e0b27a", yellow = "#ecc899",
          green = "#8fc7a0", teal = "#88c1c7", sky = "#a5d4d8", sapphire = "#a9c0e4",
          blue = "#8ea9d6", lavender = "#b79ad6",
          text = "#e6d3dc", subtext1 = "#cbb8c2", subtext0 = "#b8a6b0",
          overlay2 = "#9a8a93", overlay1 = "#8a7a83", overlay0 = "#6b5d6b",
          surface2 = "#5c4f5f", surface1 = "#3a3040", surface0 = "#2b2430",
          base = "#1c1720", mantle = "#19151c", crust = "#140f17",
        },
      },
      custom_highlights = function(c)
        return {
          CursorLineNr = { fg = c.pink, style = { "bold" } },
          LineNr = { fg = c.overlay0 },
          FloatBorder = { fg = c.pink, bg = c.mantle },
          NormalFloat = { bg = c.mantle },
          WinSeparator = { fg = c.surface2 },
          Visual = { bg = "#5a3a4c" },
          Search = { bg = c.mauve, fg = c.crust },
          IncSearch = { bg = c.pink, fg = c.crust },
          SnacksDashboardHeader = { fg = c.pink },
          SnacksDashboardKey = { fg = c.mauve },
          SnacksDashboardIcon = { fg = c.pink },
        }
      end,
      integrations = { blink_cmp = true, mason = true, which_key = true, snacks = { enabled = true } },
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-mocha" } },

  -- языковые серверы: Bash (+ C/C++ и Python приходят из extras)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = { filetypes = { "sh", "bash", "zsh" } },
      },
    },
  },

  -- инструменты, которые ставит Mason: форматтеры, линтеры, отладчики, tree-sitter
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server", "shellcheck", "shfmt",
        "clang-format", "codelldb",
        "ruff", "debugpy",
        "tree-sitter-cli",
      },
      ui = { border = "rounded" },
    },
  },

  -- форматирование при сохранении
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" }, bash = { "shfmt" },
        c = { "clang_format" }, cpp = { "clang_format" },
        python = { "ruff_format" },
      },
    },
  },

  -- подсветка синтаксиса
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash", "c", "cpp", "python", "lua", "vim", "vimdoc", "json", "jsonc", "yaml", "toml",
        "markdown", "markdown_inline", "cmake", "make", "kdl", "rasi", "css", "ini", "regex", "diff",
      },
    },
  },

  -- автодополнение: подсказки сразу, с документацией и подписями функций
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "rounded" } },
        menu = { border = "rounded" },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true, window = { border = "rounded" } },
    },
  },

  -- стартовый экран
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
     ♡  ┏━┓╻┏┓╻╻┏ ╻ ╻   ┏┓╻╻ ╻╻┏┳┓  ♡
        ┣━┛┃┃┗┫┣┻┓┗┳┛   ┃┗┫┃┏┛┃┃┃┃
        ╹  ╹╹ ╹╹ ╹ ╹    ╹ ╹┗┛ ╹╹ ╹
          .˚ʚ  meow's editor  ɞ˚.          ]],
        },
      },
    },
  },
}
