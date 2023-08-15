local utils = require('nvim-mdif.utils')
local buffer = require('nvim-mdif.buffer')
local link = require('nvim-mdif.link')
local env = require('nvim-mdif.environment')
local links = {};

local function has_links()
  return #links > 0
end

local function push_link(filename)
  table.insert(links, filename)
end

local function pop_link()
  table.remove(links)
end

local function peek_link()
  return links[#links]
end

local function follow_link()
  local target = link.at_cursor("md")

  if target then
    if link.is_external(target) then
      utils.open_url(target)
    else
      buffer.open(target)
      push_link(target)
    end
  end
end

local function go_back()
  if env.is_pane() then
    if has_links() then
      pop_link()

      buffer.open(peek_link())
    end
  end
end

return {
  has_links = has_links,
  peek_link = peek_link,
  push_link = push_link,
  pop_link = pop_link,
  follow_link = follow_link,
  go_back = go_back
}
