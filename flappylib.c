#include <lua5.1/lauxlib.h>
#include <stdio.h>
#include <lua5.1/lua.h>
#include <ncurses.h>


int hello_wrapper(lua_State* L) {
  printf("Hello World\n");
  return 0;
}


int init_window(lua_State* L) {
 	initscr();
	raw();
  noecho();
  return 0;
}

int close_window(lua_State* L) {
  endwin();
  return 0;
}


int window_size(lua_State* L) {

  int row, col = 0;
  getmaxyx(stdscr, row, col);
  lua_pushinteger(L, row);
  lua_pushinteger(L, col);

  return 2;
}


int get_ch(lua_State* L) {
  int timeout = luaL_checkint(L, 1);
  timeout(timeout);
  char c = getch();
  lua_pushinteger(L, c);
  return 1;
}



const struct luaL_reg flappylib [] = {
  {"hello", hello_wrapper},
  {"init_window", init_window},
  {"close_window", close_window},
  {"window_size", window_size},
  {"get_ch", get_ch},
  {0, 0} // sentinel
};


int luaopen_flappylib(lua_State* L) {
  luaL_openlib(L, "flappylib", flappylib, 0);
  return 1;
}


