local env = require('nvim-mdif.environment')
local navigation = require('nvim-mdif.navigation')
local filesystem = require('nvim-mdif.filesystem')


local function toggle_window_with_target(target_file, force)
  if force or not navigation.has_links() or not navigation.peek_link() then
    navigation.push_link(target_file)
  end

  return env.toggle_pane(navigation.peek_link(), force)
end

local function toggle_window()
  toggle_window_with_target(filesystem.get_index())
end

local function toggle_index()
  toggle_window_with_target(filesystem.get_index(), true)
end

local function toggle_diary_today()
  toggle_window_with_target(filesystem.get_diary(), true)
end

local function toggle_diary(date_values)
  toggle_window_with_target(filesystem.get_diary(date_values), true)
end

return {
  toggle_window = toggle_window,
  toggle_index = toggle_index,
  toggle_diary_today = toggle_diary_today,
  set_active = env.set_active,
  toggle_diary = toggle_diary
}
