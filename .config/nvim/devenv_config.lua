-- ============================================================================
-- NEOVIM CONFIGURATION - devenv_config.lua
-- ============================================================================
-- A comprehensive Neovim setup focused on development with C++, Python, and Bazel
-- Author: Your Name
-- Last Modified: $(date)
-- ============================================================================

-- ============================================================================
-- BASIC VIM OPTIONS
-- ============================================================================

-- Visual and display settings
vim.opt.termguicolors = true -- Enable 24-bit RGB colors in terminal
vim.opt.cursorline = true -- Highlight the current line
vim.opt.number = true -- Show line numbers
vim.opt.signcolumn = "yes" -- Always show sign column to prevent text shifting
vim.opt.wrap = false -- Don't wrap long lines
vim.opt.linebreak = true -- Wrap long lines at 'breakat' characters (if wrap is enabled)
vim.opt.breakindent = true -- Indent wrapped lines to match line start
vim.opt.ruler = false -- Don't show cursor position in command line
vim.opt.showmode = false -- Don't show mode in command line (handled by statusline)
vim.opt.laststatus = 3 -- Global statusline

-- Split behavior
vim.opt.splitbelow = true -- Horizontal splits open below current window
vim.opt.splitright = true -- Vertical splits open to the right of current window
vim.opt.splitkeep = "screen" -- Keep the same relative cursor position when splitting

-- UI enhancements
vim.opt.pumblend = 10 -- Make completion menus slightly transparent
vim.opt.pumheight = 10 -- Limit popup menu height
vim.opt.winblend = 10 -- Make floating windows slightly transparent

-- Define custom fill characters for splits and folds
vim.opt.fillchars = "eob: ,vert:┃,horiz:━,horizdown:┳,horizup:┻,verthoriz:╋,vertleft:┫,vertright:┣"

-- Show whitespace and special characters
vim.opt.listchars = "tab: ,extends:…,precedes:…,nbsp:␣,eol:" -- Define which helper symbols to show
vim.opt.list = true -- Enable display of listchars

-- File and backup settings
vim.opt.undofile = false -- Disable persistent undo (see also `:h undodir`)
vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't create backup while overwriting
vim.opt.swapfile = false -- Disable swap files
vim.opt.hidden = true -- Allow switching buffers without saving

-- Mouse and input
vim.opt.mouse = "a" -- Enable mouse for all modes
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time (for which-key style plugins)
vim.opt.updatetime = 250 -- Decrease update time for CursorHold events

-- Search settings
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override ignorecase if search contains uppercase
vim.opt.incsearch = true -- Show search results while typing
vim.opt.hlsearch = false -- Don't highlight search results after search is done
vim.opt.inccommand = "nosplit" -- Show live preview of substitution commands

-- Indentation and formatting
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Number of spaces for each indentation level
vim.opt.smartindent = true -- Smart autoindenting for new lines
vim.opt.smarttab = true -- Smart tab behavior
vim.opt.infercase = true -- Infer letter cases for keyword completion
vim.opt.formatoptions = "qjl1" -- Control automatic formatting (don't autoformat comments)

-- Completion settings
vim.opt.completeopt = "menu,menuone,noinsert,noselect" -- Customize completion behavior
vim.opt.completeopt:append("fuzzy") -- Enable fuzzy matching in completion

-- Visual mode settings
vim.opt.virtualedit = "block" -- Allow cursor beyond end of line in visual block mode

-- Fold settings
vim.opt.foldtext = "" -- Use default fold text

-- Spell checking
vim.opt.spelllang = "en,de" -- Define spelling dictionaries (English and German)
vim.opt.spelloptions = "camel" -- Treat camelCase words as separate words for spellcheck

-- Misc settings
vim.opt.shortmess:append("WcC") -- Reduce various messages
vim.opt.background = "dark" -- Set dark background

-- Filetype detection
vim.g.do_filetype_lua = true -- Use Lua for filetype detection

-- Leader keys
vim.g.mapleader = "," -- Set leader key to comma
vim.g.maplocalleader = "," -- Set local leader key to comma

-- Schedule clipboard setting after UI loads to improve startup time
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus" -- Use system clipboard
end)

