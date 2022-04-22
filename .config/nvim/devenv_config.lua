vim.cmd([[packadd plug]])

local Plug = vim.fn['plug#']

local plugged_path = vim.env.VIM .. '/plugged'

vim.call('plug#begin', plugged_path)
Plug('L3MON4D3/LuaSnip')
Plug('ahmedkhalf/project.nvim')
Plug('akinsho/toggleterm.nvim')
Plug('benfowler/telescope-luasnip.nvim')
Plug('echasnovski/mini.nvim')
Plug('kyazdani42/nvim-tree.lua')
Plug('kyazdani42/nvim-web-devicons')
Plug('lewis6991/gitsigns.nvim')
Plug('neovim/nvim-lspconfig')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('onsails/lspkind.nvim')
Plug('phaazon/hop.nvim')
Plug('sainnhe/gruvbox-material')
Plug('stevearc/aerial.nvim')
Plug('stevearc/dressing.nvim')
vim.call('plug#end')

vim.g.do_filetype_lua = true
vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_disable_italic_comment = true
vim.g.mapleader = ','
vim.g.maplocalleader = ','
vim.o.breakindent = true
vim.o.expandtab = true
vim.o.hidden = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.inccommand = 'nosplit'
vim.o.laststatus = 3
vim.o.mouse = 'a'
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.smarttab = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.undofile = false
vim.opt.background = 'dark'
vim.wo.number = true
vim.wo.signcolumn = 'yes'

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

vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function(args)
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'cpp', 'c' },
  command = 'setlocal tw=79',
})

vim.api.nvim_create_user_command('Buffers', function()
  require('telescope.builtin').buffers()
end, { desc = 'Telescope show Buffers' })
vim.api.nvim_create_user_command('Commits', function()
  if vim.fn.isdirectory('.git') ~= 0 then
    require('telescope.builtin').git_commits()
  end
end, { desc = 'Telescope show Git Commits' })
vim.api.nvim_create_user_command('Registers', function()
  require('telescope.builtin').registers()
end, { desc = 'Telescope show Registers' })
vim.api.nvim_create_user_command('Snippets', function()
  require('telescope').extensions.luasnip.luasnip()
end, { desc = 'Telescope show Lua Snippets' })
vim.api.nvim_create_user_command('Trim', function()
  MiniTrailspace.trim()
end, { desc = 'Trim trailing whitespace' })

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function feedkeys(key)
  local mode = ''
  vim.api.nvim_feedkeys(t(key), mode, true)
end

vim.keymap.set('n', 'Y', 'y$', { desc = 'Yank till the end of the line' })
vim.keymap.set('n', '<leader>d', function()
  require('nvim-tree').toggle()
end, { desc = 'Toggle nvim tree' })
vim.keymap.set('n', 'ww', function()
  require('hop').hint_words()
end, { desc = 'Use hop' })
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { desc = 'Escape from terminal' })

local luasnip = require('luasnip')
luasnip.config.set_config({ history = true })
luasnip.filetype_extend('all', { '_' })
require('luasnip.loaders.from_snipmate').lazy_load()

vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if vim.fn.pumvisible() ~= 0 then
    return t('<C-n>')
  elseif luasnip.expand_or_jumpable() then
    return feedkeys('<Plug>luasnip-expand-or-jump')
  else
    return t('<Tab>')
  end
end, { expr = true }, { desc = 'Autocomplete/Expand/Jump Luasnip' })

vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
  if vim.fn.pumvisible() ~= 0 then
    return t('<C-p>')
  elseif luasnip.jumpable(-1) then
    return feedkeys('<Plug>luasnip-jump-prev')
  else
    return t('<S-Tab>')
  end
end, { expr = true }, { desc = 'Autocomplete/Expand/Jump Back Luasnip' })

vim.keymap.set('i', '<CR>', function()
  if vim.fn.pumvisible() ~= 0 then
    local item_selected = vim.fn.complete_info()['selected'] ~= -1
    return item_selected and t('<C-y>') or t('<C-y><CR>')
  else
    return require('mini.pairs').cr()
  end
end, { expr = true }, { desc = 'Sanitized CR handling/Expand Mini Pairs' })
vim.keymap.set('n', '<leader>ff', function()
  require('telescope.builtin').find_files()
end, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', function()
  require('telescope.builtin').grep_string()
end, { desc = 'Telescope grep string under cursor' })

vim.g.nvim_tree_respect_buf_cwd = 1

require('nvim-tree').setup({
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
})
require('lspkind').init({
  mode = 'symbol',
})
require('gitsigns').setup()
require('project_nvim').setup()
require('hop').setup({
  keys = 'etovxqpdygfblzhckisuran',
  term_seq_bias = 0.5,
})
require('aerial').setup()
require('dressing').setup()

local fd_ignore_file = vim.env.VIM .. '/.fd-ignore'

