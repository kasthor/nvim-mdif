local function open(filename, currw)
  currw = currw or 0
  local buf = vim.fn.bufadd(filename)
  vim.api.nvim_win_set_buf(currw, buf)
end

return {
  open = open
}
