---@class Point
---@field x number
---@field y number
Point = {}


---comment
---@return Point
function Point:origin()
  return Point:new(0.0, 0.0)
end


---comment
---@param x number
---@param y number
---@return Point
function Point:new(x, y)
  local o = {x=x, y=y}
  setmetatable(o, self)
  self.__index = self
  return o
end


---comment
---@return string
function Point:toString()
  return string.format("Point(%f, %f)", self.x, self.y)
end


function Point:print()
  print(self:toString());
end


function Point.__add(p1, p2)
  return Point:new(p1.x + p2.x, p1.y + p2.y)
end


function Point.__sub(p1, p2)
  return Point:new(p1.x - p2.x, p1.y - p2.y)
end


---@class Rect
---@field x number
---@field y number
---@field width number
---@field height number
Rect = {}


---Instanciate a new rect
---The origin is the bottom left corner
---@param x number
---@param y number
---@param width number
---@param height number
---@return Rect
function Rect:new(x, y, width, height)
  local o = {x=x, y=y, width=width, height=height}
  setmetatable(o, self)
  self.__index = self
  return o
end


---comment
---@return Point
function Rect:topLeft()
  return Point:new(self.x, self.y + self.height)
end


---comment
---@return Point
function Rect:bottomRight()
  return Point:new(self.x + self.width, self.y)
end


