#!/bin/bash
#remember to "chmod u+x build.sh"

#syntax check

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