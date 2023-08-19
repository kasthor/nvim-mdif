local config = require('nvim-mdif.config')
local todo = require('nvim-mdif.todo')
local navigation = require('nvim-mdif.navigation')
local pane = require('nvim-mdif.pane')
local utils = require('nvim-mdif.utils')

local function init()
  local configuration = config.get_config('keymaps')

  utils.skey('n', configuration['toggle_window'], pane.toggle_window)
  utils.skey('n', configuration['toggle_index'], pane.toggle_index)
  utils.skey('n', configuration['toggle_diary_today'], pane.toggle_diary_today)
  utils.skey('n', configuration['toggle_todo'], todo.toggle_at_current_line)
  utils.skey('n', configuration['follow_link'], navigation.follow_link)
  utils.skey('n', configuration['navigate_back'], navigation.go_back)
end

return {
  init = init
}
