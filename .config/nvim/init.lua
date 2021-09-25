vim.cmd [[packadd plug]]

local Plug = vim.fn['plug#']

local plugged_path = vim.env.VIM .. '/plugged'

vim.call('plug#begin', plugged_path)
  Plug 'junegunn/vim-peekaboo'
  Plug 'tpope/vim-fugitive'
  Plug 'junegunn/gv.vim'
  Plug 'morhetz/gruvbox'
  Plug 'mhinz/vim-startify'
  Plug 'terrortylor/nvim-comment'
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'simrat39/symbols-outline.nvim'
  Plug 'onsails/lspkind-nvim'
  Plug 'kosayoda/nvim-lightbulb'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'shadmansaleh/lualine.nvim'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'vijaymarupudi/nvim-fzf'
  Plug 'ibhagwan/fzf-lua'
  Plug 'phaazon/hop.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-compe'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'ahmedkhalf/project.nvim'
vim.call('plug#end')

--Incremental live completion
vim.o.inccommand = 'nosplit'

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Do not save when switching buffers
vim.o.hidden = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.cmd [[set undofile]]

--Lightbulb
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.expandtab = true
vim.o.smarttab = true
vim.o.shiftwidth = 2
vim.o.textwidth = 80

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

--Set colorscheme (order is important here)
vim.o.termguicolors = true
-- vim.g.gruvbox_terminal_italics = 0
vim.cmd [[colorscheme gruvbox]]

--Remap , as leader key
vim.api.nvim_set_keymap('', ',', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ','
vim.g.maplocalleader = ','

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

--Map blankline
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_char_highlight = 'LineNr'
vim.g.indent_blankline_show_trailing_blankline_indent = false

require('hop').setup {
  keys = 'etovxqpdygfblzhckisuran', 
  term_seq_bias = 0.5
}
vim.api.nvim_set_keymap('n', 'ww', "<cmd>lua require('hop').hint_words()<cr>", {})

local actions = require('fzf-lua.actions')
require('fzf-lua').setup {
  fzf_bin = 'sk'
}

vim.api.nvim_set_keymap('n', '<leader>f', [[<cmd>lua require('fzf-lua').files()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>g', [[<cmd>lua require('fzf-lua').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gg', [[<cmd>lua require('fzf-lua').grep_cword()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d', [[<cmd>lua require('nvim-tree').toggle()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>o', [[<cmd>lua require('symbols-outline').toggle_outline()<CR>]], { noremap = true, silent = true })

-- Highlight on yank
vim.api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
  false
)

-- Y yank until the end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- LSP settings
local nvim_lsp = require 'lspconfig'
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignError", {text = "", texthl = "GruvboxRed"}})
vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignWarning", {text = "", texthl = "GruvboxYellow"}})
vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignInformation", {text = "", texthl = "GruvboxBlue"}})
vim.api.nvim_call_function("sign_define", {"LspDiagnosticsSignHint", {text = "", texthl = "GruvboxAqua"}})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Enable the following language servers
local servers = { 'clangd', 'pyright' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Compe setup
require('compe').setup {
  source = {
    path = true,
    nvim_lsp = true,
    luasnip = true,
    buffer = false,
    calc = false,
    nvim_lua = false,
    vsnip = false,
    ultisnips = false,
  },
}

-- Utility functions for compe and luasnip
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col '.' - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
local luasnip = require 'luasnip'

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif luasnip.expand_or_jumpable() then
    return t '<Plug>luasnip-expand-or-jump'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  elseif luasnip.jumpable(-1) then
    return t '<Plug>luasnip-jump-prev'
  else
    return t '<S-Tab>'
  end
end

-- Map tab to the above tab complete functiones
vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })

-- Map compe confirm and complete functions
vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', { expr = true })

require('lualine').setup()
-- require("bufferline").setup()
require('colorizer').setup()
require('lsp_signature').setup()
require('nvim_comment').setup()
require('lspkind').init()
require("project_nvim").setup()

vim.g.nvim_tree_update_cwd = 1
vim.g.nvim_tree_respect_buf_cwd = 1
