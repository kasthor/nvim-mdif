local pane = nil;

local function is_window_closed(win)
  return not vim.api.nvim_win_is_valid(win)
end

local function close_window(win)
  if not is_window_closed(win) then
    vim.api.nvim_win_close(win, true)
  end
end

local function create_window()
  vim.cmd('vsp')

  return vim.api.nvim_get_current_win()
end

local function move_window(win)
  vim.cmd(win .. 'wincmd L')
end

local function window_for_file(filename)
  local buf = vim.fn.bufadd(vim.fn.expand(filename))
  local current_window = create_window()
  vim.api.nvim_win_set_buf(0, buf)

  move_window(current_window);

  return current_window
end

local function log(message)
  vim.api.nvim_out_write(message .. "\n")
end

local function toggle_window()
  local target_file = '~/.config/vimwiki/index.md'

  log("toggle")
  if pane and not is_window_closed(pane) then
    log("pane or open")
    close_window(pane)
    pane = nil
  else
    log("not pane or closed")
    print("is window closed")
    pane = window_for_file(target_file)
  end
end

local function get_window_dirname(window)
  local bufnr = vim.fn.winbufnr(window)
  local path = vim.fn.bufname(bufnr)

  return vim.fn.expand(vim.fn.fnamemodify(path, ':h'))
end

local function get_file_relative_to_current_buffer(window, link, format)
  return vim.fn.expand(get_window_dirname(window) .. '/' .. link .. "." .. format)
end

local function fix_link(window, target, format)
  return get_file_relative_to_current_buffer(window, target, format)
end

local function find_link_at_cursor(window, format)
  local line = vim.fn.getline('.')
  local col = vim.fn.col('.')

  local start = col
  while start > 0 and not line:sub(start, start):match('%[') do
    start = start - 1
  end

  if line:sub(start, start):match('%[') then
    local start_match, end_match, text, target =
        string.find(line, '%[([^%]]+)%]%(([^%)]+)%)', start)

    if target and col >= start_match and col <= end_match then
      return fix_link(window, target, format), text
    end
  end
end


local function follow_link()
  local window = vim.fn.win_getid()
  local target = find_link_at_cursor(window, "md")

  print(target)
  vim.cmd('edit ' .. target)
end

local function skey(mode, keys, func)
  vim.keymap.set(mode, keys, func, {})
end

local function setup()
  print("hola mundo, otro")
  skey('n', '<Leader>w', toggle_window)
  skey('n', '<Leader>r', ":Lazy reload nvim-mdif<CR>")
  skey('n', 'gn', follow_link)
end


return {
  setup = setup,
  toggle_window = toggle_window
}
