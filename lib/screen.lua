require("lib.geo");
local drawnum = require("lib.numbers");

ESC = 0x1B;
CSI = string.format("%c[", ESC);


--- 
--- @class Screen
--- @field rows integer
--- @field columns integer
--- @field bottomLeft Point
--- @field screenX integer
Screen = {}

--- Instanciate a new screen.
--- @param rows integer
--- @param columns integer
--- @return Screen
function Screen:new(rows, columns)
  local o = {
    rows=rows,
    columns=columns,
    bottomLeft=Point:origin(),
    screenX=0
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

---@return Point
function Screen:topLeft()
  return Point:new(0, self.columns)
end

---Return to bottomLeft corner in screen space
---@return Point
function Screen:screenBottomLeft()
  return Point:new(self.screenX, self.rows)
end


function Screen:print()
  print(string.format("Rows: %i, Columns: %i", self.rows, self.columns))
end


---Map the specifed point to the screen so it can
---be drawn
---@param point Point
---@return Point
function Screen:mapPoint(point)
  local relative = point - self.bottomLeft;
  relative.y = -relative.y
  return self:screenBottomLeft() + relative;
  --res.x = -res.x
end

---comment
---@param index integer
function Screen:setDrawBgColor(index)
  io.stdout:write(string.format("%s48;5;%im", CSI, index))
end

function Screen:setDrawFgColor(index)
  io.stdout:write(string.format("%s38;5;%im", CSI, index))
end

---comment
---@param ... integer 
function Screen:setFontDraw(...)
  io.stdout:write(string.format("%s%sm", CSI, table.concat(arg, ';')))
end

---comment
---@param rect Rect
function Screen:drawRect(rect)
    local topLeft = self:mapPoint(rect:topLeft())
    local bottomRight = self:mapPoint(rect:bottomRight())
    self:drawScreenRect(topLeft, bottomRight)
end

---comment
---@param topLeft Point
---@param bottomRight Point
function Screen:drawScreenRect(topLeft, bottomRight)
    -- make sure to clamp the value
    topLeft.x = math.max(self.screenX, topLeft.x);
    topLeft.y = math.max(0, topLeft.y);

    bottomRight.x = math.min(self:maxX(), bottomRight.x);
    bottomRight.y = math.min(self.rows, bottomRight.y);

    -- should we draw this
    if bottomRight.x - topLeft.x > 1 and bottomRight.y - topLeft.y > 0 then
      io.stdout:write(string.format("%s32;%i;%i;%i;%i$x", CSI, topLeft.y, topLeft.x, bottomRight.y, bottomRight.x))
    end
end


--- begin draw and fill background with the specified color
---@param color integer
function Screen:beginDraw(color)
  self:setDrawBgColor(color);
  io.stdout:write(string.format("%s32;0;%i;%i;%i$x", CSI, self.screenX, self.rows, self.screenX + self.columns));
end


function Screen:endDraw()
  -- maybe restore default color
  io.stdout:flush();
end

---Returns the maximum screen x position
---@return integer
function Screen:maxX()
  return self.columns + self.screenX
end


---set the cursor position to draw
---use Screen.mapPoint to convert to point to screen view
---@param pos Point
function Screen:setCursorPos(pos)
  io.stdout:write(string.format("%s%i;%iH", CSI, pos.y, pos.x))
end

---comment
---@param xStart integer
---@param y integer
---@param xEnd integer
function Screen:drawHorizontaline(xStart, y, xEnd)
  local topLeft = self:mapPoint(Point:new(xStart, y))
  local bottomRight = self:mapPoint(Point:new(xEnd, 0))

  -- make sure to clamp the value
  local start = math.max(self.screenX, topLeft.x);
  local len = math.min(self:maxX(), bottomRight.x) - start;
  local row = topLeft.y;
  if len > 1 and row >= 0 and row <= self.rows then
    --- not sure why i need to add one here
    io.stdout:write(string.format("%s%i;%iH%s", CSI, row, start, string.rep(' ', len + 1)))
  end
end


function Screen:drawAlternatingHorizontalLine(xStart, y, xEnd, startCount, count, color1, color2)
  local topLeft = self:mapPoint(Point:new(xStart, y))
  local bottomRight = self:mapPoint(Point:new(xEnd, 0))

  -- make sure to clamp the value
  local start = math.max(self.screenX, topLeft.x);
  -- I need to investigate but i need to add the + 1 here otherside i am missing one block
  local len = math.min(self:maxX(), bottomRight.x) - start + 1;
  local row = topLeft.y;
  if len > 1 and row >= 0 and row <= self.rows then
    io.stdout:write(string.format("%s%i;%iH", CSI, row, start))
    -- start with current
    local current = math.min(len, startCount)
    local str = {string.format("%s48;5;%im%s", CSI, color1, string.rep(' ', current))}
    local col = 2
    local colors = {color1, color2}

    while true do
      local toAdd = math.min(count, len - current)
      if toAdd < 1 then
        break
      end
      str[#str+1] = string.format("%s48;5;%im%s", CSI, colors[col], string.rep(' ', toAdd))
      if col == 2 then
        col = 1
      else
        col = 2
      end
      current = current + toAdd
    end
    io.stdout:write(table.concat(str))
  end
end

---Draw the specified integer.  Use set background and set foreground color
---to set the color
---
---@alias Align string
---| "center"
---
---@param number integer
---@param screenPos Point
---@param align? Align
---@param borderWidth? integer
function Screen:drawInteger(number, screenPos, align, borderWidth)
  if align == nil then
    align = "center"
  end

  if borderWidth == nil then
    borderWidth = 0
  end

  local todrawstr = tostring(number)
  local todraw = {}
  for i = 1, todrawstr:len(), 1 do
    todraw[#todraw+1] = drawnum.numbers[tonumber(todrawstr:sub(i, i), 10) + 1]
  end
  local todrawX = (#todrawstr  * drawnum.size[1]) + (#todrawstr - 1) + borderWidth + borderWidth
  local todrawY = drawnum.size[2] + borderWidth + borderWidth;
  if align == "center" then
    screenPos.x = screenPos.x - math.floor(todrawX * 0.5)
    screenPos.y = screenPos.y - math.floor(todrawY * 0.5)
  end

  -- draw to top border
  local function drawBorder()
    for _ = 1, borderWidth, 1 do
      self:setCursorPos(screenPos)
      io.stdout:write(string.rep(' ', todrawX))
      screenPos.y = screenPos.y + 1
    end
  end

  drawBorder()

  local spaces = string.rep(' ', borderWidth)
  for i = 1, drawnum.size[2], 1 do
    local curRowDraw = {}
    for _, x in pairs(todraw) do
      curRowDraw[#curRowDraw+1] = x[i]
    end
    self:setCursorPos(screenPos)
    io.stdout:write(string.format("%s%s%s", spaces, table.concat(curRowDraw, ' '), spaces))
    screenPos.y = screenPos.y + 1
  end

  drawBorder()
end



