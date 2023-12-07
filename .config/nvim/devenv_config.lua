local plugins = {
  'L3MON4D3/LuaSnip',
  'akinsho/toggleterm.nvim',
  { 'echasnovski/mini.nvim', dependencies = { 'kyazdani42/nvim-web-devicons' } },
  'lewis6991/gitsigns.nvim',
  'neovim/nvim-lspconfig',
  'phaazon/hop.nvim',
  { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap' } },
  'rcarriga/nvim-notify',
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    config = function()
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  },
  'sindrets/diffview.nvim',
  'stevearc/dressing.nvim',
  'stevearc/conform.nvim',
  { 'theHamsta/nvim-dap-virtual-text', dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' } },
}

local lazypath = vim.env.VIM .. '/lazy/lazy.nvim'
local lazyplugins = vim.env.VIM .. '/lazy'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup(plugins, { root = lazyplugins })

-- General
vim.opt.undofile = false -- Disable persistent undo (see also `:h undodir`)

vim.opt.backup = false -- Don't store backup while overwriting the file
vim.opt.writebackup = false -- Don't store backup while overwriting the file

vim.opt.mouse = 'a' -- Enable mouse for all available modes

-- Appearance
vim.opt.breakindent = true -- Indent wrapped lines to match line start
vim.opt.cursorline = true -- Highlight current line
vim.opt.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.opt.number = true -- Show line numbers
vim.opt.splitbelow = true -- Horizontal splits will be below
vim.opt.splitright = true -- Vertical splits will be to the right
vim.opt.termguicolors = true -- Enable gui colors

vim.opt.ruler = false -- Don't show cursor position in command line
vim.opt.showmode = false -- Don't show mode in command line
vim.opt.wrap = false -- Display long lines as just one line

vim.opt.signcolumn = 'yes' -- Always show sign column (otherwise it will shift text)
vim.opt.fillchars = 'eob: ,vert:┃,horiz:━,horizdown:┳,horizup:┻,verthoriz:╋,vertleft:┫,vertright:┣'

vim.opt.pumblend = 10 -- Make builtin completion menus slightly transparent
vim.opt.pumheight = 10 -- Make popup menu smaller
vim.opt.winblend = 10 -- Make floating windows slightly transparent
vim.opt.listchars = 'tab:> ,extends:…,precedes:…,nbsp:␣' -- Define which helper symbols to show
vim.opt.list = true

-- Editing
vim.opt.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
vim.opt.incsearch = true -- Show search results while typing
vim.opt.infercase = true -- Infer letter cases for a richer built-in keyword completion
vim.opt.smartcase = true -- Don't ignore case when searching if pattern has upper case
vim.opt.smartindent = true -- Make indenting smart

vim.opt.completeopt = 'menuone,noinsert,noselect' -- Customize completions
vim.opt.virtualedit = 'block' -- Allow going past the end of line in visual block mode
vim.opt.formatoptions = 'qjl1' -- Don't autoformat comments

vim.g.do_filetype_lua = true
vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.opt.expandtab = true

vim.opt.hidden = true
vim.opt.hlsearch = false
vim.opt.inccommand = 'nosplit'
vim.opt.laststatus = 3
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.swapfile = false

vim.opt.shortmess:append('WcC')
vim.opt.splitkeep = 'screen'

vim.opt.background = 'dark'
vim.g.gruvbox_material_background = 'hard'

vim.keymap.set('n', '<C-Z>', '<NOP>')

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
  MiniPick.builtin.buffers()
end, { desc = 'Pick show Buffers' })
vim.api.nvim_create_user_command('Registers', function()
  MiniExtra.pickers.registers()
end, { desc = 'Telescope show Registers' })
-- vim.api.nvim_create_user_command('Snippets', function()
--   require('telescope').extensions.luasnip.luasnip()
-- end, { desc = 'Telescope show Lua Snippets' })
vim.api.nvim_create_user_command('Trim', function()
  MiniTrailspace.trim()
end, { desc = 'Trim trailing whitespace' })
vim.api.nvim_create_user_command('Diagnostic', function()
  MiniExtra.pickers.diagnostic()
end, { desc = 'Pick show diagnostic' })
vim.api.nvim_create_user_command('SessionOpen', function()
  MiniSessions.select('read')
end, { desc = 'Open session' })
vim.api.nvim_create_user_command('SessionSave', function()
  MiniSessions.write('.session.vim')
end, { desc = 'Save local session' })
vim.api.nvim_create_user_command('SessionDelete', function()
  MiniSessions.select('delete')
end, { desc = 'Delete session' })

vim.keymap.set('n', 'Y', 'y$', { desc = 'Yank till the end of the line' })
vim.keymap.set('n', '<leader>d', function()
  if not MiniFiles.close() then
    MiniFiles.open()
  end
end, { desc = 'Toggle nvim tree' })
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { desc = 'Escape from terminal' })

