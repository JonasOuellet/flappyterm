require("lib.screen")
require("lib.geo")

local function testPts()
  local p1 = Point:origin();
  local p2 = Point:new(10, 10);

  local p3 = p1 + p2;
  assert(p3.x == 10, "X should be 10")
  assert(p3.y == 10, "Y should be 10")
end


testPts()


local function testPts2()
  local p2 = Point:new(10, 10);
  local p4 = p2 - Point:new(2, 5);
  assert(p4.x == 8, "X should be 8")
  assert(p4.y == 5, "Y should be 5")
end

testPts2()


local function testScreenMappingOrigin()
  local test = Screen:new(10, 10)
  local pos = Point:origin()
  local res = test:mapPoint(pos)
  assert(res.x == 0, string.format("Screen pos x should be 0 got %f", res.x))
  assert(res.y == 10, string.format("Screen pos y should be 10 got %f", res.y))
end

testScreenMappingOrigin()


local function testScreenMappingTopLeft()
  local test = Screen:new(10, 10)
  local pos = Point:new(0, 10)
  local res = test:mapPoint(pos)
  assert(res.x == 0, string.format("Screen pos x should be 0 got %f", res.x))
  assert(res.y == 0, string.format("Screen pos y should be 0 got %f", res.y))
end

testScreenMappingTopLeft()


local function testScreenMappingTopRight()
  local test = Screen:new(10, 10)
  local pos = Point:new(10, 10)
  local res = test:mapPoint(pos)
  assert(res.x == 10, string.format("Screen pos x should be 10 got %f", res.x))
  assert(res.y == 0, string.format("Screen pos y should be 0 got %f", res.y))
end

testScreenMappingTopRight()


local function testScreenMappingBotRight()
  local test = Screen:new(10, 10)
  local pos = Point:new(10, 0)
  local res = test:mapPoint(pos)
  assert(res.x == 10, string.format("Screen pos x should be 10 got %f", res.x))
  assert(res.y == 10, string.format("Screen pos y should be 10 got %f", res.y))
end

testScreenMappingBotRight()




local function testScreenMappingTopRight()
  local test = Screen:new(10, 10)
  local pos = Point:new(10, 10)
  local res = test:mapPoint(pos)
  assert(res.x == 10, string.format("Screen pos x should be 10 got %f", res.x))
  assert(res.y == 0, string.format("Screen pos y should be 0 got %f", res.y))
end

testScreenMappingTopRight()


local function testScreenMappingTopRight()
  local test = Screen:new(10, 10)
  local pos = Point:new(10, 10)
  local res = test:mapPoint(pos)
  assert(res.x == 10, string.format("Screen pos x should be 10 got %f", res.x))
  assert(res.y == 0, string.format("Screen pos y should be 0 got %f", res.y))
end

testScreenMappingTopRight()


local function testScreenMappingTopRight()
  local test = Screen:new(10, 10)
  local pos = Point:new(10, 10)
  local res = test:mapPoint(pos)
  assert(res.x == 10, string.format("Screen pos x should be 10 got %f", res.x))
  assert(res.y == 0, string.format("Screen pos y should be 0 got %f", res.y))
end

testScreenMappingTopRight()


local function testScreenMappingTopRight()
  local test = Screen:new(10, 10)
  local pos = Point:new(10, 10)
  local res = test:mapPoint(pos)
  assert(res.x == 10, string.format("Screen pos x should be 10 got %f", res.x))
  assert(res.y == 0, string.format("Screen pos y should be 0 got %f", res.y))
end

testScreenMappingTopRight()


local function testScreenMappingTopRight()
  local test = Screen:new(10, 10)
  local pos = Point:new(10, 10)
  local res = test:mapPoint(pos)
  assert(res.x == 10, string.format("Screen pos x should be 10 got %f", res.x))
  assert(res.y == 0, string.format("Screen pos y should be 0 got %f", res.y))
end

testScreenMappingTopRight()


