vim.cmd([[packadd plug]])

local Plug = vim.fn['plug#']

local root_plugged_path = vim.env.VIM

local plugged_path = root_plugged_path .. '/plugged'

vim.call('plug#begin', plugged_path)
Plug('L3MON4D3/LuaSnip')
Plug('ahmedkhalf/project.nvim')
Plug('akinsho/toggleterm.nvim')
Plug('benfowler/telescope-luasnip.nvim')
Plug('echasnovski/mini.nvim')
Plug('nvim-tree/nvim-tree.lua')
Plug('kyazdani42/nvim-web-devicons')
Plug('lewis6991/gitsigns.nvim')
Plug('mfussenegger/nvim-dap')
Plug('neovim/nvim-lspconfig')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('nvim-treesitter/nvim-treesitter')
Plug('phaazon/hop.nvim')
Plug('rcarriga/nvim-dap-ui')
Plug('rcarriga/nvim-notify')
Plug('sainnhe/gruvbox-material')
Plug('sindrets/diffview.nvim')
Plug('stevearc/dressing.nvim')
Plug('theHamsta/nvim-dap-virtual-text')
Plug('folke/todo-comments.nvim')
Plug('ThePrimeagen/refactoring.nvim')
vim.call('plug#end')

vim.g.do_filetype_lua = true
vim.g.mapleader = ','
vim.g.maplocalleader = ','
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.inccommand = 'nosplit'
vim.opt.laststatus = 3
vim.opt.mouse = 'a'
vim.opt.shiftwidth = 2
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.undofile = false
vim.opt.background = 'dark'
vim.opt.completeopt = { 'menu', 'noinsert', 'noselect' }
vim.wo.number = true
vim.wo.signcolumn = 'yes'

vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_disable_italic_comment = true
vim.cmd([[colorscheme gruvbox-material]])

vim.keymap.set('n', '<C-Z>', '<NOP>')

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

