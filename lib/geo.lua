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

---comment
---@return Point
function Rect:bottomLeft()
  return Point:new(self.x, self.y)
end


function Rect:topRight()
  return Point:new(self.x + self.width, self.y + self.height)
end



---Check if two rect intersects
---@param other Rect
---@return boolean
function Rect:intersect(other)
  -- https://www.educative.io/answers/how-to-check-if-two-rectangles-overlap-each-other
  local rect1 = {self.x, self.y, self.x + self.width, self.y + self.height}
  local rect2 = {other.x , other.y, other.x + other.width, other.y + other.height}
  local width = math.min(rect1[3], rect2[3]) > math.max(rect1[1], rect2[1])
  local height = math.min(rect1[4], rect2[4]) > math.max(rect1[2], rect2[2])
  return width and height
end


function Rect:toString()
  return string.format("Rect(%f, %f, %f, %f)", self.x, self.y, self.width, self.height)
end
