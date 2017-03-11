#!/bin/bash
#remember to "chmod u+x build.sh"

#syntax check

ghdl -s printerlib.hdl
ghdl -s keyExpander_32_64.hdl
ghdl -s messageEncrypter_32_64.hdl
ghdl -s messageDecrypter_32_64.hdl
ghdl -s simon_32_64.hdl
ghdl -s main.hdl
ghdl -s tester.hdl