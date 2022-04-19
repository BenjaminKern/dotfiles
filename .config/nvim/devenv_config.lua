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
vim.opt.background = "dark"
vim.o.termguicolors = true

vim.cmd([[colorscheme gruvbox-material]])

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


vim.cmd([[ command! GV execute "lua require('telescope.builtin').git_commits()<CR>" ]])
vim.cmd([[ command! Trim execute "lua MiniTrailspace.trim()<CR>" ]])

vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "<leader>d", function() require('nvim-tree').toggle() end)
vim.keymap.set("n", "ww", function() require('hop').hint_words() end)
vim.keymap.set('i', '<Tab>', function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end, { expr = true })
vim.keymap.set('i', '<S-Tab>', function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<Tab>" end, { expr = true })
vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() ~= 0 then
    -- If popup is visible, confirm selected item or add new line otherwise
    local item_selected = vim.fn.complete_info()['selected'] ~= -1
    return item_selected and vim.api.nvim_replace_termcodes('<C-y>', true, true, true) or vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true)
  else
    return vim.api.nvim_replace_termcodes('<CR>', true, true, true)
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

  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
  require("aerial").on_attach(client, bufnr)
  -- vim.cmd([[ command! LspDiagnostics execute "lua require('fzf-lua').lsp_workspace_diagnostics()<CR>" ]])
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