local luasnip = require('luasnip')
luasnip.config.set_config({ history = true })
luasnip.filetype_extend('all', { '_' })
require('luasnip.loaders.from_snipmate').lazy_load()

vim.keymap.set('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

local keys = {
  ['cr'] = vim.api.nvim_replace_termcodes('<CR>', true, true, true),
  ['ctrl-y'] = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
  ['ctrl-y_cr'] = vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
}
_G.cr_action = function()
  if vim.fn.pumvisible() ~= 0 then
    local item_selected = vim.fn.complete_info()['selected'] ~= -1
    return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
  else
    return keys['cr']
  end
end
vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })

vim.keymap.set('n', '<leader>ff', [[<Cmd>Pick files<CR>]], { desc = 'Pick find files' })
vim.keymap.set('n', '<leader>fg', [[<Cmd>Pick grep_live<CR>]], { desc = 'Pick grep live' })
vim.keymap.set('n', '<leader>fG', [[<Cmd>Pick grep pattern='<cword>'<CR>]], { desc = 'Pick grep string under cursor' })

require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'black' },
    json = { 'deno_fmt' },
    markdown = { 'deno_fmt' },
  },
})
vim.api.nvim_create_user_command('Format', function()
  require('conform').format({ lsp_fallback = true })
end, { desc = 'Format' })
require('gitsigns').setup()
require('hop').setup({
  keys = 'etovxqpdygfblzhckisuran',
  term_seq_bias = 0.5,
})
vim.keymap.set('n', 'ww', function()
  require('hop').hint_words()
end, { desc = 'Use hop' })
local fd_ignore_file = vim.env.VIM .. '/.fd-ignore'

require('toggleterm').setup({
  shell = vim.fn.has('unix') == 1 and '/usr/bin/env bash' or 'cmd.exe',
  direction = 'float',
  open_mapping = [[<leader>t]],
})

local Terminal = require('toggleterm.terminal').Terminal
local btop = Terminal:new({ cmd = vim.fn.has('unix') == 1 and 'btop' or 'btm', hidden = true })

vim.api.nvim_create_user_command('Btop', function()
  btop:toggle()
end, { desc = 'btop/bottom' })

require('mini.pick').setup()
require('mini.extra').setup()
require('mini.misc').setup()
MiniMisc.setup_auto_root()
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
require('mini.files').setup()
local files_set_cwd = function(path)
  -- Works only if cursor is on the valid file system entry
  local cur_entry_path = MiniFiles.get_fs_entry().path
  local cur_directory = vim.fs.dirname(cur_entry_path)
  vim.fn.chdir(cur_directory)
end
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    vim.keymap.set('n', 'g~', files_set_cwd, { buffer = args.data.buf_id })
  end,
})
local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    -- Highlight hex color strings (`#rrggbb`) using that color
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

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
    vim.lsp.buf.references()
  end, { silent = true, buffer = bufnr, desc = 'Lsp References' })
  vim.keymap.set('n', 'gs', function()
    vim.lsp.buf.document_symbol()
  end, { silent = true, buffer = bufnr, desc = 'Lsp Document Symbols' })
  vim.keymap.set('n', 'gS', function()
    vim.lsp.buf.workspace_symbol()
  end, { silent = true, buffer = bufnr, desc = 'Workspace Symbols' })
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

if vim.fn.executable('clangd') == 1 then
  require('lspconfig').clangd.setup({
    on_attach = on_attach,
    cmd = {
      'clangd',
      '--background-index',
      '--enable-config',
      '--header-insertion=iwyu',
      '--clang-tidy',
      '--completion-style=bundled',
      '--function-arg-placeholders',
      '--header-insertion-decorators',
    },
  })
end

if vim.fn.executable('pylsp') == 1 then
  require('lspconfig').pylsp.setup({
    on_attach = on_attach,
  })
end

if vim.fn.executable('gopls') == 1 then
  require('lspconfig').gopls.setup({
    on_attach = on_attach,
  })
end

if vim.fn.executable('starlark') == 1 then
  require('lspconfig').starlark_rust.setup({
    on_attach = on_attach,
  })
end

if vim.fn.executable('deno') == 1 then
  require('lspconfig').denols.setup({
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

if vim.fn.executable('lldb-vscode') == 1 then
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
  ensure_installed = {
    'vim',
    'regex',
    'c',
    'cpp',
    'lua',
    'go',
    'python',
    'bash',
    'cmake',
    'markdown',
    'markdown_inline',
    'json',
    'yaml',
    'diff',
    'dockerfile',
    'starlark',
    'typescript',
    'javascript',
    'comment',
  },
  highlight = {
    enable = true,
  },
})
