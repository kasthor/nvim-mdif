local utils = require("nvim-mdif.utils")
local configuration = nil

local function get_config_defaults()
  return {
    filesystem = {
      index = "Index",
      extension = "md",
      namespace = {
        default = "~/.config/notes"
      }
    },
    keymaps = {
      toggle_window = "<Leader>ww",
      toggle_todo = "<Space>",
      follow_link = "gn",
      navigate_back = "gp"
    }
  }
end

local function prepare_config(config)
  return utils.deep_merge(get_config_defaults(), config)
end

local function load_config(config)
  configuration = prepare_config(config)
end

local function get_config(key)
  if key then
    return configuration[key]
  else
    return configuration
  end
end

return {
  get_config = get_config,
  load_config = load_config
}
