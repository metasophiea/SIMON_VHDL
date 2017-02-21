#!/bin/bash
#remember to "chmod u+x build.sh"

#complete build and run

ghdl -s printerlib.hdl
ghdl -s keyExpander.hdl
ghdl -s messageEncrypter.hdl
ghdl -s messageDecrypter.hdl
ghdl -s simon_32_64.hdl
ghdl -s simon_48_72.hdl
ghdl -s simon_48_96.hdl
ghdl -s simon_64_96.hdl
ghdl -s simon_64_128.hdl
ghdl -s simon_96_96.hdl
ghdl -s simon_96_144.hdl
ghdl -s simon_128_128.hdl
ghdl -s simon_128_192.hdl
ghdl -s simon_128_256.hdl
ghdl -s main.hdl
ghdl -s tester.hdl

ghdl -a printerlib.hdl
ghdl -a keyExpander.hdl
ghdl -a messageEncrypter.hdl
ghdl -a messageDecrypter.hdl
ghdl -a simon_32_64.hdl
ghdl -a simon_48_72.hdl
ghdl -a simon_48_96.hdl
ghdl -a simon_64_96.hdl
ghdl -a simon_64_128.hdl
ghdl -a simon_96_96.hdl
ghdl -a simon_96_144.hdl
ghdl -a simon_128_128.hdl
ghdl -a simon_128_192.hdl
ghdl -a simon_128_256.hdl
ghdl -a main.hdl
ghdl -a tester.hdl

ghdl -e tester

./tester --stop-time=1000ns