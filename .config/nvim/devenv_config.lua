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
vim.opt.completeopt = 'menu,menuone,noinsert,noselect' -- Customize completions
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

vim.filetype.add({
  extension = {
    zsh = 'sh',
    sh = 'sh', -- force sh-files with zsh-shebang to still get sh as filetype
  },
  filename = {
    ['.zshrc'] = 'sh',
    ['.zshenv'] = 'sh',
  },
})

local pckr_lockfile = vim.env.VIM .. '/pckr/lockfile.lua'
local pckr_pack_dir = vim.env.VIM .. '/pckr'
local pckr_path = vim.env.VIM .. '/pckr/pckr.nvim'
if not (vim.uv or vim.loop).fs_stat(pckr_path) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/lewis6991/pckr.nvim',
    pckr_path,
  })
end
vim.opt.rtp:prepend(pckr_path)

require('pckr').setup({
  pack_dir = pckr_pack_dir,
  autoremove = true,
  lockfile = {
    path = pckr_lockfile,
  },
})

require('pckr').add({
  'lewis6991/fileline.nvim',
  {
    'folke/tokyonight.nvim',
    config = function()
      vim.cmd.colorscheme('tokyonight-moon')
    end,
  },
  {
    'stevearc/dressing.nvim',
    config = function()
      require('dressing').setup({
        select = {
          enabled = false,
        },
      })
    end,
  },
  {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'black' },
          json = { 'deno_fmt' },
          markdown = { 'deno_fmt' },
          bazel = { 'buildifier' },
        },
      })
    end,
  },
  {
    'saghen/blink.cmp',
    config = function()
      require('blink.cmp').setup({
        signature = {
          enabled = true,
        },
        keymap = {
          preset = 'super-tab',
        },
        fuzzy = { implementation = 'lua' },
        completion = {
          menu = {
            draw = {
              columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind' } },
            },
          },
        },
        snippets = { preset = 'mini_snippets' },
        sources = {
          default = { 'lsp', 'buffer', 'snippets', 'path', 'codecompanion' },
          providers = {
            codecompanion = {
              name = 'CodeCompanion',
              module = 'codecompanion.providers.completion.blink',
            },
          },
        },
      })
    end,
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.notify').setup({
        window = { config = { border = 'double' } },
      })
      vim.notify = MiniNotify.make_notify()
      require('mini.pick').setup()
      vim.ui.select = MiniPick.ui_select
      -- require('mini.git').setup()
      require('mini.icons').setup()
      MiniIcons.tweak_lsp_kind()
      MiniIcons.mock_nvim_web_devicons()
      require('mini.visits').setup()
      require('mini.diff').setup()
      require('mini.extra').setup()
      require('mini.misc').setup()
      MiniMisc.setup_auto_root({ 'MODULE.bazel', 'compile_commands.json', '.git' })
      require('mini.bracketed').setup()
      require('mini.comment').setup()
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
      local gen_loader = require('mini.snippets').gen_loader
      require('mini.snippets').setup({
        snippets = {
          gen_loader.from_file(vim.env.VIM .. 'runtime/snippets/all.json'),
          gen_loader.from_lang(),
        },
      })
      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
      local miniclue = require('mini.clue')
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
          { mode = 'n', keys = '[' }, -- mini.bracketed
          { mode = 'n', keys = ']' },
          { mode = 'x', keys = '[' },
          { mode = 'x', keys = ']' },
          { mode = 'i', keys = '<C-x>' }, -- Built-in completion
          { mode = 'n', keys = 'g' }, -- `g` key
          { mode = 'x', keys = 'g' },
          { mode = 'n', keys = "'" }, -- Marks
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },
          { mode = 'n', keys = '"' }, -- Registers
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },
          { mode = 'n', keys = '<C-w>' }, -- Window commands
          { mode = 'n', keys = 'z' }, -- `z` key
          { mode = 'x', keys = 'z' },
        },
        window = { config = { border = 'double' } },
      })
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup({
        direction = 'horizontal',
        open_mapping = [[<leader>t]],
        size = 30,
      })
    end,
  },
  {
    'smoka7/hop.nvim',
    config = function()
      require('hop').setup({
        keys = 'etovxqpdygfblzhckisuran',
        term_seq_bias = 0.5,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
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
    end,
    run = ':TSUpdate',
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    config = function()
      require('render-markdown').setup({
        file_types = { 'markdown', 'codecompanion' },
      })
    end,
    requires = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
  },
  {
    'olimorris/codecompanion.nvim',
    config = function()
      require('codecompanion').setup({
        strategies = {
          chat = {
            adapter = 'ollama',
            render_headers = true,
          },
          inline = {
            adapter = 'ollama',
          },
        },
      })
    end,
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'MeanderingProgrammer/render-markdown.nvim',
    },
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    requires = { 'mfussenegger/nvim-dap', 'mfussenegger/nvim-dap-python', 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-dap-virtual-text').setup()
    end,
  },
  {
    'danymat/neogen',
    config = function()
      require('neogen').setup({
        languages = {
          python = { template = { annotation_convention = 'numpydoc' } },
          c = { template = { annotation_convention = 'doxygen' } },
          cpp = { template = { annotation_convention = 'doxygen' } },
        },
      })
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
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
      if vim.fn.executable('lldb-dap') == 1 then
        dap.adapters.lldb = {
          type = 'executable',
          command = 'lldb-dap',
          name = 'lldb',
        }
      end

      if vim.fn.executable('OpenDebugAD7') == 1 then
        dap.adapters.cppdbg = {
          id = 'cppdbg',
          type = 'executable',
          command = 'OpenDebugAD7',
          MIMode = 'gdb',
          MIDebuggerPath = 'gdb',
        }
      end
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
          stopOnEntry = true,
          runInTerminal = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
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
    end,
  },
})

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

