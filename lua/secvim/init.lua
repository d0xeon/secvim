local M = {}

M.version = '0.1.0'
M.name = 'Secvim'

--- Open snacks picker listing files in a directory
local function browse_dir(title, dir)
  local files = vim.fn.globpath(dir, '**/*.lua', false, true)
  if #files == 0 then
    Snacks.notify.info 'No files found'
    return
  end

  local items = {}
  for _, f in ipairs(files) do
    local rel = f:sub(#dir + 2)
    table.insert(items, { text = rel, file = f })
  end
  table.sort(items, function(a, b)
    return a.text < b.text
  end)

  Snacks.picker {
    title = title,
    items = items,
    format = 'file',
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.cmd('edit ' .. vim.fn.fnameescape(item.file))
      end
    end,
  }
end

function M.info()
  local lazy = require 'lazy'
  local stats = lazy.stats()
  local nvim = vim.version()
  local ms = string.format('%.2f', stats.startuptime)
  local config_path = vim.fn.stdpath 'config' .. '/lua/secvim'

  -- Count sec plugins
  local sec_count = 0
  local sec_path = config_path .. '/sec_plugins'
  if vim.fn.isdirectory(sec_path) == 1 then
    for _, entry in ipairs(vim.fn.readdir(sec_path)) do
      if vim.fn.isdirectory(sec_path .. '/' .. entry) == 1 then
        sec_count = sec_count + 1
      end
    end
  end

  -- Highlights (palette-driven so the popup stays readable in light mode)
  local ns = vim.api.nvim_create_namespace 'secvim_info'
  require('secvim.helpers.palette').define('SecvimInfo', function(p)
    return {
      Title = { fg = p.title, bold = true },
      Border = { fg = p.border },
      Label = { fg = p.key, bold = true },
      Value = { fg = p.text },
      Dim = { fg = p.dim },
      Green = { fg = p.green, bold = true },
      Key = { fg = p.yellow, bold = true },
    }
  end)

  local pad = '            '
  local gap = '     '
  local label_w = 20

  local function row(label, value)
    return pad .. label .. string.rep(' ', label_w - #label) .. value
  end

  local info_items = {
    { label = 'Neovim', value = 'v' .. nvim.major .. '.' .. nvim.minor .. '.' .. nvim.patch },
    { label = 'Plugins', value = stats.loaded .. ' / ' .. stats.count .. ' loaded', key = 'p', dir = config_path .. '/plugins' },
    { label = 'Sec Plugins', value = tostring(sec_count), key = 'r', dir = sec_path },
    { label = 'Startup', value = ms .. 'ms' },
  }

  local lines = {
    pad .. ' ' .. M.name .. ' v' .. M.version,
    pad .. string.rep('─', 46),
    '',
  }

  local highlights = {
    { 'SecvimInfoGreen', 0 },
    { 'SecvimInfoDim', 1 },
  }

  local key_map = {}

  for _, item in ipairs(info_items) do
    local line
    if item.key then
      line = pad .. item.key .. gap .. item.label .. string.rep(' ', label_w - #item.label) .. item.value
      local ln = #lines
      table.insert(highlights, { 'SecvimInfoKey', ln, #pad, #pad + 1 })
      table.insert(highlights, { 'SecvimInfoLabel', ln, #pad + 1 + #gap, #pad + 1 + #gap + label_w })
      table.insert(highlights, { 'SecvimInfoValue', ln, #pad + 1 + #gap + label_w, -1 })
      key_map[item.key] = { title = item.label, dir = item.dir }
    else
      line = pad .. ' ' .. gap .. item.label .. string.rep(' ', label_w - #item.label) .. item.value
      local ln = #lines
      table.insert(highlights, { 'SecvimInfoLabel', ln, #pad + 1 + #gap, #pad + 1 + #gap + label_w })
      table.insert(highlights, { 'SecvimInfoValue', ln, #pad + 1 + #gap + label_w, -1 })
    end
    table.insert(lines, line)
  end

  table.insert(lines, '')

  -- Float
  local width = 70
  local height = #lines
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = 'wipe'

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    title = '  ' .. M.name .. ' ',
    title_pos = 'center',
    footer = ' q: close ',
    footer_pos = 'center',
  })

  vim.wo[win].winhl = 'Normal:Normal,FloatBorder:SecvimInfoBorder,FloatTitle:SecvimInfoTitle,FloatFooter:SecvimInfoDim'
  vim.wo[win].cursorline = false

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  for _, hl in ipairs(highlights) do
    local col_end = hl[4] or -1
    vim.api.nvim_buf_set_extmark(buf, ns, hl[2], hl[3] or 0, {
      end_row = col_end == -1 and hl[2] + 1 or hl[2],
      end_col = col_end == -1 and 0 or col_end,
      hl_group = hl[1],
    })
  end

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local kopts = { buffer = buf, silent = true, nowait = true }
  vim.keymap.set('n', 'q', close, kopts)
  vim.keymap.set('n', '<Esc>', close, kopts)

  for k, item in pairs(key_map) do
    vim.keymap.set('n', k, function()
      close()
      vim.schedule(function()
        browse_dir(' ' .. item.title, item.dir)
      end)
    end, kopts)
  end
end

vim.api.nvim_create_user_command('Secvim', function()
  M.info()
end, { desc = 'Show Secvim info' })

return M
