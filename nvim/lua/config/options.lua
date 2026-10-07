-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
local opt = vim.opt

opt.relativenumber = true
opt.scrolloff = 6
opt.wrap = false
opt.spelllang = { "ru", "en" }

-- команды работают и в русской раскладке (не надо переключаться ради :w, dd и т.п.)
local ru = [[ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮЁйцукенгшщзхъфывапролджэячсмитьбюё]]
local en = [[QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>~qwertyuiop[]asdfghjkl;'zxcvbnm,.`]]
opt.langmap = vim.fn.join({
  vim.fn.escape(ru, ";,\"|\\") .. ";" .. vim.fn.escape(en, ";,\"|\\"),
}, ",")
