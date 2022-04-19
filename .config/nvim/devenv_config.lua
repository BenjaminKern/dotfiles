vim.cmd([[packadd plug]])

local Plug = vim.fn["plug#"]

local plugged_path = vim.env.VIM .. "/plugged"

vim.call("plug#begin", plugged_path)
Plug("kyazdani42/nvim-web-devicons")
Plug("kyazdani42/nvim-tree.lua")
Plug("lewis6991/gitsigns.nvim")
Plug("onsails/lspkind.nvim")
Plug("echasnovski/mini.nvim")
Plug("phaazon/hop.nvim")
Plug("neovim/nvim-lspconfig")
Plug("ahmedkhalf/project.nvim")
Plug("norcalli/nvim-colorizer.lua")
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim")
Plug("stevearc/aerial.nvim")
Plug("stevearc/dressing.nvim")
Plug("akinsho/toggleterm.nvim")
Plug("sainnhe/gruvbox-material")
Plug("L3MON4D3/LuaSnip")
vim.call("plug#end")

--Incremental live completion
vim.o.inccommand = "nosplit"

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Do not save when switching buffers
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = "a"

vim.o.breakindent = true

vim.o.undofile = false

vim.o.swapfile = false

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.expandtab = true
vim.o.smarttab = true
vim.o.shiftwidth = 2

vim.wo.signcolumn = "yes"

vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.g.do_filetype_lua = true

vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_disable_italic_comment = true
vim.opt.background = "dark"
vim.o.termguicolors = true
vim.cmd([[colorscheme gruvbox-material]])

-- Fake clipboard
vim.cmd([[
let g:clipboard = {
      \   'name': 'fake',
      \   'copy': {
      \      '+': {lines, regtype -> extend(g:, {'clipboard_cache': [lines, regtype]}) },
      \      '*': {lines, regtype -> extend(g:, {'clipboard_cache': [lines, regtype]}) },
      \    },
      \   'paste': {
      \      '+': {-> get(g:, 'clipboard_cache', [])},
      \      '*': {-> get(g:, 'clipboard_cache', [])},
      \   },
      \ }
]])

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function(args)
      vim.highlight.on_yank()
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"python", "cpp", "c"},
    command = "setlocal tw=79",
})

vim.api.nvim_create_user_command('Commits', function() require("telescope.builtin").git_commits() end, {})
vim.api.nvim_create_user_command('Registers', function() require("telescope.builtin").registers() end, {})
vim.api.nvim_create_user_command('Trim', function() MiniTrailspace.trim() end, {})

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "<leader>d", function() require('nvim-tree').toggle() end)
vim.keymap.set("n", "ww", function() require('hop').hint_words() end)
vim.keymap.set('i', '<Tab>', function() return vim.fn.pumvisible() == 1 and t"<C-n>" or t"<Tab>"  end, { expr = true })
vim.keymap.set('i', '<S-Tab>', function() return vim.fn.pumvisible() == 1 and t"<C-p>" or t"<Tab>" end, { expr = true })
vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() ~= 0 then
    -- If popup is visible, confirm selected item or add new line otherwise
    local item_selected = vim.fn.complete_info()['selected'] ~= -1
    return item_selected and t"<C-y>" or t"<C-y><CR>"
  else
    return t"<CR>"
  end
end,{ expr = true })
vim.keymap.set("n", "<leader>ff", function() require('telescope.builtin').find_files() end)
vim.keymap.set("n", "<leader>fb", function() require('telescope.builtin').buffers() end)
vim.keymap.set("n", "<leader>fg", function() require('telescope.builtin').grep_string() end)

vim.g.nvim_tree_respect_buf_cwd = 1

require("nvim-tree").setup({
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true
  },
})
require('lspkind').init({
  mode = 'symbol',
})
require("gitsigns").setup()
require("project_nvim").setup()
require("colorizer").setup()
require("hop").setup({
  keys = "etovxqpdygfblzhckisuran",
  term_seq_bias = 0.5,
})
require("aerial").setup()
require("dressing").setup()

local fd_ignore_path = vim.env.VIM .. "/.fd-ignore"

local actions = require("telescope.actions")
local config = require("telescope.config")
require("telescope").setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    layout_config = {
      prompt_position = "top",
      vertical = { mirror = true },
      flex = { flip_columns = 140 },
    },
    file_sorter = require("mini.fuzzy").get_telescope_sorter,
    generic_sorter = require("mini.fuzzy").get_telescope_sorter,
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
      }
    }
  },
  pickers = {
    find_files = {
      find_command = {"fd", "--type", "f", "-H", "--ignore-file", fd_ignore_path},
    },
    buffers = { ignore_current_buffer = true },
    file_browser = { hidden = true },
  },
})
require('telescope').load_extension('aerial')
require("toggleterm").setup({
  direction = "float",
  float_opts = {
    border = "double",
  },
  open_mapping = [[<leader>t]],
})
require("mini.comment").setup()
require("mini.completion").setup()
require("mini.cursorword").setup()
require("mini.indentscope").setup()
require("mini.starter").setup()
require("mini.statusline").setup()
require("mini.tabline").setup()
require("mini.trailspace").setup()
require("mini.sessions").setup()
require("mini.fuzzy").setup()

-- LSP settings
local on_attach = function(client, bufnr)
  local opts = { silent = true, buffer = bufnr }
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "gi", function() require('telescope.builtin').lsp_implementations() end, opts)
  vim.keymap.set("n", "gd", function() require('telescope.builtin').lsp_definitions() end, opts)
  vim.keymap.set("n", "gt", function() require('telescope.builtin').lsp_type_definitions() end, opts)
  vim.keymap.set("n", "gr", function() require('telescope.builtin').lsp_references() end, opts)
  vim.keymap.set("n", "ca", function() require('telescope.builtin').lsp_code_actions() end, opts)
  vim.keymap.set("n", "gs", function() require('telescope.builtin').lsp_document_symbols() end, opts)
  vim.keymap.set("n", "gS", function() require('telescope.builtin').lsp_workspace_symbols() end, opts)
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function() vim.lsp.buf.formatting() end, {})
  vim.api.nvim_buf_create_user_command(bufnr, "Diagnostics", function() require('telescope.builtin').diagnostics() end, {})
  require("aerial").on_attach(client, bufnr)
end

vim.api.nvim_call_function("sign_define", { "DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" } })
vim.api.nvim_call_function("sign_define", { "DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" } })
vim.api.nvim_call_function("sign_define", { "DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" } })
vim.api.nvim_call_function("sign_define", { "DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" } })

require("lspconfig").clangd.setup({
  on_attach = on_attach,
  cmd = {
    "clangd",
    "--background-index",
    "--enable-config",
    "--header-insertion=iwyu",
    "--cross-file-rename",
    "--clang-tidy",
    "--clang-tidy-checks=bugprone-*,cppcoreguidelines-*,modernize-*,performance-*,readability-*",
  },
})
