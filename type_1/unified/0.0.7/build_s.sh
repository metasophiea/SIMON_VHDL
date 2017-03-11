#!/bin/bash
#remember to "chmod u+x build.sh"

#syntax check

ghdl -s printerlib.vhd
ghdl -s keyExpander.vhd
ghdl -s messageEncrypter.vhd
ghdl -s messageDecrypter.vhd
ghdl -s simon.vhd
ghdl -s tester.vhd