require("lib.pipe")
require("lib.flappy")
local flappylib = require("flappylib")

---@class State
State = {}

---comment
---@param o table
---@return State
function State:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function State:begin(game)
end

---@param keys integer[]
---@param game Game
---@return State
function State:processKeys(keys, game)
  for _, key in pairs(keys) do
    if key == 3 then
      return ClosingState:new{}
    end
  end
  return self
end

---@param game Game
---@param delatime number
---@return State
function State:update(game, delatime)
  game.flappy:update(delatime)
  game.grass = game.grass + game.pipeSpeed * delatime
  return self
end

---check if we should stop the game
---@return boolean
function State:shoudQuit()
  return false
end


---draw overlay on the game
---@param screen Screen
function State:draw(screen)
end


---@class WaitingState:State
WaitingState = State:new{}


---
---@param keys integer[]
---@param game Game
---@return State
function WaitingState:processKeys(keys, game)
    for _, key in pairs(keys) do
      if key == 32 then
        game.flappy.isPlaying = true
        local out = PlayingState:new{}
        out:begin(game)
        return out
      end
    end
    return State.processKeys(self, keys, game)
end


ClosingState = State:new{}
function ClosingState:shoudQuit()
  return true
end

---@class PlayingState:State
---@field isJumping boolean
---@field lastJumpingTime number
---@field timeBetweenJump number
---@field jumpYvelocity number
---@field score integer
PlayingState = State:new{
  isJumping = false,
  lastJumpingTime = 0,
  timeBetweenJump = 0.25,
  jumpYvelocity = 1.5,
  score = 0
}