-- ============================================================================
-- FILETYPE ASSOCIATIONS
-- ============================================================================

-- Custom filetype mappings
vim.filetype.add({
  extension = {
    zsh = "sh", -- Treat .zsh files as shell scripts
    sh = "sh", -- Force .sh files to use sh filetype even with zsh shebang
  },
  filename = {
    [".zshrc"] = "sh", -- Zsh config files as shell scripts
    [".zshenv"] = "sh", -- Zsh environment files as shell scripts
  },
})

-- ============================================================================
-- PACKAGE MANAGER SETUP (PCKR)
-- ============================================================================

-- Define paths for package manager
local pckr_lockfile = vim.env.VIM .. "/pckr/lockfile.lua"
local pckr_pack_dir = vim.env.VIM .. "/pckr"
local pckr_path = vim.env.VIM .. "/pckr/pckr.nvim"

-- Auto-install pckr if not present
if not (vim.uv or vim.loop).fs_stat(pckr_path) then
  local out
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none", -- Shallow clone for faster download
    "https://github.com/lewis6991/pckr.nvim",
    pckr_path,
  })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

-- Add pckr to runtime path
vim.opt.rtp:prepend(pckr_path)

-- Configure package manager
require("pckr").setup({
  pack_dir = pckr_pack_dir, -- Where to install packages
  max_jobs = 3, -- Limit concurrent downloads
  autoremove = true, -- Remove unused packages
  lockfile = {
    path = pckr_lockfile, -- Lockfile location
  },
})

-- ============================================================================
-- PLUGIN CONFIGURATIONS
-- ============================================================================

