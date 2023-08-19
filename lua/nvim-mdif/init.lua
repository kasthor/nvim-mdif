local env = require('nvim-mdif.environment')
local utils = require('nvim-mdif.utils')
local todo = require('nvim-mdif.todo')
local navigation = require('nvim-mdif.navigation')
local config = require('nvim-mdif.config')
local filesystem = require('nvim-mdif.filesystem')

local function toggle_window()
  local target_file = filesystem.get_index()

  if not navigation.has_links() or not navigation.peek_link() then
    navigation.push_link(target_file)
  end

  env.toggle_pane(navigation.peek_link())
end


local function setup(configuration)
  config.load_config(configuration)

  utils.skey('n', '<Leader>w', toggle_window)
  utils.skey('n', '<Leader>r', ":Lazy reload nvim-mdif<CR>")
  utils.skey('n', '<Space>', todo.toggle_at_current_line)
  utils.skey('n', 'gn', navigation.follow_link)
  utils.skey('n', 'gp', navigation.go_back)
end


return {
  setup = setup,
  toggle_window = toggle_window
}
