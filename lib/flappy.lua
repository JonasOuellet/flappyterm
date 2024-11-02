

---@class Flappy
---@field pos Point
---@field velocity Point
---@field animation number
---@field isPlaying boolean
---@field waving number
---@field animationSpeed number
Flappy = {}

---comment
---@return Flappy
function Flappy:new()
  local o = {
    pos = Point:new(0, 0),
    velocity = Point:new(0, 0),
    animation = 0.0,
    animationSpeed = 3,
    isPlaying = false,
    waving = 0.0
  }
  setmetatable(o, self)
  self.__index = self
  return o
end


function Flappy:update(deltatime)
  self.velocity.y = self.velocity.y + (-3 * deltatime)
  self.pos.y = self.pos.y + self.velocity.y
  self.animation = self.animation + deltatime * self.animationSpeed -- the animation speed
  if not self.isPlaying then
    if self.pos.y <= 20 then
      self.velocity.y = -self.velocity.y + 0.1
    end
  end
end

---comment
---@param screen Screen
function Flappy:draw(screen)
  -- screen:setFontDraw(30, 103, 1)
  screen:setFontDraw(38, 5, 16)
  screen:setFontDraw(48, 5, 220)
  screen:setCursorPos(screen:mapPoint(self.pos))
  local mod = math.floor(self.animation) % 4;
  if mod == 0 then
    io.stdout:write("\\\\*>")
  elseif mod == 1 or mod == 3 then
    io.stdout:write("-=*>")
  else
    io.stdout:write(",,*>")
  end
end