require("pckr").add({

  -- ============================================================================
  -- UTILITIES AND SMALL ENHANCEMENTS
  -- ============================================================================

  "lewis6991/fileline.nvim", -- Jump to specific line in file from command line
  "kevinhwang91/nvim-bqf", -- Better quickfix window

  -- ============================================================================
  -- COLORSCHEME
  -- ============================================================================

  {
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd.colorscheme("tokyonight-moon")
    end,
  },

  -- ============================================================================
  -- UI ENHANCEMENTS
  -- ============================================================================

  {
    "stevearc/dressing.nvim", -- Better UI for vim.ui.select and vim.ui.input
    config = function()
      require("dressing").setup({
        select = {
          enabled = false, -- Disable select (using mini.pick instead)
        },
      })
    end,
  },

  -- ============================================================================
  -- CODE FORMATTING
  -- ============================================================================

  {
    "stevearc/conform.nvim", -- Code formatter
    config = function()
      require("conform").setup({
        -- Define formatters for each filetype
        formatters_by_ft = {
          lua = { "stylua" },
          cpp = { "clang-format" },
          python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
          json = { "deno_fmt" },
          markdown = { "deno_fmt" },
          bzl = { "buildifier" }, -- Bazel files
          sh = { "shfmt" },
          yaml = { "yq" },
          ["*"] = { "typos" }, -- Spell checker for all files
        },
        -- Custom formatter configurations
        formatters = {
          ruff_format = {
            args = {
              "format",
              "--target-version",
              "py38", -- Target Python 3.8+
              "--force-exclude",
              "--stdin-filename",
              "$FILENAME",
              "-",
            },
          },
          stylua = {
            prepend_args = {
              "--column-width",
              "120",
              "--indent-type",
              "Spaces",
              "--quote-style",
              "AutoPreferDouble",
              "--line-endings",
              "Unix",
              "--indent-width",
              "2",
              "--call-parentheses",
              "Always",
            },
          },
        },
        -- Create Format command
        vim.api.nvim_create_user_command("Format", function(args)
          require("conform").format({ async = true, lsp_format = "fallback" })
        end, { range = true }),
      })
    end,
  },

  -- ============================================================================
  -- COMPLETION ENGINE
  -- ============================================================================

  {
    "saghen/blink.cmp", -- Modern completion engine
    config = function()
      require("blink.cmp").setup({
        signature = {
          enabled = true, -- Show function signatures
        },
        keymap = {
          preset = "super-tab", -- Use tab for completion navigation
        },
        fuzzy = {
          implementation = "lua", -- Use Lua implementation for better performance
        },
        completion = {
          menu = {
            draw = {
              -- Customize completion menu layout
              columns = {
                { "label", "label_description", gap = 1 },
                { "kind_icon", "kind" },
              },
            },
          },
        },
        sources = {
          default = { "lsp", "path", "buffer", "snippets" },
        },
        -- Command line completion
        cmdline = {
          keymap = {
            preset = "inherit",
            ["<CR>"] = { "accept_and_enter", "fallback" },
          },
          completion = {
            menu = { auto_show = true },
          },
        },
        -- Source-specific settings
        sources = {
          providers = {
            cmdline = {
              min_keyword_length = function(ctx)
                -- Only show cmdline completion after 3 chars when typing commands
                if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                  return 3
                end
                return 0
              end,
            },
          },
        },
      })

      -- Set up LSP capabilities for completion
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", {
        capabilities = capabilities,
      })
    end,
  },

  -- ============================================================================
  -- MINI.NVIM SUITE - COMPREHENSIVE PLUGIN COLLECTION
  -- ============================================================================

  {
    "echasnovski/mini.nvim", -- Swiss army knife of Neovim plugins
    config = function()
      -- Notification system
      require("mini.notify").setup({
        window = { config = { border = "double" } },
      })
      vim.notify = MiniNotify.make_notify()

      -- File picker and finder
      require("mini.pick").setup()
      vim.ui.select = MiniPick.ui_select

      -- Git integration
      require("mini.git").setup()

      -- Icons for various UI elements
      require("mini.icons").setup()
      MiniIcons.tweak_lsp_kind() -- Use mini.icons for LSP kind icons
      MiniIcons.mock_nvim_web_devicons() -- Compatibility with plugins expecting nvim-web-devicons

      -- Track and navigate file visits
      require("mini.visits").setup()

      -- Git diff visualization
      local diff = require("mini.diff")
      diff.setup({
        source = diff.gen_source.none(), -- Disable by default
      })

      -- Additional utilities
      require("mini.extra").setup()
      require("mini.misc").setup()

      -- Auto-detect project root
      MiniMisc.setup_auto_root({ "MODULE.bazel", "compile_commands.json", ".git" })

      -- Navigation and editing enhancements
      require("mini.bracketed").setup() -- ]b, [b for buffers, ]q, [q for quickfix, etc.
      require("mini.comment").setup() -- Smart commenting with gc
      require("mini.cursorword").setup() -- Highlight word under cursor
      require("mini.indentscope").setup() -- Visualize indent scope

      -- Start screen
      require("mini.starter").setup({
        header = [[
██╗  ██╗██╗   ██╗███████╗
╚██╗██╔╝╚██╗ ██╔╝╚══███╔╝
 ╚███╔╝  ╚████╔╝   ███╔╝
 ██╔██╗   ╚██╔╝   ███╔╝
██╔╝ ██╗   ██║   ███████╗
╚═╝  ╚═╝   ╚═╝   ╚══════╝]],
      })

      -- Status and tab lines
      require("mini.statusline").setup({
        set_vim_settings = false, -- Don't override our manual settings
        use_icons = true,
      })
      require("mini.tabline").setup()

      -- Whitespace management
      require("mini.trailspace").setup() -- Highlight and remove trailing whitespace

      -- Text manipulation
      require("mini.align").setup() -- Align text around characters

      -- Surround operations (brackets, quotes, etc.)
      -- Usage: saiw) - [S]urround [A]dd [I]inner [W]ord [)]Paren
      --        sd'   - [S]urround [D]elete [']quotes
      --        sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()

      -- File explorer
      require("mini.files").setup()

      -- Snippet engine
      -- local gen_loader = require("mini.snippets").gen_loader
      -- require("mini.snippets").setup({
      --   snippets = {
      --     gen_loader.from_file(vim.env.VIM .. "runtime/snippets/all.json"),
      --     gen_loader.from_lang(), -- Language-specific snippets
      --   },
      -- })

      -- Highlight patterns (like hex colors)
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          hex_color = hipatterns.gen_highlighter.hex_color(), -- Highlight #rrggbb with actual color
        },
      })

      -- Which-key style clues for key combinations
      local miniclue = require("mini.clue")
      miniclue.setup({
        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(), -- g key mappings
          miniclue.gen_clues.marks(), -- Mark navigation
          miniclue.gen_clues.registers(), -- Register access
          miniclue.gen_clues.windows({ submode_resize = true }), -- Window management
          miniclue.gen_clues.z(), -- z key mappings
        },
        triggers = {
          -- Leader key triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- Mini.bracketed navigation
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
          { mode = "x", keys = "[" },
          { mode = "x", keys = "]" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- g key mappings
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Mark navigation
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Register access
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- z key mappings
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },
        window = { config = { border = "double" } },
      })
    end,
  },

  -- ============================================================================
  -- TERMINAL INTEGRATION
  -- ============================================================================

  {
    "akinsho/toggleterm.nvim", -- Better terminal integration
    config = function()
      require("toggleterm").setup({
        direction = "horizontal",
        open_mapping = [[<leader>t]], -- Toggle terminal with <leader>t
        size = 30, -- Terminal height
      })
    end,
  },

  -- ============================================================================
  -- NAVIGATION
  -- ============================================================================

  {
    "smoka7/hop.nvim", -- Fast cursor movement
    config = function()
      require("hop").setup({
        keys = "etovxqpdygfblzhckisuran", -- Custom key sequence for hinting
        term_seq_bias = 0.5,
      })
    end,
  },

  -- ============================================================================
  -- SYNTAX HIGHLIGHTING AND PARSING
  -- ============================================================================

  {
    "nvim-treesitter/nvim-treesitter", -- Advanced syntax highlighting and parsing
    config = function()
      -- Use zig as preferred compiler for better Windows compatibility
      require("nvim-treesitter.install").compilers = { "zig", "gcc", "clang" }

      require("nvim-treesitter.configs").setup({
        -- Languages to install parsers for
        ensure_installed = {
          "vim",
          "regex",
          "html",
          "c",
          "cpp",
          "lua",
          "go",
          "python",
          "bash",
          "cmake",
          "markdown",
          "markdown_inline",
          "json",
          "yaml",
          "diff",
          "dockerfile",
          "starlark", -- Bazel files
          "typescript",
          "javascript",
          "comment",
        },
        highlight = { enable = true }, -- Enable syntax highlighting
        indent = { enable = true }, -- Enable treesitter-based indentation
      })
    end,
  },

  -- ============================================================================
  -- AI ASSISTANT INTEGRATION
  -- ============================================================================

  {
    "NickvanDyke/opencode.nvim", -- AI coding assistant via Claude CLI
    config = function()
      require("opencode").setup()

      -- Key mappings for opencode
      vim.keymap.set(
        "n",
        "<leader>oa",
        function() require('opencode').ask('@cursor: ') end,
        { noremap = true, silent = true, desc = "Ask OpenCode" }
      )
      vim.keymap.set(
        "v",
        "<leader>oa",
        function() require('opencode').ask('@selection: ') end,
        { noremap = true, silent = true, desc = "Ask OpenCode about selection" }
      )
      vim.keymap.set(
        { "n", "v" },
        "<leader>ot",
        function() require('opencode').toggle() end,
        { noremap = true, silent = true, desc = "Toggle OpenCode Terminal" }
      )
      vim.keymap.set(
        { "n", "v" },
        "<leader>op",
        function() require('opencode').select_prompt() end,
        { noremap = true, silent = true, desc = "OpenCode Prompt Menu" }
      )
    end,
    requires = {
      "folke/snacks.nvim", -- Required for input and terminal functionality
    },
  },

  -- ============================================================================
  -- DEBUGGING SUPPORT
  -- ============================================================================

  {
    "theHamsta/nvim-dap-virtual-text", -- Show variable values inline during debugging
    requires = {
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-dap-virtual-text").setup()

      -- Setup Python debugging if debugpy is available
      if vim.fn.executable("debugpy") == 1 then
        require("dap-python").setup("python3")
      end
    end,
  },

  -- ============================================================================
  -- DOCUMENTATION GENERATION
  -- ============================================================================

  {
    "danymat/neogen", -- Generate function documentation
    config = function()
      require("neogen").setup({
        languages = {
          python = { template = { annotation_convention = "numpydoc" } },
          c = { template = { annotation_convention = "doxygen" } },
          cpp = { template = { annotation_convention = "doxygen" } },
        },
      })
    end,
  },

  -- ============================================================================
  -- DEBUG ADAPTER PROTOCOL (DAP) UI
  -- ============================================================================

  {
    "rcarriga/nvim-dap-ui", -- UI for debugging
    requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Configure debug UI layout
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "repl", size = 0.25 }, -- Debug console
              { id = "watches", size = 0.25 }, -- Watch expressions
              { id = "breakpoints", size = 0.20 }, -- Breakpoint list
              { id = "stacks", size = 0.30 }, -- Call stack
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "scopes", size = 0.60 }, -- Variable scopes
              { id = "console", size = 0.40 }, -- Program output
            },
            size = 0.30,
            position = "bottom",
          },
        },
      })

      -- Auto-open/close debug UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Configure LLDB adapter for C/C++ debugging
      if vim.fn.executable("lldb-dap") == 1 then
        dap.adapters.lldb = {
          type = "executable",
          command = "lldb-dap",
          name = "lldb",
        }
      end

      -- Configure cpptools adapter as alternative
      if vim.fn.executable("OpenDebugAD7") == 1 then
        dap.adapters.cppdbg = {
          id = "cppdbg",
          type = "executable",
          command = "OpenDebugAD7",
          MIMode = "gdb",
          MIDebuggerPath = "gdb",
        }
      end

      -- Debug configuration for C/C++
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "lldb",
          request = "launch",
          program = function()
            -- Prompt for executable path
            return coroutine.create(function(dap_run_co)
              vim.ui.input({
                prompt = "Path to executable: ",
                default = vim.fn.getcwd() .. "/",
                completion = "file",
              }, function(input)
                coroutine.resume(dap_run_co, input)
              end)
            end)
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = true,
          runInTerminal = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp -- Use same config for C

      -- Debug keymaps
      vim.keymap.set("n", "<F5>", function()
        dap.continue()
      end, { desc = "Debug: Start/Continue" })

      vim.keymap.set("n", "<F9>", function()
        dap.toggle_breakpoint()
      end, { desc = "Debug: Toggle Breakpoint" })

      vim.keymap.set("n", "<F10>", function()
        dap.step_over()
      end, { desc = "Debug: Step Over" })

      vim.keymap.set("n", "<F11>", function()
        dap.step_into()
      end, { desc = "Debug: Step Into" })

      vim.keymap.set("n", "<F12>", function()
        dap.step_out()
      end, { desc = "Debug: Step Out" })

      -- Debug commands
      vim.api.nvim_create_user_command("DebugListBreakpoints", function()
        dap.list_breakpoints()
      end, { desc = "Debug: List Breakpoints" })

      vim.api.nvim_create_user_command("DebugClearBreakpoints", function()
        dap.clear_breakpoints()
      end, { desc = "Debug: Clear Breakpoints" })

      vim.api.nvim_create_user_command("DebugSetBreakpoint", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Set Conditional Breakpoint" })

      vim.api.nvim_create_user_command("DebugSetLogpoint", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end, { desc = "Debug: Set Log Point Message" })

      vim.api.nvim_create_user_command("DebugConsole", function()
        dap.repl.toggle()
      end, { desc = "Debug: Toggle Debug Console" })
    end,
  },
})