---comment
---@param game Game
---@param delatime number
---@return State
function PlayingState:update(game, delatime)
  for _, pipes in pairs(game.pipes) do
    pipes[1].x = pipes[1].x - (game.pipeSpeed * delatime);
    pipes[2].x = pipes[2].x - (game.pipeSpeed * delatime);
  end

  if #game.pipes >= 1 then
    local firstpipe = game.pipes[1][1]
    if firstpipe.x < -firstpipe.width then
      table.remove(game.pipes, 1)
    end
  end

  game.flappy:update(delatime)
  if game.flappy.pos.y <= game.floorHeight + 1 then
    game.flappy.pos.y = game.floorHeight + 1
    game.flappy.velocity.y = game.flappy.velocity.y * -0.5
    game.flappy.animationSpeed = 0;
    local state = GameOverState:new{score=self.score}
    state:begin(game)
    return state
  end

  -- Check if we have crossed a new pipe
  local posx = game.flappy.pos.x
  local flappyRect = game.flappy:rect()
  for _, pipes in pairs(game.pipes) do
    local pip = pipes[1]
    if pip.x + pip.width < posx and not pip.crossed then
      self.score = self.score + 1
      pip.crossed = true
    end
    if pipes[1]:rect():intersect(flappyRect) or pipes[2]:rect():intersect(flappyRect) then
      game.flappy.velocity.x = -0.5
      game.flappy.velocity.y = -game.flappy.velocity.y
      game.flappy.animationSpeed = 0;
      local state = GameOverState:new{score=self.score}
      state:begin(game)
      return state
    end
  end

  -- need to check if i should generate a new pipe
  if #game.pipes >= 1 and game.screen.columns - game.pipes[#game.pipes][1].x >= game.pipeDistance then
    -- add a new pipe
    game.pipes[#game.pipes+1] = self:generatePipe(game)
  end
  game.grass = game.grass + game.pipeSpeed * delatime
  return self
end


---comment
---@param game Game
function PlayingState:jump(game)
  self.lastJumpingTime = os.clock()
  self.isJumping = true
  game.flappy.velocity.y = self.jumpYvelocity
end

---
---@param game Game
function PlayingState:begin(game)
  self:jump(game)
  self.score = 0

  -- build the pipes
  game.pipes = {
    self:generatePipe(game)
  }
end


---comment
---@param screen Screen
function PlayingState:draw(screen)
  screen:setDrawBgColor(232) -- black
  screen:setDrawFgColor(255) -- white
  screen:drawInteger(
    self.score,
    Point:new(math.floor(screen.screenX + screen.columns * 0.5), math.floor(screen.rows * 0.20)),
    "center",
    1
  )
end

---@class GameOverState:State
---@field score integer
---@field continue boolean
---@field starttime number
GameOverState = State:new{
  score = 0,
  continue = true,
  starttime = 0
}


function GameOverState:begin(_)
  self.starttime = os.clock()
end

---comment
---@param game Game
---@param delatime number
---@return GameOverState
function GameOverState:update(game, delatime)
  game.flappy:update(delatime)
  if game.flappy.pos.y <= game.floorHeight + 1 then
    game.flappy.pos.y = game.floorHeight + 1
    game.flappy.velocity.y = game.flappy.velocity.y * -0.5
  end
  return self
end

function GameOverState:processKeys(keys, game)
  for _, key in pairs(keys) do
    -- enter
    if key == 10 then
        if self.continue then
          game:init()
          return WaitingState:new{}
        else
          return ClosingState:new{}
        end
    elseif key == 27 then
      return ClosingState:new{}
    elseif key == 32 then
      -- wait for at least one second before responding to key event
      if os.clock() - self.starttime >= 0.5 then
        self.continue = not self.continue
      end
    end
  end
  return State.processKeys(self, keys, game)
end

function GameOverState:draw(screen)
  local texts =  {
    "Game Over!",
    string.format("Score: %i", self.score),
    ""
  }
  if self.continue then
    texts[#texts+1] = "  > Try Again"
    texts[#texts+1] = "    Quit"
  else
    texts[#texts+1] = "    Try Again"
    texts[#texts+1] = "  > Quit"
  end

  texts[#texts+1] = ""
  texts[#texts+1] = "Spacebar to switch"
  texts[#texts+1] = "Enter to select"

  local width = 20
  local height = 10
  local posx = screen.screenX + math.floor(screen.columns * 0.5) - math.floor(width * 0.5)
  local posy = 10
  screen:setDrawBgColor(232)
  screen:drawScreenRect(
    Point:new(posx, posy),
    Point:new(posx + width, posy + height)
  )
  screen:setDrawFgColor(255)

  for i, text in pairs(texts) do
    screen:setCursorPos(Point:new(posx + 1, posy + i))
    io.stdout:write(text)
  end

end

---
---@param game Game
function PlayingState:generatePipe(game)
  local pipeStart = game.screen.columns + 1;
  local top = game.screen:topLeft().y

  local pipeHeight = game.floorHeight + 1;
  local x = pipeStart
  local h = math.random(8, 20)
  local topY = pipeHeight + h + game.pipeSpace;
  return {
      Pipe:new(x, pipeHeight, h, 8, "UP"),
      Pipe:new(x, topY, top - topY, 8, "DOWN")
    }
end


function PlayingState:processKeys(keys, game)
  for _, key in pairs(keys) do
    if key == 32 then
      if os.clock() - self.lastJumpingTime >= self.timeBetweenJump then
        self:jump(game)
      end
    end
  end
  return State.processKeys(self, keys, game)
end


---@alias PipeCol [Pipe, Pipe]
---@class Game
---@field floorHeight integer
---@field pipeDistance integer
---@field pipeSpace integer
---@field pipes PipeCol[]
---@field screen Screen
---@field pipeSpeed number
---@field grass integer
---@field flappy Flappy
---@field state State
---@field score integer
Game = {}


---comment
---@param screen Screen
---@return Game
function Game:new(screen)
  local o = {
    floorHeight=6,
    pipeDistance=36,
    pipeSpace=12,
    pipes={},
    screen=screen,
    pipeSpeed=30,
    grass=0,
    flappy=Flappy:new(),
    state=WaitingState:new{}
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

---comment
---@alias Settings {}
---
---@param settings Settings?
function Game:init(settings)
  local pipeHeight = self.floorHeight + -1;
  -- generate the pipes
  local y = ((self.screen.rows - pipeHeight) * 0.5) + pipeHeight
  self.flappy = Flappy:new()
  self.flappy.pos.y = y
  self.flappy.pos.x = math.floor(self.screen.columns * 0.33)
  self.pipes = {}
end


---comment
---@return integer[]
function Game:fetchKeys()
  local out = {}
  while true do
    local ch = flappylib.get_ch(1)
    if ch < 0 then
      break
    end
    out[#out+1] = ch
  end
  return out
end


---comment
---@param delatime number
function Game:update(delatime)
  local keys = self:fetchKeys()
  self.state = self.state:processKeys(keys, self)
  self.state = self.state:update(self, delatime)
end


function Game:draw()
  -- draw the sky
  self.screen:beginDraw(39)
  -- draw the floor
  self.screen:setDrawBgColor(130)
  self.screen:drawRect(Rect:new(0, 0, self.screen.columns, self.floorHeight - 1))
  -- draw the grass
  self.screen:setDrawBgColor(22)
  -- self.screen:drawHorizontaline(0, self.floorHeight, self.screen.columns)

  local cstart = 22
  local cend = 30
  if math.floor(self.grass / 4) % 2 == 1 then
    cstart = 30
    cend = 22
  end
  self.screen:drawAlternatingHorizontalLine(
    0,
    self.floorHeight,
    self.screen.columns,
    4 - math.ceil(math.fmod(self.grass, 4)),
    4,
    cstart,
    cend
  )
  -- -- draw the pipes
  self.screen:setDrawBgColor(40)
  for _, pipes in pairs(self.pipes) do
    pipes[1]:draw(self.screen)
    pipes[2]:draw(self.screen)
  end
  self.flappy:draw(self.screen)

  self.state:draw(self.screen)

end


return Game;