vim.cmd([[autocmd FileType cpp setlocal commentstring=//\ %s]])

local notify = require('notify')
notify.setup({
  timeout = '4000',
  stages = 'fade',
})
vim.notify = notify

vim.api.nvim_create_user_command('Buffers', function()
  require('telescope.builtin').buffers()
end, { desc = 'Telescope show Buffers' })
vim.api.nvim_create_user_command('Registers', function()
  require('telescope.builtin').registers()
end, { desc = 'Telescope show Registers' })
vim.api.nvim_create_user_command('Snippets', function()
  require('telescope').extensions.luasnip.luasnip()
end, { desc = 'Telescope show Lua Snippets' })
vim.api.nvim_create_user_command('Trim', function()
  MiniTrailspace.trim()
end, { desc = 'Trim trailing whitespace' })
vim.api.nvim_create_user_command('Messages', function()
  require('telescope').extensions.notify.notify()
end, { desc = 'Telescope show notifications' })
vim.api.nvim_create_user_command('SessionOpen', function()
  MiniSessions.select('read')
end, { desc = 'Open session' })
vim.api.nvim_create_user_command('SessionSave', function()
  MiniSessions.write('.session.vim')
end, { desc = 'Save local session' })
vim.api.nvim_create_user_command('SessionDelete', function()
  MiniSessions.select('delete')
end, { desc = 'Delete session' })

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function feedkeys(key)
  local mode = ''
  vim.api.nvim_feedkeys(t(key), mode, true)
end

vim.keymap.set('n', 'Y', 'y$', { desc = 'Yank till the end of the line' })
vim.keymap.set('n', '<leader>d', ':NvimTreeToggle<CR>', { desc = 'Toggle nvim tree'})
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
require('gitsigns').setup()
require('project_nvim').setup()
require('hop').setup({
  keys = 'etovxqpdygfblzhckisuran',
  term_seq_bias = 0.5,
})
vim.keymap.set('n', 'ww', function()
  require('hop').hint_words()
end, { desc = 'Use hop' })

require('nvim-tree').setup({
  update_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
})

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
telescope.load_extension('luasnip')
telescope.load_extension('notify')

require('toggleterm').setup({
  shell = vim.fn.has('unix') == 1 and '/usr/bin/env bash' or 'cmd.exe',
  direction = 'float',
  float_opts = {
    border = 'double',
  },
  open_mapping = [[<leader>t]],
})

local Terminal = require('toggleterm.terminal').Terminal
local btop = Terminal:new({ cmd = vim.fn.has('unix') == 1 and 'btop' or 'btm', hidden = true })

vim.api.nvim_create_user_command('Btop', function()
  btop:toggle()
end, { desc = 'btop/bottom' })

require('mini.bracketed').setup()
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
  file = '.session.vim',
  verbose = { write = true, delete = true },
})
require('mini.align').setup()
require('mini.surround').setup()
require('mini.pairs').setup()
require('mini.fuzzy').setup()
require('mini.pairs').unmap('i', '"', '""')
require('mini.pairs').unmap('i', "'", "''")

-- LSP settings
local severity = {
  'error',
  'warn',
  'info',
  'info',
}
vim.lsp.handlers['window/showMessage'] = function(err, method, params, client_id)
  vim.notify(method.message, severity[params.type])
end
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.MiniCompletion.completefunc_lsp')

  require('vim.lsp.protocol').CompletionItemKind[1] = ''
  require('vim.lsp.protocol').CompletionItemKind[2] = ''
  require('vim.lsp.protocol').CompletionItemKind[3] = ''
  require('vim.lsp.protocol').CompletionItemKind[4] = ''
  require('vim.lsp.protocol').CompletionItemKind[5] = 'ﰠ'
  require('vim.lsp.protocol').CompletionItemKind[6] = ''
  require('vim.lsp.protocol').CompletionItemKind[7] = 'ﴯ'
  require('vim.lsp.protocol').CompletionItemKind[8] = ''
  require('vim.lsp.protocol').CompletionItemKind[9] = ''
  require('vim.lsp.protocol').CompletionItemKind[10] = 'ﰠ'
  require('vim.lsp.protocol').CompletionItemKind[11] = '塞'
  require('vim.lsp.protocol').CompletionItemKind[12] = ''
  require('vim.lsp.protocol').CompletionItemKind[13] = ''
  require('vim.lsp.protocol').CompletionItemKind[14] = ''
  require('vim.lsp.protocol').CompletionItemKind[15] = ''
  require('vim.lsp.protocol').CompletionItemKind[16] = ''
  require('vim.lsp.protocol').CompletionItemKind[17] = ''
  require('vim.lsp.protocol').CompletionItemKind[18] = ''
  require('vim.lsp.protocol').CompletionItemKind[19] = ''
  require('vim.lsp.protocol').CompletionItemKind[20] = ''
  require('vim.lsp.protocol').CompletionItemKind[21] = ''
  require('vim.lsp.protocol').CompletionItemKind[22] = 'פּ'
  require('vim.lsp.protocol').CompletionItemKind[23] = ''
  require('vim.lsp.protocol').CompletionItemKind[24] = ''
  require('vim.lsp.protocol').CompletionItemKind[25] = '𝙏'

  vim.keymap.set('n', 'K', function()
    vim.lsp.buf.hover()
  end, { silent = true, buffer = bufnr, desc = 'Lsp Hover' })
  vim.keymap.set('n', 'gi', function()
    vim.lsp.buf.implementation()
  end, { silent = true, buffer = bufnr, desc = 'Lsp Implementation' })
  vim.keymap.set('n', 'gd', function()
    vim.lsp.buf.definition()
  end, { silent = true, buffer = bufnr, desc = 'Lsp Definition' })
  vim.keymap.set('n', 'gt', function()
    vim.lsp.buf.type_definition()
  end, { silent = true, buffer = bufnr, desc = 'Lsp Type Definition' })
  vim.keymap.set('n', 'gr', function()
    require('telescope.builtin').lsp_references()
  end, { silent = true, buffer = bufnr, desc = 'Telescope show Lsp References' })
  vim.keymap.set('n', 'gs', function()
    require('telescope.builtin').lsp_document_symbols()
  end, { silent = true, buffer = bufnr, desc = 'Telescope show Lsp Document Symbols' })
  vim.keymap.set('n', 'gS', function()
    require('telescope.builtin').lsp_workspace_symbols()
  end, { silent = true, buffer = bufnr, desc = 'Telescope show Workspace Symbols' })
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
    vim.lsp.buf.format()
  end, { desc = 'Lsp Format' })
  vim.api.nvim_buf_create_user_command(bufnr, 'Diagnostics', function()
    require('telescope.builtin').diagnostics()
  end, { desc = 'Telescope show Lsp Diagnostics' })
  vim.api.nvim_buf_create_user_command(bufnr, 'Rename', function()
    vim.lsp.buf.rename()
  end, { desc = 'Lsp Rename' })
  vim.keymap.set('n', 'ca', function()
    vim.lsp.buf.code_action()
  end, { silent = true, buffer = bufnr, desc = 'Show Lsp Code Action' })