-- ============================================================================
-- CUSTOM KEYMAPS
-- ============================================================================

-- Movement and navigation
vim.keymap.set("n", "ww", function()
  require("hop").hint_words()
end, { desc = "Hop to words" })

-- Disable Ctrl-Z (suspend) in normal mode
vim.keymap.set("n", "<C-Z>", "<NOP>")

-- Yank till end of line (to match D and C behavior)
vim.keymap.set("n", "Y", "y$", { desc = "Yank till the end of the line" })

-- File operations
vim.keymap.set("n", "<leader>d", function()
  if not MiniFiles.close() then
    MiniFiles.open()
  end
end, { desc = "Toggle file tree" })

-- Terminal escape
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { desc = "Escape from terminal" })

-- File picker keymaps
vim.keymap.set("n", "<leader>ff", [[<Cmd>Pick files<CR>]], { desc = "Pick find files" })
vim.keymap.set("n", "<leader>fg", [[<Cmd>Pick grep_live<CR>]], { desc = "Pick grep live" })
vim.keymap.set("n", "<leader>fG", [[<Cmd>Pick grep pattern='<cword>'<CR>]], { desc = "Pick grep string under cursor" })

-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("xyz-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Set text width for specific file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "cpp", "c" },
  callback = function(ev)
    vim.api.nvim_set_option_value("tw", 79, { scope = "local" }) -- 79 character line limit
  end,
})

