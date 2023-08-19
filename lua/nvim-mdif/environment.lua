local window = require('nvim-mdif.window')
local pane = nil;

local function is_pane()
  return pane == window.current()
end

local function is_pane_open()
  return pane and not window.is_closed(pane)
end

local function clear_pane()
  pane = nil
end

local function set_active()
  window.switch_to(pane)
end

local function toggle_pane(file, keep_open)
  if is_pane_open() then
    if keep_open then
      window.open_file(file, pane)
    else
      window.close(pane)
      clear_pane()
    end
    return false
  else
    pane = window.open_file_in_new_window(file)
    return true
  end
end

return {
  is_pane = is_pane,
  is_pane_open = is_pane_open,
  toggle_pane = toggle_pane,
  set_active = set_active,
}
