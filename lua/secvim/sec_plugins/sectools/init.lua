--- Sec Tools - quick text transforms and binary inspection for security work.
--- Everything runs locally. No network calls, no external services.
local M = {}

local function notify(level, msg)
  vim.notify('Sectools: ' .. msg, level)
end

-- ── Transforms ──────────────────────────────────────────────────────

local function b64_decode(s)
  s = s:gsub('%s+', ''):gsub('%-', '+'):gsub('_', '/')
  local rem = #s % 4
  if rem > 0 then
    s = s .. string.rep('=', 4 - rem)
  end
  return vim.base64.decode(s)
end

local function b64url_encode(s)
  return (vim.base64.encode(s):gsub('+', '-'):gsub('/', '_'):gsub('=+$', ''))
end

local function hex_encode(s)
  return (s:gsub('.', function(c)
    return string.format('%02x', string.byte(c))
  end))
end

local function hex_decode(s)
  s = s:gsub('0x', ''):gsub('\\x', ''):gsub('%s+', '')
  if #s % 2 ~= 0 or s:find '[^%x]' then
    error 'invalid hex input'
  end
  return (s:gsub('%x%x', function(h)
    return string.char(tonumber(h, 16))
  end))
end

local function pretty_json(s)
  if vim.fn.executable 'jq' == 1 then
    local out = vim.fn.system({ 'jq', '.' }, s)
    if vim.v.shell_error == 0 then
      return (out:gsub('%s+$', ''))
    end
  end
  local ok, decoded = pcall(vim.json.decode, s)
  if ok then
    return vim.json.encode(decoded)
  end
  return s
end

local function minify_json(s)
  local ok, decoded = pcall(vim.json.decode, s)
  if not ok then
    error('invalid JSON: ' .. tostring(decoded))
  end
  return vim.json.encode(decoded)
end

