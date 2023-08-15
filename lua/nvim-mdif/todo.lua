local utils = require('nvim-mdif.utils')

local function get_state(line)
  local _, _, state = line:find('^%s*%-%s%[([xX%s])%]%s')

  return state
end

local function toggle_state(state)
  return not state:match("%s") and ' ' or 'x'
end

local function update_todo_state(line, state, new_state)
  return line:gsub('%-%s%[' .. state .. '%]', '- [' .. new_state .. ']', 1)
end

local function toggle(line)
  local state = get_state(line)

  if state then
    local new_state = toggle_state(state)

    return update_todo_state(line, state, new_state)
  end
end

local function toggle_at_current_line()
  local line = utils.get_current_line()
  local new_line = toggle(line)
  if new_line then
    utils.set_current_line(new_line)
  end
end

return {
  toggle_at_current_line = toggle_at_current_line
}