-- Set comment string for C++ files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp" },
  callback = function(ev)
    vim.api.nvim_set_option_value("commentstring", "// %s", { scope = "local" })
  end,
})

-- ============================================================================
-- CUSTOM COMMANDS
-- ============================================================================

-- Trim trailing whitespace command
vim.api.nvim_create_user_command("Trim", function()
  MiniTrailspace.trim()
end, { desc = "Trim trailing whitespace" })

-- ============================================================================
-- LSP (LANGUAGE SERVER PROTOCOL) CONFIGURATION
-- ============================================================================

-- Define diagnostic severity levels for notifications
local severity = {
  "error",
  "warn",
  "info",
  "hint",
}

-- Custom handler for LSP window/showMessage to use vim.notify
vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
  vim.notify(method.message, severity[params.type])
end

-- Configure diagnostic display
vim.diagnostic.config({
  severity_sort = true, -- Sort diagnostics by severity
  float = {
    border = "rounded",
    source = "if_many", -- Show source if multiple sources
  },
  underline = {
    severity = vim.diagnostic.severity.ERROR, -- Only underline errors
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
  virtual_text = false, -- Disable inline diagnostic text by default
})

-- Diagnostic navigation keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic location" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic location" })

-- Show line diagnostics temporarily
vim.keymap.set("n", "<leader>l", function()
  vim.diagnostic.config({ virtual_lines = { current_line = true } })

  -- Hide diagnostics when cursor moves
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("xyz-line-diagnostics", { clear = true }),
    callback = function()
      vim.diagnostic.config({ virtual_lines = false })
      return true -- Remove autocmd after first trigger
    end,
  })
