vim.cmd [[packadd plug]]

local Plug = vim.fn['plug#']

local plugged_path = vim.env.VIM .. '/plugged'

vim.call('plug#begin', plugged_path)
  Plug 'tversteeg/registers.nvim'
  Plug 'rktjmp/lush.nvim'
  Plug 'ellisonleao/gruvbox.nvim'
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
  Plug 'rafamadriz/friendly-snippets'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'ahmedkhalf/project.nvim'
  Plug 'akinsho/toggleterm.nvim'
  Plug 'antoinemadec/FixCursorHold.nvim' -- https://github.com/neovim/neovim/issues/12587
  -- Plug 'folke/which-key.nvim'
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

vim.g.registers_window_border = 'rounded'

require('hop').setup {
  keys = 'etovxqpdygfblzhckisuran', 
  term_seq_bias = 0.5
}
vim.api.nvim_set_keymap('n', 'ww', "<cmd>lua require('hop').hint_words()<cr>", {})

local actions = require('fzf-lua.actions')
require('fzf-lua').setup{
  files = {
    cmd = 'fd --color never --type f --hidden --ignore-file ' .. vim.env.VIM .. '/.fd-ignore',
  }
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

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        feedkey("<C-n>", "n")
      elseif vim.fn["vsnip#available"]() == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if vim.fn.pumvisible() == 1 then
        feedkey("<C-p>", "n")
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
  formatting = {
    format = function(entry, vim_item)
      -- fancy icons and a name of kind
      vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

      -- set a name for each source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        vsnip = "[VSnip]",
        nvim_lua = "[Lua]",
      })[entry.source.name]
      return vim_item
    end,
  },
}

-- LSP settings
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

vim.api.nvim_call_function("sign_define", {"DiagnosticSignError", {text = "", texthl = "DiagnosticSignError"}})
vim.api.nvim_call_function("sign_define", {"DiagnosticSignWarning", {text = "", texthl = "DiagnosticSignWarning"}})
vim.api.nvim_call_function("sign_define", {"DiagnosticSignInformation", {text = "", texthl = "DiagnosticSignInformation"}})
vim.api.nvim_call_function("sign_define", {"DiagnosticSignHint", {text = "", texthl = "DiagnosticSignHint"}})

-- Enable the following language servers
local servers = { 'clangd', 'pyright' }
for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  }
end

require('lualine').setup()
-- require("bufferline").setup()
require('colorizer').setup()
require('lsp_signature').setup()
require('nvim_comment').setup()
require('lspkind').init()
require('project_nvim').setup()
require('toggleterm').setup{
  direction = "float",
  float_opts = {
    border = "double",
  },
  open_mapping = [[<leader>t]],
}
vim.api.nvim_set_keymap('t', '<esc>', [[<C-\><C-n>]], { noremap = true})
require('nvim-tree').setup {
  update_cwd = true
}