end

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

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

local dap = require('dap')
local dapui = require('dapui')
dapui.setup({
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = 'repl', size = 0.25 },
        { id = 'watches', size = 0.25 },
        { id = 'breakpoints', size = 0.20 },
        { id = 'stacks', size = 0.30 },
      },
      size = 40,
      position = 'left',
    },
    {
      elements = {
        { id = 'scopes', size = 0.60 },
        { id = 'console', size = 0.40 },
      },
      size = 0.30,
      position = 'bottom',
    },
  },
})
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#993939', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379', bg = '#31353f' })

vim.fn.sign_define(
  'DapBreakpoint',
  { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
)
vim.fn.sign_define(
  'DapBreakpointCondition',
  { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
)
vim.fn.sign_define(
  'DapBreakpointRejected',
  { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
)
vim.fn.sign_define(
  'DapLogPoint',
  { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' }
)
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

if vim.fn.executable('lldb-vscode') then
  dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-vscode',
    name = 'lldb',
  }
  dap.configurations.cpp = {
    {
      name = 'Launch file',
      type = 'lldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      runInTerminal = false,
    },
  }
  dap.configurations.c = dap.configurations.cpp
end

require('nvim-dap-virtual-text').setup()
require('todo-comments').setup()
require('refactoring').setup()
vim.api.nvim_set_keymap(
    "v",
    "<leader>rr",
    ":lua require('refactoring').select_refactor()<CR>",
    { noremap = true, silent = true, expr = false }
)

vim.keymap.set('n', '<F5>', function()
  dap.continue()
end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F9>', function()
  dap.toggle_breakpoint()
end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<F10>', function()
  dap.step_over()
end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F11>', function()
  dap.step_into()
end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F12>', function()
  dap.step_out()
end, { desc = 'Debug: Step Out' })
vim.api.nvim_create_user_command('DebugListBreakpoints', function()
  dap.list_breakpoints()
end, { desc = 'Debug: List Breakpoints' })
vim.api.nvim_create_user_command('DebugClearBreakpoints', function()
  dap.clear_breakpoints()
end, { desc = 'Debug: Clear Breakpoints' })
vim.api.nvim_create_user_command('DebugSetBreakpoint', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Debug: Set Conditional Breakpoint' })
vim.api.nvim_create_user_command('DebugSetLogpoint', function()
  dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, { desc = 'Debug: Set Log Point Message' })
vim.api.nvim_create_user_command('DebugConsole', function()
  dap.repl.toggle()
end, { desc = 'Debug: Toggle Debug Console' })
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'c', 'cpp', 'lua', 'go', 'python', 'bash' },
  highlight = {
    enable = true,
  },
})
