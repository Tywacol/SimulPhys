#!/bin/bash

xterm -e "echo \"toto\" | nc localhost 5010 >| nc_res.txt"
