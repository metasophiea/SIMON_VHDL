#!/bin/bash
#remember to "chmod u+x build.sh"

#syntax check

ghdl -s printerlib.hdl
ghdl -s keyExpander.hdl
ghdl -s messageEncrypter.hdl
ghdl -s messageDecrypter.hdl
ghdl -s simon.hdl
ghdl -s tester.hdl