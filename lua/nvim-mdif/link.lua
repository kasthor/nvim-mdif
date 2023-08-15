local utils = require('nvim-mdif.utils')
local window = require('nvim-mdif.window')

local function is_external(target)
  return target:match('^https?://')
end

local function get_file_relative_to_current_buffer(currw, link, format)
  return vim.fn.expand(window.dirname(currw) .. '/' .. link .. "." .. format)
end

local function fix_link(currw, target, format)
  if is_external(target) then
    return target
  else
    return get_file_relative_to_current_buffer(currw, target, format)
  end
end

local function at_cursor(format)
  local curw = window.current()
  local line = utils.get_current_line()
  local col = vim.fn.col('.')

  local start = col
  while start > 0 and not line:sub(start, start):match('%[') do
    start = start - 1
  end

  if line:sub(start, start):match('%[') then
    local start_match, end_match, text, target =
        string.find(line, '%[([^%]]+)%]%(([^%)]+)%)', start)

    if target and col >= start_match and col <= end_match then
      return fix_link(curw, target, format), text
    end
  end
end

return {
  is_external = is_external,
  at_cursor = at_cursor
}
