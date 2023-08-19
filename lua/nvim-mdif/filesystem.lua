local config = require('nvim-mdif.config')
local utils = require('nvim-mdif.utils')

local function get_namespace()
  return 'default'
end

local function get_directory_name()
  local configuration = config.get_config('filesystem')
  return configuration['namespace'][get_namespace()]
end

local function get_extension()
  local configuration = config.get_config('filesystem')
  local extension = configuration['extension']

  if extension and extension ~= "" then
    return "." .. extension
  else
    return ""
  end
end

local function get_index_name()
  local configuration = config.get_config('filesystem')

  return configuration['index'] .. get_extension()
end

local function get_index()
  return vim.fn.expand(get_directory_name() .. '/' .. get_index_name())
end

local function get_diary_filename(date_values)
  local configuration = config.get_config('filesystem')
  local date = os.time(date_values)

  return os.date(configuration['diary_naming_format'], date) .. get_extension()
end

local function get_diary_path(date_values)
  local date = os.date("*t")
  date_values = date_values or {}
  date = utils.deep_merge(date, date_values)

  local configuration = config.get_config('filesystem')
  return vim.fn.expand(get_directory_name() .. '/' .. configuration['diary_directory'] .. '/' .. get_diary_filename(date))
end

local function get_diary(date_values)
  local diary_path = get_diary_path(date_values)

  return diary_path
end

return {
  get_index = get_index,
  get_diary = get_diary
}