local function jwt_decode(token)
  token = token:gsub('^Bearer%s+', ''):gsub('%s+$', '')
  local parts = vim.split(token, '.', { plain = true })
  if #parts < 2 then
    error 'not a JWT (expected header.payload.signature)'
  end
  local out = {
    'HEADER',
    pretty_json(b64_decode(parts[1])),
    '',
    'PAYLOAD',
    pretty_json(b64_decode(parts[2])),
  }
  if parts[3] and parts[3] ~= '' then
    out[#out + 1] = ''
    out[#out + 1] = 'SIGNATURE'
    out[#out + 1] = parts[3]
  end
  return table.concat(out, '\n')
end

local transforms = {
  {
    'Base64 - encode',
    function(s)
      return vim.base64.encode(s)
    end,
  },
  { 'Base64 - decode', b64_decode },
  { 'Base64URL - encode', b64url_encode },
  { 'Base64URL - decode', b64_decode },
  {
    'URL - encode',
    function(s)
      return vim.uri_encode(s)
    end,
  },
  {
    'URL - decode',
    function(s)
      return vim.uri_decode(s)
    end,
  },
  { 'Hex - encode', hex_encode },
  { 'Hex - decode', hex_decode },
  { 'JWT - decode', jwt_decode },
  { 'JSON - pretty print', pretty_json },
  { 'JSON - minify', minify_json },
}

-- ── Selection input ─────────────────────────────────────────────────

local function visual_selection()
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '\22' then
    local ok, lines = pcall(vim.fn.getregion, vim.fn.getpos 'v', vim.fn.getpos '.', { type = mode })
    if ok and type(lines) == 'table' and #lines > 0 then
      return table.concat(lines, '\n')
    end
  end

  -- The mapping may already have left visual mode by the time we run.
  local s = vim.fn.getpos "'<"
  local e = vim.fn.getpos "'>"
  if s[2] == 0 or e[2] == 0 then
    return nil
  end
  local last_mode = vim.fn.visualmode()
  local lines = vim.fn.getline(s[2], e[2])
  if type(lines) ~= 'table' or #lines == 0 then
    return nil
  end
  if last_mode == 'V' then
    return table.concat(lines, '\n')
  end
  if #lines == 1 then
    return lines[1]:sub(math.min(s[3], e[3]), math.max(s[3], e[3]))
  end
  lines[1] = lines[1]:sub(s[3])
  lines[#lines] = lines[#lines]:sub(1, e[3])
  return table.concat(lines, '\n')
end

local function replace_visual(text)
  local s = vim.fn.getpos "'<"
  local e = vim.fn.getpos "'>"
  if s[2] == 0 or e[2] == 0 then
    return false
  end

  local new_lines = vim.split(text, '\n', { plain = true })
  if vim.fn.visualmode() == 'V' then
    vim.api.nvim_buf_set_lines(0, s[2] - 1, e[2], false, new_lines)
    return true
  end

  local first = vim.api.nvim_buf_get_lines(0, s[2] - 1, s[2], false)[1] or ''
  if s[2] == e[2] then
    local a, b = math.min(s[3], e[3]), math.max(s[3], e[3])
    local line = first:sub(1, a - 1) .. text .. first:sub(b + 1)
    vim.api.nvim_buf_set_lines(0, s[2] - 1, s[2], false, { line })
    return true
  end

  local last = vim.api.nvim_buf_get_lines(0, e[2] - 1, e[2], false)[1] or ''
  new_lines[1] = first:sub(1, s[3] - 1) .. new_lines[1]
  new_lines[#new_lines] = new_lines[#new_lines] .. last:sub(e[3] + 1)
  vim.api.nvim_buf_set_lines(0, s[2] - 1, e[2], false, new_lines)
  return true
end

-- ── Result window ───────────────────────────────────────────────────

---@param text string
---@param title string
function M.show(text, title)
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = vim.split(text, '\n', { plain = true })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  if pcall(vim.json.decode, text) then
    vim.bo[buf].filetype = 'json'
  end

  local width = math.max(20, math.min(120, vim.o.columns - 8))
  local height = math.max(3, math.min(#lines, math.max(3, vim.o.lines - 8)))
  local row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1)
  local col = math.max(0, math.floor((vim.o.columns - width) / 2))

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    title = ' Sectools: ' .. title .. ' ',
    title_pos = 'center',
  })
  vim.wo[win].wrap = true

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
  vim.keymap.set('n', 'q', close, { buffer = buf, nowait = true, desc = 'Close' })
  vim.keymap.set('n', '<Esc>', close, { buffer = buf, nowait = true, desc = 'Close' })

  pcall(vim.fn.setreg, '+', text)
  notify(vim.log.levels.INFO, 'copied to clipboard')
end

-- ── Hex dump ────────────────────────────────────────────────────────

local MAX_HEX_BYTES = 64 * 1024

function M.hexdump()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' or vim.bo.buftype ~= '' then
    notify(vim.log.levels.WARN, 'open a file buffer first')
    return
  end
  if vim.fn.filereadable(file) == 0 then
    notify(vim.log.levels.WARN, 'file is not readable on disk')
    return
  end

  local cmd
  if vim.fn.executable 'xxd' == 1 then
    cmd = { 'xxd', '-g', '1', '-l', tostring(MAX_HEX_BYTES), '--', file }
  elseif vim.fn.executable 'od' == 1 then
    cmd = { 'od', '-A', 'x', '-t', 'x1z', '-N', tostring(MAX_HEX_BYTES), '--', file }
  else
    notify(vim.log.levels.ERROR, 'xxd or od is required for hex dumps')
    return
  end

  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    notify(vim.log.levels.ERROR, 'hex dump failed')
    return
  end
  if vim.fn.getfsize(file) > MAX_HEX_BYTES then
    table.insert(out, 1, '--- first 64 KiB of ' .. vim.fn.fnamemodify(file, ':t') .. ' ---')
    table.insert(out, 2, '')
  end
  M.show(table.concat(out, '\n'), 'hex dump')
end

-- ── Menu ────────────────────────────────────────────────────────────

local function apply(item, text, visual)
  local ok, result = pcall(item[2], text)
  if not ok then
    notify(vim.log.levels.ERROR, tostring(result))
    return
  end
  result = tostring(result)

  if visual and replace_visual(result) then
    pcall(vim.fn.setreg, '+', result)
    notify(vim.log.levels.INFO, item[1] .. ' - selection replaced (copied)')
    return
  end
  M.show(result, item[1])
end

---@param mode? 'normal'|'visual'
function M.menu(mode)
  local visual = mode == 'visual'
  local selection = visual and visual_selection() or nil
  if visual and (selection == nil or selection == '') then
    notify(vim.log.levels.WARN, 'nothing selected')
    return
  end

  local labels = vim.tbl_map(function(item)
    return item[1]
  end, transforms)

  vim.ui.select(labels, { prompt = 'Sectools: transform' }, function(choice)
    if not choice then
      return
    end
    local item
    for _, candidate in ipairs(transforms) do
      if candidate[1] == choice then
        item = candidate
        break
      end
    end
    if not item then
      return
    end

    if visual then
      apply(item, selection, true)
      return
    end

    local word = vim.fn.expand '<cWORD>'
    vim.ui.input({ prompt = item[1] .. ': ', default = word }, function(value)
      if value == nil then
        return
      end
      if value == '' then
        notify(vim.log.levels.WARN, 'no input')
        return
      end
      apply(item, value, false)
    end)
  end)
end

return M
