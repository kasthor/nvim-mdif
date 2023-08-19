local config = require('nvim-mdif.config')

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

return {
  get_index = get_index
}