local telescope = require('telescope')
local actions = require('telescope.actions')
local config = require('telescope.config')
telescope.setup({
  defaults = {
    sorting_strategy = 'ascending',
    layout_strategy = 'flex',
    layout_config = {
      prompt_position = 'top',
      vertical = { mirror = true },
      flex = { flip_columns = 140 },
    },
    file_sorter = require('mini.fuzzy').get_telescope_sorter,
    generic_sorter = require('mini.fuzzy').get_telescope_sorter,
    mappings = {
      i = {
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-j>'] = actions.move_selection_next,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { 'fd', '--type', 'f', '-H', '--ignore-file', fd_ignore_file },
    },
    buffers = { ignore_current_buffer = true },
    file_browser = { hidden = true },
  },
})
telescope.load_extension('aerial')
telescope.load_extension('luasnip')
require('toggleterm').setup({
  direction = 'float',
  float_opts = {
    border = 'double',
  },
  open_mapping = [[<leader>t]],
})
require('mini.comment').setup()
require('mini.completion').setup({
  source_func = 'omnifunc',
  auto_setup = false,
})
require('mini.cursorword').setup()
require('mini.indentscope').setup()
require('mini.starter').setup()
require('mini.statusline').setup({
  set_vim_settings = false,
})
require('mini.tabline').setup()
require('mini.trailspace').setup()
local sessions_path = vim.env.VIM .. '/sessions'
require('mini.sessions').setup({
  directory = sessions_path,
})
require('mini.pairs').setup()
require('mini.fuzzy').setup()
-- Gruvbox colorscheme sets an incompatible Error highlight group which can not be used for
-- the MiniTrailspace highlight group. For that reason we are owerwriting the highlight group here
vim.api.nvim_exec([[hi MiniTrailspace ctermfg=235 ctermbg=223 guifg=#112641 guibg=#ffcfa0]], false)

-- LSP settings
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.MiniCompletion.completefunc_lsp')
  vim.keymap.set('n', 'K', function()
    vim.lsp.buf.hover()
  end, { silent = true, buffer = bufnr, desc = 'Lsp Hover' })
  vim.keymap.set('n', '<leader>rn', function()
    vim.lsp.buf.rename()
  end, { silent = true, buffer = bufnr, desc = 'Lsp Rename' })
  vim.keymap.set('n', 'gi', function()
    require('telescope.builtin').lsp_implementations()
  end, { silent = true, buffer = bufnr, desc = 'Telescope show Lsp Implementation' })
  vim.keymap.set('n', 'gd', function()
    require('telescope.builtin').lsp_definitions()
  end, { silent = true, buffer = bufnr, desc = 'Telescope show Lsp Definition' })
  vim.keymap.set('n', 'gt', function()
    require('telescope.builtin').lsp_type_definitions()
  end, { silent = true, buffer = bufnr, desc = 'Telescope show Lsp Type Definition' })
  vim.keymap.set('n', 'gr', function()
    require('telescope.builtin').lsp_references()
  end, { silent = true, buffer = bufnr, desc = 'Telescope show Lsp References' })
  vim.keymap.set('n', 'ca', function()
    require('telescope.builtin').lsp_code_actions()
  end, { silent = true, buffer = bufnr, desc = 'Telescope show Lsp Code Action' })
  vim.keymap.set('n', 'gs', function()
    require('telescope.builtin').lsp_document_symbols()
  end, { silent = true, buffer = bufnr, desc = 'Telescope show Lsp Document Symbols' })
  vim.keymap.set('n', 'gS', function()
    require('telescope.builtin').lsp_workspace_symbols()
  end, { silent = true, buffer = bufnr, desc = 'Telescope show Workspace Symbols' })
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
    vim.lsp.buf.formatting()
  end, { desc = 'Lsp Format' })
  vim.api.nvim_buf_create_user_command(bufnr, 'Diagnostics', function()
    require('telescope.builtin').diagnostics()
  end, { desc = 'Telescope show Lsp Diagnostics' })
  require('aerial').on_attach(client, bufnr)
end

vim.api.nvim_call_function('sign_define', { 'DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' } })
vim.api.nvim_call_function('sign_define', { 'DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' } })
vim.api.nvim_call_function('sign_define', { 'DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' } })
vim.api.nvim_call_function('sign_define', { 'DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' } })

if vim.fn.executable('clangd') then
  require('lspconfig').clangd.setup({
    on_attach = on_attach,
    cmd = {
      'clangd',
      '--background-index',
      '--enable-config',
      '--header-insertion=iwyu',
      '--cross-file-rename',
      '--clang-tidy',
      '--completion-style=detailed',
      '--inlay-hints',
      '--function-arg-placeholders',
    },
  })
end

if vim.fn.executable('gopls') then
  require('lspconfig').gopls.setup({
    on_attach = on_attach,
  })
end
