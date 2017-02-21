#!/bin/bash
#remember to "chmod u+x build.sh"

#complete build and run

ghdl -s printerlib.vhd
ghdl -s keyExpander.vhd
ghdl -s messageEncrypter.vhd
ghdl -s messageDecrypter.vhd
ghdl -s simon.vhd
ghdl -s tester.vhd

ghdl -a printerlib.vhd
ghdl -a keyExpander.vhd
ghdl -a messageEncrypter.vhd
ghdl -a messageDecrypter.vhd
ghdl -a simon.vhd
ghdl -a tester.vhd

ghdl -e tester

./tester --stop-time=1000ns