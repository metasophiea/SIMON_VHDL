#!/bin/bash
#remember to "chmod u+x build.sh"

#complete build and run

ghdl -s printerlib.hdl
ghdl -s keyExpander_32_64.hdl
ghdl -s messageEncrypter_32_64.hdl
ghdl -s messageDecrypter_32_64.hdl
ghdl -s simon_32_64.hdl
ghdl -s main.hdl
ghdl -s tester.hdl

ghdl -a printerlib.hdl
ghdl -a keyExpander_32_64.hdl
ghdl -a messageEncrypter_32_64.hdl
ghdl -a messageDecrypter_32_64.hdl
ghdl -a simon_32_64.hdl
ghdl -a main.hdl
ghdl -a tester.hdl

ghdl -e tester

./tester --stop-time=1000ns