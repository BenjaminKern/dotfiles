vim.opt.termguicolors = true -- Enable gui colors
vim.opt.undofile = false -- Disable persistent undo (see also `:h undodir`)
vim.opt.backup = false -- Don't store backup while overwriting the file
vim.opt.writebackup = false -- Don't store backup while overwriting the file
vim.opt.mouse = 'a' -- Enable mouse for all available modes
vim.opt.breakindent = true -- Indent wrapped lines to match line start
vim.opt.cursorline = true -- Highlight current line
vim.opt.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.opt.number = true -- Show line numbers
vim.opt.splitbelow = true -- Horizontal splits will be below
vim.opt.splitright = true -- Vertical splits will be to the right
vim.opt.ruler = false -- Don't show cursor position in command line
vim.opt.showmode = false -- Don't show mode in command line
vim.opt.wrap = false -- Display long lines as just one line
vim.opt.signcolumn = 'yes' -- Always show sign column (otherwise it will shift text)
vim.opt.fillchars = 'eob: ,vert:┃,horiz:━,horizdown:┳,horizup:┻,verthoriz:╋,vertleft:┫,vertright:┣'
vim.opt.pumblend = 10 -- Make builtin completion menus slightly transparent
vim.opt.pumheight = 10 -- Make popup menu smaller
vim.opt.winblend = 10 -- Make floating windows slightl transparent
vim.opt.listchars = 'tab: ,extends:…,precedes:…,nbsp:␣,eol:' -- Define which helper symbols to show
vim.opt.list = true
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
vim.opt.completeopt:append('fuzzy')
vim.o.foldtext = ''
vim.o.spelllang = 'en,de' -- Define spelling dictionaries
vim.o.spelloptions = 'camel' -- Treat parts of camelCase words as seprate words
vim.cmd.colorscheme('xyztokyo')

local path_package = vim.env.VIM .. '/deps'

local mini_path = vim.env.VIM .. '/runtime/pack/dist/opt/mini.deps'
if not vim.loop.fs_stat(mini_path) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.deps',
    mini_path,
  })
end
vim.cmd([[packadd mini.deps]])
require('mini.deps').setup({ path = { package = path_package } })

local add = MiniDeps.add
local later = MiniDeps.later
local now = MiniDeps.now
add({
  source = 'echasnovski/mini.nvim',
})
add({
  source = 'akinsho/toggleterm.nvim',
})
require('toggleterm').setup({
  shell = vim.fn.has('unix') == 1 and '/usr/bin/env bash' or 'cmd.exe',
  direction = 'horizontal',
  open_mapping = [[<leader>t]],
  size = 30,
})
add({
  source = 'neovim/nvim-lspconfig',
})
add({
  source = 'stevearc/dressing.nvim',
})
later(function()
  add({
    source = 'stevearc/conform.nvim',
  })
  require('conform').setup({
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'black' },
      json = { 'deno_fmt' },
      markdown = { 'deno_fmt' },
      bazel = { 'buildifier' },
    },
  })
end)
add({
  source = 'smoka7/hop.nvim',
})
require('hop').setup({
  keys = 'etovxqpdygfblzhckisuran',
  term_seq_bias = 0.5,
})
add({
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = {
    post_checkout = function()
      vim.cmd([[TSUpdate]])
    end,
  },
})
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
  highlight = { enable = true },
})
add({
  source = 'rcarriga/nvim-dap-ui',
  depends = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
})
add({
  source = 'theHamsta/nvim-dap-virtual-text',
  depends = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' },
})

later(function()
  add('danymat/neogen')
  require('neogen').setup({
    snippet_engine = 'nvim',
    languages = {
      python = { template = { annotation_convention = 'numpydoc' } },
      c = { template = { annotation_convention = 'doxygen' } },
      cpp = { template = { annotation_convention = 'doxygen' } },
    },
  })
end)

vim.keymap.set('n', 'ww', function()
  require('hop').hint_words()
end, { desc = 'Use hop' })

vim.api.nvim_create_user_command('Format', function()
  require('conform').format({ lsp_fallback = true })
end, { desc = 'Format' })

vim.keymap.set('n', '<C-Z>', '<NOP>')

vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function(args)
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'cpp', 'c' },
  callback = function(ev)
    vim.api.nvim_set_option_value('tw', 79, { scope = 'local' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'cpp' },
  callback = function(ev)
    vim.api.nvim_set_option_value('commentstring', '// %s', { scope = 'local' })
  end,
})

vim.api.nvim_create_user_command('Trim', function()
  MiniTrailspace.trim()
end, { desc = 'Trim trailing whitespace' })

vim.keymap.set('n', 'Y', 'y$', { desc = 'Yank till the end of the line' })
vim.keymap.set('n', '<leader>d', function()
  if not MiniFiles.close() then
    MiniFiles.open()
  end
end, { desc = 'Toggle file tree' })
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { desc = 'Escape from terminal' })

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

require('mini.icons').setup()
later(MiniIcons.tweak_lsp_kind)
MiniIcons.mock_nvim_web_devicons()
require('mini.visits').setup()
require('mini.diff').setup()
require('mini.pick').setup()
require('mini.extra').setup()
require('mini.misc').setup()
MiniMisc.setup_auto_root()
require('mini.bracketed').setup()
require('mini.comment').setup()
require('mini.completion').setup()
require('mini.cursorword').setup()
require('mini.indentscope').setup()
require('mini.starter').setup({
  header = [[
██╗  ██╗██╗   ██╗███████╗
╚██╗██╔╝╚██╗ ██╔╝╚══███╔╝
 ╚███╔╝  ╚████╔╝   ███╔╝ 
 ██╔██╗   ╚██╔╝   ███╔╝  
██╔╝ ██╗   ██║   ███████╗
╚═╝  ╚═╝   ╚═╝   ╚══════╝]],
})
require('mini.statusline').setup({
  set_vim_settings = false,
})
require('mini.tabline').setup()
require('mini.trailspace').setup()
require('mini.align').setup()
require('mini.surround').setup()
require('mini.files').setup()
require('mini.notify').setup()
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
later(function()
  local hipatterns = require('mini.hipatterns')
  hipatterns.setup({
    highlighters = {
      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)
later(function()
  local miniclue = require('mini.clue')
  --stylua: ignore
  miniclue.setup({
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' }, -- Leader triggers
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = '[' },        -- mini.bracketed
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' },    -- Built-in completion
      { mode = 'n', keys = 'g' },        -- `g` key
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },        -- Marks
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' },        -- Registers
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' },    -- Window commands
      { mode = 'n', keys = 'z' },        -- `z` key
      { mode = 'x', keys = 'z' },
    },
    window = { config = { border = 'double' } },
  })
end)

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

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

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
  { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
)
vim.fn.sign_define(
  'DapBreakpointCondition',
  { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
)
vim.fn.sign_define(
  'DapBreakpointRejected',
  { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
)
vim.fn.sign_define(
  'DapLogPoint',
  { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' }
)
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

if vim.fn.executable('lldb-dap') == 1 then
  dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-dap',
    name = 'lldb',
  }
  dap.configurations.cpp = {
    {
      name = 'Launch file',
      type = 'lldb',
      request = 'launch',
      program = function()
        return coroutine.create(function(dap_run_co)
          vim.ui.input(
            { prompt = 'Path to executable: ', default = vim.fn.getcwd() .. '/', completion = 'file' },
            function(input)
              coroutine.resume(dap_run_co, input)
            end
          )
        end)
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
