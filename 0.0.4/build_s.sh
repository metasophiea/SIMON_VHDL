#!/bin/bash
#remember to "chmod u+x build.sh"

#syntax check

ghdl -s printerlib.hdl
ghdl -s keyExpander.hdl
ghdl -s messageEncrypter.hdl
ghdl -s messageDecrypter.hdl
ghdl -s simon_32_64.hdl
ghdl -s simon_48_72.hdl
ghdl -s main.hdl
ghdl -s tester.hdl