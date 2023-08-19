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

local function deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == table and type(t1(k)) == table then
      deep_merge(t1[k], v)
    else
      t1[k] = v
    end
  end

  return t1
end

local function touch(filename)
  local f = io.open(filename, "a")
  if f then
    f:close()
  end
end

return {
  get_current_line = get_current_line,
  set_current_line = set_current_line,
  open_url = open_url,
  skey = skey,
  deep_merge = deep_merge,
  touch = touch,
  log = log
}
