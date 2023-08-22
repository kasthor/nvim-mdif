local config = require('nvim-mdif.config')
local filesystem = require('nvim-mdif.filesystem')
local pane = require('nvim-mdif.pane')
local utils = require('nvim-mdif.utils')

local function is_telescope_installed()
  return not vim.fn.exists(":Telescope") ~= 0
end

local function setup_keymaps()
  local telescope = require('telescope.builtin')
  local actions = require('telescope.actions')
  local state = require('telescope.actions.state')
  local configuration = config.get_config('telescope')
  local keymaps = configuration['keymaps']

  local attach_mappings = function(_, map)
    map('i', '<CR>', function(prompt_bufnr)
      local selection = state.get_selected_entry(prompt_bufnr)
      actions.close(prompt_bufnr)
      pane.toggle_with(filesystem.get_full_path(selection.value))
    end)

    return true
  end

  local find_notes = function()
    telescope.find_files({ cwd = filesystem.get_directory_name(), attach_mappings = attach_mappings })
  end

  local grep_notes = function()
    telescope.live_grep({ cwd = filesystem.get_directory_name(), attach_mappings = attach_mappings })
  end

  utils.skey('n', keymaps['grep'], grep_notes)
  utils.skey('n', keymaps['find'], find_notes)
end

local function setup()
  if is_telescope_installed() then
    setup_keymaps()
  end
end

return { setup = setup }
