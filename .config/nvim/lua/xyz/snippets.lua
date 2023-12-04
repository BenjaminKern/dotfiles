local M = {}
local _local = {}

M.setup = function(config)
  _G.XyzSnippets = M

  -- Setup config
  config = _local.setup_config(config)

  -- Apply config
  _local.apply_config(config)
end

M.config = {
  snippets = {
    all = {},
    cpp = {
      ['inc'] = '#include <${1:vector}>',
    },
  },
  mappings = {
    jump_left = '<C-h>',
    jump_right = '<C-l>',
  },

  options = {
    snippets_path = vim.fs.joinpath(vim.fn.stdpath('config'), 'snippets'),
  },
}

_local.default_config = vim.deepcopy(M.config)

_local.setup_config = function(config)
  -- General idea: if some table elements are not present in user-supplied
  -- `config`, take them from default config
  vim.validate({ config = { config, 'table', true } })
  config = vim.tbl_deep_extend('force', vim.deepcopy(_local.default_config), config or {})

  -- Validate per nesting level to produce correct error message
  vim.validate({
    snippets = { config.snippets, 'table' },
    mappings = { config.mappings, 'table' },
    options = { config.options, 'table' },
  })

  vim.validate({
    ['mappings.jump_left'] = { config.mappings.jump_left, 'string' },
    ['mappings.jump_right'] = { config.mappings.jump_right, 'string' },
    ['snippets.all'] = { config.snippets.all, 'table' },
    ['options.snippets_path'] = { config.options.snippets_path, 'string' },
  })

  return config
end

-- Some variables defined in https://code.visualstudio.com/docs/editor/userdefinedsnippets#_variables
_local.var_replacements = {
  {
    ['var'] = '$LINE_COMMENT',
    ['replacement'] = function()
      local cs = vim.bo.commentstring
      local left, _ = cs:match('^%s*(.*)%%s(.-)%s*$')
      return left
    end,
  },
  {
    ['var'] = '$TM_FILENAME_BASE',
    ['replacement'] = function()
      return vim.fn.expand('%:t:s?\\.[^\\.]\\+$??')
    end,
  },
  {
    ['var'] = '$TM_FILENAME',
    ['replacement'] = function()
      return vim.fn.expand('%:t')
    end,
  },
  {
    ['var'] = '$TM_DIRECTORY',
    ['replacement'] = function()
      return vim.fn.expand('%:p:h')
    end,
  },
  {
    ['var'] = '$TM_FILEPATH',
    ['replacement'] = function()
      return vim.fn.expand('%:p')
    end,
  },
  {
    ['var'] = '$CLIPBOARD',
    ['replacement'] = function()
      return vim.fn.getreg('"', 1, true)
    end,
  },
  {
    ['var'] = '$CURRENT_YEAR_SHORT',
    ['replacement'] = function()
      return os.date('%y')
    end,
  },
  {
    ['var'] = '$CURRENT_YEAR',
    ['replacement'] = function()
      return os.date('%Y')
    end,
  },
  {
    ['var'] = '$CURRENT_MONTH_NAME_SHORT',
    ['replacement'] = function()
      return os.date('%b')
    end,
  },
  {
    ['var'] = '$CURRENT_MONTH_NAME',
    ['replacement'] = function()
      return os.date('%B')
    end,
  },
  {
    ['var'] = '$CURRENT_MONTH',
    ['replacement'] = function()
      return os.date('%m')
    end,
  },
  {
    ['var'] = '$CURRENT_DAY_NAME_SHORT',
    ['replacement'] = function()
      return os.date('%a')
    end,
  },
  {
    ['var'] = '$CURRENT_DAY_NAME',
    ['replacement'] = function()
      return os.date('%A')
    end,
  },
  {
    ['var'] = '$CURRENT_DATE',
    ['replacement'] = function()
      return os.date('%d')
    end,
  },
  {
    ['var'] = '$CURRENT_HOUR',
    ['replacement'] = function()
      return os.date('%H')
    end,
  },
  {
    ['var'] = '$CURRENT_MINUTE',
    ['replacement'] = function()
      return os.date('%M')
    end,
  },
  {
    ['var'] = '$CURRENT_SECONDS_UNIX',
    ['replacement'] = function()
      return tostring(os.time())
    end,
  },
  {
    ['var'] = '$CURRENT_SECOND',
    ['replacement'] = function()
      return os.date('%S')
    end,
  },
  {
    ['var'] = '$RANDOM_HEX',
    ['replacement'] = function()
      return string.format('%06x', math.random(16777216))
    end,
  },
  {
    ['var'] = '$RANDOM',
    ['replacement'] = function()
      return string.format('%06d', math.random(999999))
    end,
  },
}