end, { desc = "Show line diagnostics" })

-- ============================================================================
-- LSP ATTACH AUTOCOMMAND - SETS UP KEYMAPS AND FEATURES PER BUFFER
-- ============================================================================

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Enable inlay hints if supported
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.keymap.set("n", "<leader>h", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }))
      end, { silent = true, buffer = args.buf, desc = "Toggle Inlay [H]ints" })
    end

    -- Set up document highlighting if supported
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup("xys-lsp-highlight", { clear = false })

      -- Highlight references under cursor
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = args.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      -- Clear highlights when cursor moves
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = args.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      -- Clean up when LSP detaches
      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("xys-lsp-detach", { clear = true }),
        callback = function(event)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "xys-lsp-highlight", buffer = event.buf })
        end,
      })
    end

    -- LSP navigation and action keymaps
    vim.keymap.set("n", "gD", function()
      vim.lsp.buf.declaration()
    end, { silent = true, buffer = args.buf, desc = "[g]oto [D]eclaration" })

    vim.keymap.set("n", "gd", function()
      vim.lsp.buf.definition()
    end, { silent = true, buffer = args.buf, desc = "[g]oto [d]efinition" })

    vim.keymap.set("n", "gt", function()
      vim.lsp.buf.type_definition()
    end, { silent = true, buffer = args.buf, desc = "[g]oto [t]ype Definition" })

    vim.keymap.set("n", "ca", function()
      vim.lsp.buf.code_action()
    end, { silent = true, buffer = args.buf, desc = "[c]ode [a]ction" })

    -- Rename command
    vim.api.nvim_buf_create_user_command(args.buf, "Rename", function()
      vim.lsp.buf.rename()
    end, { desc = "Rename symbol" })
  end,
})

