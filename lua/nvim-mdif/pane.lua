local env = require('nvim-mdif.environment')
local navigation = require('nvim-mdif.navigation')
local filesystem = require('nvim-mdif.filesystem')


local function toggle_window()
  local target_file = filesystem.get_index()

  if not navigation.has_links() or not navigation.peek_link() then
    navigation.push_link(target_file)
  end

  env.toggle_pane(navigation.peek_link())
end

return {
  toggle_window = toggle_window
}
