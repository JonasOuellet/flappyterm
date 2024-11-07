---@diagnostic disable: lowercase-global

local lunatest = require("lunatest")

require("lib.screen")
require("lib.geo")


function test_point_add()
  local p1 = Point:origin();
  local p2 = Point:new(10, 10);

  local p3 = p1 + p2;
  lunatest.assert_equal(p3.x, 10)
  lunatest.assert_equal(p3.y, 10)
end


function test_point2_subtract()
  local p2 = Point:new(10, 10);
  local p4 = p2 - Point:new(2, 5);
  lunatest.assert_equal(p4.x, 8, "(10 - 2 = 8)")
  lunatest.assert_equal(p4.y, 5, "(10 - 5 = 5)")
end


function test_screen_mapping_origin()
  local test = Screen:new(10, 10)
  local pos = Point:origin()
  local res = test:mapPoint(pos)
  lunatest.assert_equal(res.x, 0, string.format("Screen pos x should be 0 got %f", res.x))
  lunatest.assert_equal(res.y, 10, string.format("Screen pos y should be 10 got %f", res.y))
end


function test_screen_mapping_top_left()
  local test = Screen:new(10, 10)
  local pos = Point:new(0, 10)
  local res = test:mapPoint(pos)
  lunatest.assert_equal(res.x, 0, string.format("Screen pos x should be 0 got %f", res.x))
  lunatest.assert_equal(res.y, 0, string.format("Screen pos y should be 0 got %f", res.y))
end


function test_screen_mapping_top_right()
  local test = Screen:new(10, 10)
  local pos = Point:new(10, 10)
  local res = test:mapPoint(pos)
  lunatest.assert_equal(res.x, 10, string.format("Screen pos x should be 10 got %f", res.x))
  lunatest.assert_equal(res.y, 0, string.format("Screen pos y should be 0 got %f", res.y))
end


function test_screen_mapping_bot_right()
  local test = Screen:new(10, 10)
  local pos = Point:new(10, 0)
  local res = test:mapPoint(pos)
  lunatest.assert_equal(res.x, 10, string.format("Screen pos x should be 10 got %f", res.x))
  lunatest.assert_equal(res.y, 10, string.format("Screen pos y should be 10 got %f", res.y))
end


lunatest.run()