-- ============================================================================
-- CLANGD (C/C++) LANGUAGE SERVER CONFIGURATION
-- ============================================================================

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--clang-tidy", -- Enable clang-tidy checks
    "--background-index", -- Index in background for better performance
    "--offset-encoding=utf-8", -- Use UTF-8 encoding
    "--enable-config", -- Enable .clangd config files
    "--header-insertion=iwyu", -- Use include-what-you-use for header insertion
    "--function-arg-placeholders", -- Show parameter placeholders in completion
    "--header-insertion-decorators", -- Show decorators for header insertions
    "--completion-style=bundled", -- Bundle completion items
  },
  root_markers = { ".clangd", "compile_commands.json", "MODULE.bazel" },
  filetypes = { "c", "cpp" },
})

-- Enable clangd if available
if vim.fn.executable("clangd") == 1 then
  vim.lsp.enable("clangd")
end

-- ============================================================================
-- RUFF (PYTHON LINTER/FORMATTER) LANGUAGE SERVER CONFIGURATION
-- ============================================================================

vim.lsp.config("ruff", {
  cmd = {
    "ruff",
    "server",
  },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
  },
  filetypes = { "python" },
})

-- Enable ruff if available
if vim.fn.executable("ruff") == 1 then
  vim.lsp.enable("ruff")
end

-- ============================================================================
-- PYRIGHT/BASEDPYRIGHT (PYTHON TYPE CHECKER) LANGUAGE SERVER CONFIGURATION
-- ============================================================================

-- Prefer basedpyright over pyright if available
local pyright = vim.fn.executable("basedpyright") == 1 and "basedpyright" or "pyright"

vim.lsp.config("pyright", {
  cmd = {
    "basedpyright-langserver",
    "--stdio",
  },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
  },
  filetypes = { "python" },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "strict", -- Enable strict type checking
      },
    },
  },
})

-- Enable basedpyright if available
if vim.fn.executable("basedpyright") == 1 then
  vim.lsp.enable("pyright")
end

-- ============================================================================
-- DEBUG ADAPTER PROTOCOL (DAP) VISUAL CUSTOMIZATION
-- ============================================================================

-- Define custom highlight groups for debugging
vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#993939", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379", bg = "#31353f" })

-- Define custom signs for debugging states
vim.fn.sign_define(
  "DapBreakpoint",
  { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
  "DapBreakpointCondition",
  { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
  "DapBreakpointRejected",
  { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

-- ============================================================================
-- END OF CONFIGURATION
-- ============================================================================
