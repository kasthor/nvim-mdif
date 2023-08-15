local buffer = require('nvim-mdif.buffer')

local function current()
  return vim.api.nvim_get_current_win()
end

local function create()
  vim.cmd('vsp')

  return current()
end

local function is_closed(win)
  return not vim.api.nvim_win_is_valid(win)
end

local function close(win)
  if not is_closed(win) then
    vim.api.nvim_win_close(win, true)
  end
end

local function move(win)
  vim.cmd(win .. 'wincmd L')
end

local function open_file(filename, window)
  buffer.open(filename, window)

  return window;
end

local function open_file_in_new_window(filename)
  local currw = create()
  open_file(filename, currw)
  move(currw)

  return currw
end

local function dirname(window)
  local bufnr = vim.fn.winbufnr(window)
  local path = vim.fn.bufname(bufnr)

  return vim.fn.expand(vim.fn.fnamemodify(path, ':h'))
end


return {
  current = current,
  create = create,
  is_closed = is_closed,
  close = close,
  move = move,
  open_file = open_file,
  open_file_in_new_window = open_file_in_new_window,
  dirname = dirname
}
