require("lib.geo")

---@alias Direction
---| "UP"
---| "DOWN"


---@class Pipe
---@field x number
---@field y number
---@field height number
---@field width number
---@field direction Direction
Pipe = {}

---comment
---@param x number
---@param y number
---Height of the pipe default to 20
---@param height? number
---width of the pipe default to 10
---@param width? number
---@param direction? Direction
---@return Pipe
function Pipe:new(x, y, height, width, direction)
  if width == nil then
    width = 10
  end
  if direction == nil then
    direction = "UP"
  end
  if height == nil then
    height = 20
  end
  local o = {
    x=x,
    y=y,
    width=width,
    height=height,
    direction=direction
  }
  setmetatable(o, self)
  self.__index = self
  return o
end


---comment
---@param screen Screen
function Pipe:draw(screen)
  --- ████
  ---  ██
  ---  ██
  ---
  screen:setDrawBgColor(40)
  if self.direction == "UP" then
    --- draw the bottom pipe
    screen:drawRect(Rect:new(self.x + 1, self.y, self.width - 2, self.height - 1))
    --- draw the top
    screen:drawRect(Rect:new(self.x, self.y + self.height - 1, self.width, 1))
  else
    -- screen:drawRect(Rect:new(self.x + 1, self.y, self.width - 2, self.height - 1))
    --- draw the bottom pipe
    screen:drawRect(Rect:new(self.x + 1, screen.rows - self.height + 1, self.width - 2, self.height - 1))
    --- draw the top
    screen:drawRect(Rect:new(self.x, screen.rows - self.height, self.width, 1))
  end
end


function Pipe:toString()
  return string.format("Pipe(%f, %f, %f, %f)", self.x, self.y, self.width, self.height)
end