vim.keymap.set('n', '<leader>ff', [[<Cmd>Pick files<CR>]], { desc = 'Pick find files' })
vim.keymap.set('n', '<leader>fg', [[<Cmd>Pick grep_live<CR>]], { desc = 'Pick grep live' })
vim.keymap.set('n', '<leader>fG', [[<Cmd>Pick grep pattern='<cword>'<CR>]], { desc = 'Pick grep string under cursor' })

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

-- LSP settings
-- https://github.com/lewis6991/dotfiles/blob/main/config/nvim/lua/lewis6991/lsp.lua
local severity = {
  'error',
  'warn',
  'info',
  'info',
}
vim.lsp.handlers['window/showMessage'] = function(err, method, params, client_id)
  vim.notify(method.message, severity[params.type])
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client.supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
    vim.keymap.set('n', 'gd', function()
      vim.lsp.buf.definition()
    end, { silent = true, buffer = args.buf, desc = 'Lsp Definition' })
    vim.keymap.set('n', 'gt', function()
      vim.lsp.buf.type_definition()
    end, { silent = true, buffer = args.buf, desc = 'Lsp Type Definition' })
    vim.keymap.set('n', 'ca', function()
      vim.lsp.buf.code_action()
    end, { silent = true, buffer = args.buf, desc = 'Show Lsp Code Action' })
    vim.api.nvim_buf_create_user_command(args.buf, 'Rename', function()
      vim.lsp.buf.rename()
    end, { desc = 'Lsp Rename' })
  end,
})

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

vim.lsp.config('clangd', {
  cmd = {
    'clangd',
    '--clang-tidy',
    '--background-index',
    '--offset-encoding=utf-8',
    '--enable-config',
    '--header-insertion=iwyu',
    '--function-arg-placeholders',
    '--header-insertion-decorators',
    '--completion-style=bundled',
  },
  root_markers = { '.clangd', 'compile_commands.json', 'MODULE.bazel' },
  filetypes = { 'c', 'cpp' },
})

if vim.fn.executable('clangd') == 1 then
  vim.lsp.enable('clangd')
end

vim.lsp.config('ruff', {
  cmd = {
    'ruff',
    'server',
  },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
  },
  filetypes = { 'python' },
})

if vim.fn.executable('ruff') == 1 then
  vim.lsp.enable('ruff')
end

local pyright = vim.fn.executable('basedpyright') == 1 and 'basedpyright' or 'pyright'

vim.lsp.config('pyright', {
  cmd = {
    'basedpyright-langserver',
    '--stdio',
  },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
  },
  filetypes = { 'python' },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'strict',
      },
    },
  },
})

if vim.fn.executable('basedpyright') == 1 then
  vim.lsp.enable('pyright')
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

if vim.fn.executable('debugpy') == 1 then
  require('dap-python').setup('python3')
end
