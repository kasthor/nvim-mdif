local pane = nil;
local links = {};

local function get_current_window()
  return vim.api.nvim_get_current_win()
end

local function get_current_line()
  return vim.fn.getline('.')
end

local function set_current_line(text)
  return vim.fn.setline('.', text)
end

local function is_pane(win)
  return pane == get_current_window()
end

local function is_external_link(target)
  return target:match('^https?://')
end

local function is_window_closed(win)
  return not vim.api.nvim_win_is_valid(win)
end

local function close_window(win)
  if not is_window_closed(win) then
    vim.api.nvim_win_close(win, true)
  end
end

local function push_link(filename)
  table.insert(links,filename)
end

local function pop_link()
  table.remove(links)
end

local function peek_link()
  return links[#links]
end

local function create_window()
  vim.cmd('vsp')

  return get_current_window() 
end

local function move_window(win)
  vim.cmd(win .. 'wincmd L')
end

local function open_filename(filename)
  local buf = vim.fn.bufadd(filename)
  vim.api.nvim_win_set_buf(0, buf)
end

local function window_for_file(filename)
  local current_window = create_window()
  open_filename(filename)
  move_window(current_window)

  return current_window
end

local function log(message)
  vim.api.nvim_out_write(message .. "\n")
end

local function toggle_window()
  local target_file = vim.fn.expand('~/.config/vimwiki/index.md')

  vim.print(links)
  if pane and not is_window_closed(pane) then
    close_window(pane)
    pane = nil
  else
    if not peek_link() then
      push_link(target_file)
    end

    pane = window_for_file(peek_link())
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
  if is_external_link(target) then
    return target
  else
    return get_file_relative_to_current_buffer(window, target, format)
  end
end

local function find_link_at_cursor(window, format)
  local line = get_current_line()
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

local function open_url(url)
  local platform = io.popen('uname -s'):read("*l")

  if platform == "Linux" then
    os.execute("xdg-open " .. url)
  elseif platform == "Darwin" then
    os.execute("open " .. url)
  elseif platform:match("^Windows") then
    os.execute("start " .. url)
  end
end


local function follow_link()
  local window = vim.fn.win_getid()
  local target = find_link_at_cursor(window, "md")

  if target then
    if is_external_link(target) then
      open_url(target)
    else 
      open_filename(target)
      push_link(target)
    end
  end
end

local function go_back()
  if is_pane(get_current_window()) then

    if #links > 0 then
      pop_link()

      open_filename(peek_link())
    end
  end
end

local function get_todo_state(line)
  local _, _, state = line:find('^%s*%-%s%[([xX%s])%]%s')

  return state
end

local function toggle_state(state)
  return not state:match("%s") and ' ' or 'x'
end

local function update_todo_state(line, state, new_state)
  return line:gsub('%-%s%[' .. state .. '%]', '- [' .. new_state .. ']', 1)
end


local function toggle_todo()
  local line = get_current_line()
  local state = get_todo_state(line)

  if state then
    local new_state = toggle_state(state)
    local new_content = update_todo_state(line, state, new_state)

    set_current_line(new_content)
  end
end

local function skey(mode, keys, func)
  vim.keymap.set(mode, keys, func, {})
end

local function setup()
  skey('n', '<Leader>w', toggle_window)
  skey('n', '<Leader>r', ":Lazy reload nvim-mdif<CR>")
  skey('n', '<Space>', toggle_todo)
  skey('n', 'gn', follow_link)
  skey('n', 'gp', go_back)
end


return {
  setup = setup,
  toggle_window = toggle_window
}
