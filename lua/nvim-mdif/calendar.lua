local pane = require('nvim-mdif.pane')
local config = require('nvim-mdif.config')

local function peek_calendar_day()
  local year = vim.api.nvim_eval('b:calendar.day().get_year()')
  local month = vim.api.nvim_eval('b:calendar.day().get_month()')
  local day = vim.api.nvim_eval('b:calendar.day().get_day()')

  pane.toggle_diary({ year = year, month = month, day = day })
end

local function open_calendar_day()
  peek_calendar_day()
  pane.set_active()
end

local function set_calendar_keymap()
  local configuration = config.get_config('calendar')

  vim.keymap.set('n', configuration['keymaps']['open'], open_calendar_day, { buffer = true })
  vim.keymap.set('n', configuration['keymaps']['peek'], peek_calendar_day, { buffer = true })
end

local function is_calendar_installed()
  return vim.fn.exists(":Calendar") == 1
end

local function setup()
  local configuration = config.get_config('calendar')

  if is_calendar_installed() and configuration['activate'] then
    vim.cmd([[autocmd FileType calendar lua require('nvim-mdif.calendar').set_calendar_keymap()]])
  end
end

return {
  setup = setup,
  set_calendar_keymap = set_calendar_keymap
}
