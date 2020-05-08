#!/bin/bash

xterm -e './client.py localhost 5010 user1' &
xterm -e 'python3 client.py localhost 5010 user2' &
xterm -e 'python3 client.py localhost 5010 user3' &
