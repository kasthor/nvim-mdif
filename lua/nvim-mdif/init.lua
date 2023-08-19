local utils = require('nvim-mdif.utils')
local keymaps = require('nvim-mdif.keymaps')
local config = require('nvim-mdif.config')

local function setup(configuration)
  config.load_config(configuration)
  keymaps.init()

  utils.skey('n', '<Leader>r', ":Lazy reload nvim-mdif<CR>")
end


return {
  setup = setup
}
