#!/bin/bash
#remember to "chmod u+x build.sh"

#complete build and run

ghdl -s printerlib.hdl
ghdl -s keyExpander.hdl
ghdl -s messageEncrypter.hdl
ghdl -s messageDecrypter.hdl
ghdl -s simon.hdl
ghdl -s tester.hdl

ghdl -a printerlib.hdl
ghdl -a keyExpander.hdl
ghdl -a messageEncrypter.hdl
ghdl -a messageDecrypter.hdl
ghdl -a simon.hdl
ghdl -a tester.hdl

ghdl -e tester

./tester --stop-time=1000ns