
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


local function moveToStart()
  io.stdout:write(string.format("%sH", CSI))
end


local function init()
  -- -- clear the terminal and move the cursor to begining
  -- io.stdout:write(string.format("%s2J",CSI));
  -- -- hiding the cursor
  io.stdout:write(string.format("%s?25l", CSI));
  -- switch to alternate screen buffer
  io.stdout:write(string.format("%s?1049h", CSI));
  -- io.stdout:write(string.format("%s?30l", CSI));
  io.stdout:flush();
end

local function setBgColor(index)
  io.stdout:write(string.format("%s48;5;%im", CSI, index))
end


local function drawSky()
  -- moveToStart();
  setBgColor(14);
  io.stdout:write(string.format("%s32;0;0;%i;%i$x", CSI, ROW, COLUMN));
  -- for i = 1, ROW, 1 do
  --   io.stdout:write(string.rep(" ", COLUMN));
  --   io.stdout:write("\n");
  -- end
end

-- io.stdout:setvbuf("line");

-- io.stdout:write(string.format("%s1;31mTesttt", CSI));


-- io.stdout:write(string.format("%s18t", CSI));
-- io.stdout:flush();
-- io.stdout:write("Ceci est un test");
-- io.stdout:seek("set", 0);
-- io.stdout:write("test");


-- io.stdout.setvbuf

-- io.stdout:flush();

init();

CUR_COL = 0
HEIGHT = 10

while true do
  moveToStart();
  drawSky();
  setBgColor(1);
  local width = math.min(10, COLUMN - CUR_COL)
  io.stdout:write(string.format("%s32;0;%i;%i;%i$x", CSI, CUR_COL, HEIGHT, CUR_COL + width))
  CUR_COL = CUR_COL + 1;
  if CUR_COL >= COLUMN then
    CUR_COL = 0
  end
  io.stdout:flush();
  sleep(1);
end

-- io.stdout:write("\x1B[10C");
-- io.stdout:write("Ceci est un test");

-- io.stdout:write("\x9B6n");

-- io.stdout:write(string.format("%c3;200;200t", CSI));

-- https://gist.github.com/ConnerWill/d4b6c776b509add763e17f9f113fd25
-- https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
-- io.stdout:write(string.format("%c[10;25H", ESC));
-- io.stdout:write("Ceci est un test");
-- Hide the cursor
-- io.stdout:write("\x1B[?25l")


-- HEIGHT = os.getenv("LINES");
-- WIDTH = os.getenv("COLUMNS");

-- print(WIDTH);
-- print(HEIGHT);


-- for line = 1, 1000, 1 do
--  io.stdout:write(string.format("%c[%i;0H", ESC, line));
--  io.stdout:write(string.format("Line: %i", line));
-- end

