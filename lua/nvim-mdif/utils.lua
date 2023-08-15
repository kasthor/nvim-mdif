local function get_current_line()
  return vim.fn.getline('.')
end

local function set_current_line(text)
  return vim.fn.setline('.', text)
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

local function skey(mode, keys, func)
  vim.keymap.set(mode, keys, func, {})
end

local function log(message)
  vim.api.nvim_out_write(message .. "\n")
end

return {
  get_current_line = get_current_line,
  set_current_line = set_current_line,
  open_url = open_url,
  skey = skey,
  log = log
}
