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
          default = { "lsp", "path", "buffer", "snippets", "codecompanion" },
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
  -- MARKDOWN RENDERING
  -- ============================================================================

  {
    "MeanderingProgrammer/render-markdown.nvim", -- Beautiful markdown rendering
    config = function()
      require("render-markdown").setup({
        file_types = { "markdown", "codecompanion" }, -- Also render in AI chat
      })
    end,
    requires = { "echasnovski/mini.nvim" },
  },

  -- ============================================================================
  -- AI ASSISTANT INTEGRATION
  -- ============================================================================
  {
    "olimorris/codecompanion.nvim", -- AI coding assistant
    config = function()
      require("codecompanion").setup({
        adapters = {
          http = {
            llama_cpp = function()
              return require("codecompanion.adapters").extend("openai_compatible", {
                env = {
                  url = "http://127.0.0.1:8080",
                  chat_url = "/v1/chat/completions",
                  models_endpoint = "/v1/models",
                  api_key = "1234",
                },
              })
            end,
            copilot = function()
              return require("codecompanion.adapters").extend("copilot", {
                schema = {
                  model = {
                    default = "gpt-4.1", -- claude-sonnet-4, claude-sonnet-4.5, gpt-5
                  },
                },
              })
            end,
          },
        },
        strategies = {
          chat = {
            adapter = "llama_cpp",
          },
          inline = {
            adapter = "llama_cpp",
          },
          cmd = {
            adapter = "llama_cpp",
          },
        },
        -- Enhanced prompt library
        prompt_library = {
          -- ===== CODE QUALITY =====
          ["Code Review"] = {
            strategy = "chat",
            description = "Get code review feedback",
            opts = {
              index = 1,
              short_name = "cr",
            },
            prompts = {
              {
                role = "user",
                content = function(context)
                  local lang_specific = {
                    cpp = "\n- Check for memory safety (RAII, smart pointers)\n- Verify const correctness\n- Review exception safety guarantees\n- Check for proper move semantics",
                    python = "\n- Check type hints completeness\n- Verify PEP 8 compliance\n- Review error handling patterns\n- Check for proper resource cleanup",
                    bzl = "\n- Verify build rule correctness\n- Check dependency hygiene\n- Review visibility settings",
                    dockerfile = "\n- Check multi-stage build optimization\n- Verify layer caching efficiency\n- Review security best practices",
                  }
                  local extra = lang_specific[context.filetype] or ""
                  return string.format(
                    [[Review this %s code for:
- Best practices and idioms
- Potential bugs and edge cases
- Performance implications
- Security concerns%s

{buffer}]],
                    context.filetype,
                    extra
                  )
                end,
              },
            },
          },
          ["Explain Code"] = {
            strategy = "chat",
            description = "Explain selected code",
            opts = {
              index = 2,
              short_name = "ec",
            },
            prompts = {
              {
                role = "user",
                content = [[Explain what this code does, including:
- High-level purpose
- Key algorithms or patterns used
- Important edge cases or assumptions
- Dependencies and their roles

{buffer}]],
              },
            },
          },
          ["Refactor"] = {
            strategy = "inline",
            description = "Suggest refactoring improvements",
            opts = {
              index = 3,
              short_name = "rf",
            },
            prompts = {
              {
                role = "user",
                content = function(context)
                  local refactor_focus = {
                    cpp = "modern C++17/20 idioms, RAII, const correctness, and move semantics",
                    python = "Pythonic patterns, type hints, and comprehensions",
                  }
                  local focus = refactor_focus[context.filetype] or "clean code principles"
                  return string.format(
                    [[Refactor this code focusing on %s. Maintain functionality while improving:
- Readability and maintainability
- Performance where applicable
- Error handling
- Code organization

{selection}]],
                    focus
                  )
                end,
              },
            },
          },
          -- ===== DOCUMENTATION =====
          ["Add Docstring"] = {
            strategy = "inline",
            description = "Generate function/class documentation",
            opts = {
              index = 4,
              short_name = "doc",
            },
            prompts = {
              {
                role = "user",
                content = function(context)
                  if context.filetype == "cpp" then
                    return [[Add Doxygen-style documentation for this function/class:
- Brief description
- Detailed description if complex
- @param for each parameter
- @return for return value
- @throw for exceptions
- @note for important usage notes

{selection}]]
                  elseif context.filetype == "python" then
                    return [[Add Google-style docstring for this function/class:
- One-line summary
- Detailed description if needed
- Args: with types
- Returns: with type
- Raises: for exceptions
- Example: if helpful

{selection}]]
                  else
                    return "Add clear documentation for:\n{selection}"
                  end
                end,
              },
            },
          },
          -- ===== TESTING =====
          ["Generate Tests"] = {
            strategy = "chat",
            description = "Generate unit tests",
            opts = {
              index = 5,
              short_name = "test",
            },
            prompts = {
              {
                role = "user",
                content = function(context)
                  if context.filetype == "cpp" then
                    return [[Generate comprehensive unit tests using Google Test for:
{buffer}

Include:
- Test fixtures if needed
- Positive test cases
- Edge cases and boundary conditions
- Error cases with EXPECT_THROW
- Test names following TEST(TestSuiteName, TestName) convention]]
                  elseif context.filetype == "python" then
                    return [[Generate comprehensive pytest tests for:
{buffer}

Include:
- Fixtures if needed
- Positive test cases
- Edge cases and boundary conditions
- Parametrized tests where applicable
- Mock external dependencies
- Clear test function names]]
                  else
                    return "Generate unit tests for:\n{buffer}"
                  end
                end,
              },
            },
          },
          ["Fix Test"] = {
            strategy = "chat",
            description = "Debug and fix failing test",
            opts = {
              index = 6,
              short_name = "fixtest",
            },
            prompts = {
              {
                role = "user",
                content = [[This test is failing. Analyze why and suggest fixes:

Test code:
{buffer}

Please:
1. Identify the root cause
2. Explain what's wrong
3. Provide the corrected test
4. Suggest additional test cases if the original test was incomplete]],
              },
            },
          },
          -- ===== BUILD & DEVOPS =====
          ["Bazel Rule"] = {
            strategy = "chat",
            description = "Create or fix Bazel build rules",
            opts = {
              index = 7,
              short_name = "bazel",
            },
            prompts = {
              {
                role = "user",
                content = [[I need help with Bazel build configuration. Consider:
- Proper dependency management
- Visibility settings
- Target naming conventions
- Toolchain configuration

{buffer}

What improvements or fixes do you suggest?]],
              },
            },
          },
          ["Dockerfile Optimize"] = {
            strategy = "chat",
            description = "Optimize Dockerfile",
            opts = {
              index = 8,
              short_name = "docker",
            },
            prompts = {
              {
                role = "user",
                content = [[Optimize this Dockerfile for:
- Smaller image size (multi-stage builds)
- Better layer caching
- Security best practices
- Build speed

Current Dockerfile:
{buffer}]],
              },
            },
          },
          ["GitHub Actions Workflow"] = {
            strategy = "chat",
            description = "Create or improve GHA workflow",
            opts = {
              index = 9,
              short_name = "gha",
            },
            prompts = {
              {
                role = "user",
                content = [[Help me create/improve a GitHub Actions workflow for:
{buffer}

Consider:
- Efficient caching strategies
- Parallel job execution
- Proper secret handling
- Failure notifications
- Matrix builds if applicable]],
              },
            },
          },
          -- ===== DEBUGGING =====
          ["Debug Issue"] = {
            strategy = "chat",
            description = "Analyze and debug code issue",
            opts = {
              index = 10,
              short_name = "debug",
            },
            prompts = {
              {
                role = "user",
                content = [[I'm encountering an issue with this code. Help me debug it:

Code:
{buffer}

Please:
1. Identify potential bugs
2. Explain the likely root cause
3. Suggest debugging steps
4. Provide a fix with explanation]],
              },
            },
          },
          ["Performance Analysis"] = {
            strategy = "chat",
            description = "Analyze code for performance issues",
            opts = {
              index = 11,
              short_name = "perf",
            },
            prompts = {
              {
                role = "user",
                content = function(context)
                  if context.filetype == "cpp" then
                    return [[Analyze this C++ code for performance:
{buffer}

Focus on:
- Memory allocation patterns
- Cache efficiency
- Unnecessary copies
- Algorithm complexity
- Compiler optimization opportunities
- SIMD/vectorization potential]]
                  elseif context.filetype == "python" then
                    return [[Analyze this Python code for performance:
{buffer}

Focus on:
- Hot loops and bottlenecks
- Data structure choices
- List comprehensions vs loops
- Generator opportunities
- Cython/numba candidates]]
                  else
                    return "Analyze for performance issues:\n{buffer}"
                  end
                end,
              },
            },
          },
          -- ===== CODE GENERATION =====
          ["Implement Interface"] = {
            strategy = "inline",
            description = "Implement interface/abstract methods",
            opts = {
              index = 12,
              short_name = "impl",
            },
            prompts = {
              {
                role = "user",
                content = [[Implement all methods for this interface/abstract class:
{selection}

Provide:
- Complete implementations
- Proper error handling
- Documentation for each method
- Example usage if helpful]],
              },
            },
          },
          ["Boilerplate"] = {
            strategy = "inline",
            description = "Generate common boilerplate code",
            opts = {
              index = 13,
              short_name = "bp",
            },
            prompts = {
              {
                role = "user",
                content = function(context)
                  if context.filetype == "cpp" then
                    return [[Generate C++ boilerplate for: {selection}

Include:
- #pragma once
- Namespace
- Rule of five if applicable
- Proper includes]]
                  elseif context.filetype == "python" then
                    return [[Generate Python boilerplate for: {selection}

Include:
- Type hints
- Docstrings
- __init__.py if package
- Common dunder methods if class]]
                  else
                    return "Generate appropriate boilerplate for: {selection}"
                  end
                end,
              },
            },
          },
          -- ===== CONVERSION & MIGRATION =====
          ["Python to C++"] = {
            strategy = "chat",
            description = "Convert Python code to C++",
            opts = {
              index = 14,
              short_name = "py2cpp",
            },
            prompts = {
              {
                role = "user",
                content = [[Convert this Python code to modern C++17/20:
{buffer}

Requirements:
- Use STL containers and algorithms
- Apply RAII principles
- Include proper error handling
- Add type safety
- Maintain equivalent functionality
- Add brief migration notes]],
              },
            },
          },
          ["Add Type Hints"] = {
            strategy = "inline",
            description = "Add Python type hints",
            opts = {
              index = 15,
              short_name = "hints",
            },
            prompts = {
              {
                role = "user",
                content = [[Add complete type hints to this Python code:
{selection}

Include:
- Function parameter types
- Return types
- Variable annotations where helpful
- Generic types (List, Dict, Optional, etc.)
- Use typing module appropriately]],
              },
            },
          },

          ["PR Description"] = {
            strategy = "chat",
            description = "Generate pull request description",
            opts = {
              index = 16,
              short_name = "pr",
            },
            prompts = {
              {
                role = "user",
                content = function()
                  -- Get current branch name
                  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")

                  -- Try origin/main first, fall back to origin/master
                  local base_branch = "origin/main"
                  local test_base = vim.fn.system(string.format("git rev-parse --verify %s 2>/dev/null", base_branch))
                  if vim.v.shell_error ~= 0 then
                    base_branch = "origin/master"
                    test_base = vim.fn.system(string.format("git rev-parse --verify %s 2>/dev/null", base_branch))
                    if vim.v.shell_error ~= 0 then
                      return "Error: Could not find origin/main or origin/master. Please fetch from origin first."
                    end
                  end

                  -- Get commits on this branch not in base
                  local commits = vim.fn.system(string.format("git log %s..HEAD --oneline", base_branch))
                  if commits == "" then
                    return string.format(
                      "No commits found between %s and current branch. Branch may be up to date.",
                      base_branch
                    )
                  end

                  -- Get diff stats
                  local diff_stat = vim.fn.system(string.format("git diff %s...HEAD --stat", base_branch))

                  -- Get full diff
                  local diff = vim.fn.system(string.format("git diff %s...HEAD", base_branch))

                  -- Get list of modified files
                  local files_changed = vim.fn.system(string.format("git diff %s...HEAD --name-only", base_branch))

                  return string.format(
                    [[Generate a comprehensive pull request description for this branch:

Branch: %s
Base: %s
Files changed:
%s

Commit history:
%s

Diff summary:
%s

Full changes:
```diff
%s
```

Include:
## Summary
Brief overview of what changed and why (2-3 sentences)

## Changes
- Bullet points of key changes organized by area/component
- What was added/modified/removed
- Highlight important architectural or design decisions

## Testing
- How these changes were tested
- Test coverage added
- Manual testing performed

## Breaking Changes
- List any breaking changes (or "None" if not applicable)

## Related Issues
- Reference any related issue numbers (e.g., Fixes #123)

## Deployment Notes
- Any special deployment considerations
- Migration steps if needed
- Configuration changes required

## Checklist
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Breaking changes documented
- [ ] Reviewed my own code]],
                    branch,
                    base_branch,
                    files_changed,
                    commits,
                    diff_stat,
                    diff
                  )
                end,
              },
            },
          },
        },
        -- Enhanced workflows
        workflows = {
          ["Code Generation"] = {
            strategy = "workflow",
            description = "Generate and refine code with feedback",
            opts = {
              index = 1,
              short_name = "cg",
            },
            prompts = {
              {
                {
                  role = "system",
                  content = function(context)
                    local expertise = {
                      cpp = "expert C++ engineer specializing in modern C++17, performance optimization, and systems programming",
                      python = "expert Python engineer specializing in type safety, async programming, and Pythonic code",
                      bzl = "expert in Bazel build systems and dependency management",
                      dockerfile = "expert in Docker containerization and optimization",
                      yaml = "expert in CI/CD pipelines and GitHub Actions",
                    }
                    local role = expertise[context.filetype]
                      or string.format("expert %s software engineer", context.filetype)
                    return "You are an " .. role .. ". Provide accurate, production-ready solutions."
                  end,
                  opts = {
                    visible = false,
                  },
                },
                {
                  role = "user",
                  content = "I want you to generate code for: ",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Review this for correctness, efficiency, and best practices.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Revise based on feedback. Provide only the improved code.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
            },
          },
          ["Comprehensive Review"] = {
            strategy = "workflow",
            description = "Multi-stage code review process",
            opts = {
              index = 2,
              short_name = "review",
            },
            prompts = {
              {
                {
                  role = "system",
                  content = "You are a senior software engineer conducting a thorough code review.",
                  opts = {
                    visible = false,
                  },
                },
                {
                  role = "user",
                  content = [[Review this code for correctness and logic bugs:
{buffer}]],
                  opts = {
                    auto_submit = true,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Now review for performance and efficiency concerns.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Finally, check for security issues and best practices.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Summarize the top 3 most important issues to address.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
            },
          },
          ["Test-Driven Development"] = {
            strategy = "workflow",
            description = "Generate tests then implementation",
            opts = {
              index = 3,
              short_name = "tdd",
            },
            prompts = {
              {
                {
                  role = "system",
                  content = function(context)
                    return string.format(
                      "You are an expert in test-driven development for %s. Follow TDD principles strictly.",
                      context.filetype
                    )
                  end,
                  opts = {
                    visible = false,
                  },
                },
                {
                  role = "user",
                  content = "I need to implement: ",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "First, write comprehensive tests for this functionality. Include edge cases.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Now provide the minimal implementation that passes these tests.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Suggest any additional tests we should add for better coverage.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
            },
          },
          ["Debug Session"] = {
            strategy = "workflow",
            description = "Systematic debugging workflow",
            opts = {
              index = 4,
              short_name = "debugflow",
            },
            prompts = {
              {
                {
                  role = "system",
                  content = "You are a debugging expert. Use systematic analysis to identify root causes.",
                  opts = {
                    visible = false,
                  },
                },
                {
                  role = "user",
                  content = [[I'm seeing this issue:
{buffer}

Help me understand what's happening.]],
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "What debugging steps should I take to narrow down the cause?",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Based on the symptoms, what are the most likely root causes?",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Provide a fix with explanation of why this solves the issue.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
            },
          },
          ["API Design"] = {
            strategy = "workflow",
            description = "Design and document an API",
            opts = {
              index = 5,
              short_name = "api",
            },
            prompts = {
              {
                {
                  role = "system",
                  content = "You are an API design expert focusing on usability, maintainability, and performance.",
                  opts = {
                    visible = false,
                  },
                },
                {
                  role = "user",
                  content = "I need to design an API for: ",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Design the interface/class structure with clear contracts.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Add comprehensive documentation with usage examples.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Suggest test cases that verify the API contract.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
            },
          },
          ["Pull Request Review"] = {
            strategy = "workflow",
            description = "Complete PR creation workflow",
            opts = {
              index = 6,
              short_name = "prflow",
            },
            prompts = {
              {
                {
                  role = "system",
                  content = "You are a senior engineer helping create a comprehensive pull request.",
                  opts = {
                    visible = false,
                  },
                },
                {
                  role = "user",
                  content = function()
                    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")

                    -- Determine base branch
                    local base_branch = "origin/main"
                    local test_base = vim.fn.system(string.format("git rev-parse --verify %s 2>/dev/null", base_branch))
                    if vim.v.shell_error ~= 0 then
                      base_branch = "origin/master"
                    end

                    local commits = vim.fn.system(string.format("git log %s..HEAD --oneline", base_branch))
                    local diff_stat = vim.fn.system(string.format("git diff %s...HEAD --stat", base_branch))
                    local diff = vim.fn.system(string.format("git diff %s...HEAD", base_branch))

                    return string.format(
                      [[Analyze these changes and create a detailed PR description:

Branch: %s → %s

Commits:
%s

File changes:
%s

Full diff:
```diff
%s
```]],
                      branch,
                      base_branch,
                      commits,
                      diff_stat,
                      diff
                    )
                  end,
                  opts = {
                    auto_submit = true,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Now suggest potential reviewer concerns and how to address them.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "Generate a conventional commit message that summarizes all changes.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
              {
                {
                  role = "user",
                  content = "List any documentation or tests that should be added before merging.",
                  opts = {
                    auto_submit = false,
                  },
                },
              },
            },
          },
        },
      })

      -- Key mappings for AI assistant
      vim.keymap.set(
        { "n", "v" },
        "<leader>a",
        "<cmd>CodeCompanionChat Toggle<cr>",
        { noremap = true, silent = true, desc = "Toggle AI Chat" }
      )

    end,
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MeanderingProgrammer/render-markdown.nvim",
    },
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
vim.keymap.set("n", "<leader>q", function()
  local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
  if qf_winid ~= 0 then
    vim.cmd("cclose")
  else
    vim.diagnostic.setqflist()
  end
end, { desc = "Toggle diagnostic [Q]uickfix list" })
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
    end, { silent = true, buffer = args.buf, desc = "[g]oto [d]definition" })

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