_local.preprocess_snippet = function(snippet)
  local preprocess_snippet = snippet
  for _, var_replacement in ipairs(_local.var_replacements) do
    local var = var_replacement['var']
    if preprocess_snippet and string.find(preprocess_snippet, var) then
      local replacement = var_replacement['replacement']
      preprocess_snippet = string.gsub(preprocess_snippet, var, replacement())
    end
  end
  return preprocess_snippet
end

_local.apply_config = function(config)
  M.config = config

  local file_content = vim.fn.readblob(vim.fs.joinpath(M.config.options.snippets_path, 'all.json'))
  local tmp = vim.json.decode(file_content)
  for key, value in pairs(tmp) do
    local body = value['body']
    local prefix = value['prefix']
    if type(body) == 'table' then
      M.config.snippets.all[prefix] = table.concat(body, '\n') .. '\n'
    else
      M.config.snippets.all[prefix] = body
    end
  end
  -- vim.print(M.config.snippets.all)

  math.randomseed(os.time())

  -- Make mappings
  _local.map('i', config.mappings.jump_left, function()
    return M.jump_left()
  end, { expr = true, desc = 'Snippet jump left' })
  _local.map('i', config.mappings.jump_right, function()
    return M.jump_right()
  end, { expr = true, desc = 'Snippet jump right' })
end

_local.get_config = function(config)
  return vim.tbl_deep_extend('force', M.config, vim.b.xyzsnippets_config or {}, config or {})
end

_local.close_pumvisible = function()
  if vim.fn.pumvisible() == 0 then
    return
  end
  vim.fn.feedkeys('\25', 'n')
end

_local.get_snippet_at_cursor = function()
  local line = vim.api.nvim_get_current_line()
  local prefix = vim.fn.matchstr(line, '\\w\\+\\%.c')
  local res = nil

  local snippets = _local.get_config().snippets['all']
  if not snippets then
    snippets = {}
  end

  if vim.bo.filetype then
    local ft_snippets = _local.get_config().snippets[vim.bo.filetype]
    if ft_snippets then
      for key, value in pairs(ft_snippets) do
        snippets[key] = value
      end
    end
  end

  local snippet = snippets[prefix]

  if snippet then
    res = _local.preprocess_snippet(snippet)
  end

  if vim.is_callable(res) then
    return res(), prefix
  end

  return res, prefix
end

_local.jump_or_expand = function()
  if vim.snippet.jumpable(1) then
    _local.close_pumvisible()
    vim.schedule_wrap(vim.snippet.jump(1))
    return
  end

  local snippet, prefix = _local.get_snippet_at_cursor()
  if type(snippet) ~= 'string' then
    return
  end

  _local.close_pumvisible()
  vim.schedule(function()
    local lnum, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, lnum - 1, col - #prefix, lnum - 1, col, {})
    vim.snippet.expand(snippet)
  end)
end

-- Make snippet keymaps
M.jump_right = function()
  _local.jump_or_expand()
end

M.jump_left = function()
  if vim.snippet.jumpable(-1) then
    vim.snippet.jump(-1)
  end
end

_local.map = function(mode, lhs, rhs, opts)
  if lhs == '' then
    return
  end
  opts = vim.tbl_deep_extend('force', { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
