local pane = require('nvim-mdif.pane')

local function peek_calendar_day()
  local year = vim.api.nvim_eval('b:calendar.day().get_year()')
  local month = vim.api.nvim_eval('b:calendar.day().get_month()')
  local day = vim.api.nvim_eval('b:calendar.day().get_day()')

  pane.toggle_diary({ year = year, month = month, day = day })
end

local function open_calendar_day()
  pane.set_active()
end

local function set_calendar_keymap()
  vim.keymap.set('n', '<CR>', open_calendar_day, { buffer = true })
  vim.keymap.set('n', 'p', peek_calendar_day, { buffer = true })
end

local function setup()
  vim.cmd([[autocmd FileType calendar lua require('nvim-mdif.calendar').set_calendar_keymap()]])
end

return {
  setup = setup,
  set_calendar_keymap = set_calendar_keymap
}
