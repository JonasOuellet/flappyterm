#!/usr/bin/lua

require("lib.screen")
require("lib.game")
local test = require("flappylib")

ESC = 0x1B;
CSI = string.format("%c[", ESC);


GRAVITY = -9


local function sleep(seconds)
  local start = os.clock();
  while true do
    if os.clock() - start >= seconds then
      break
    end
  end
end

local screen = Screen:new(30, 30);
local game = Game:new(screen);


local function updateScreenSize()
  local row, column = test.window_size()
  screen.columns = math.min(column, 60)
  screen.rows = row
  screen.screenX = math.floor(column / 2) - math.floor(screen.columns / 2)
end


local function init()
  test.init_window()
  updateScreenSize()
  -- io.stdin:setvbuf("no")
  -- -- hiding the cursor
  io.stdout:write(string.format("%s?25l", CSI));
  -- switch to alternate screen buffer
  io.stdout:write(string.format("%s?1049h", CSI));
  game:init();
end


local function close()
  -- restore normal mode
  io.stdout:write(string.format("%s?1049l", CSI))
  io.stdout:flush()
  test.close_window()
end

local targetFps = 30;
local deltaTime = 0.0;
local function run()
  init();
  while true do
    local start = os.clock()
    updateScreenSize()
    game:update(deltaTime)
    game:draw()
    deltaTime = os.clock() - start;
    local fps = 1.0 / deltaTime;
    deltaTime = os.clock() - start;
    fps = 1.0 / deltaTime;
    if fps > targetFps then
      -- sleep the time needed to at least have the target fps
      sleep(math.max(0, (1.0 / targetFps) - deltaTime))
    end
    deltaTime = os.clock() - start;
    fps = 1.0 / deltaTime;
    -- print the fps and set the foreground color the same as the background so user input is not visible
    game.screen:setFontDraw(37, 40)
    io.stdout:write(string.format("%sHFps: %f\n", CSI, fps))
    if game.state:shoudQuit() then
      break
    end
  end
end


local status, err = pcall(run)
-- check for interrupt
-- restore normal mode
close()

print(status, err)
return err
