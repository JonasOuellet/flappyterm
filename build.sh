#!/bin/bash
gcc -W -Wall -c -fPIC flappylib.c -o flappylib.o
gcc -W -Wall -shared -o flappylib.so flappylib.o -lncurses -ltinfo

