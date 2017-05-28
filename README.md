# SIMON_VHDL

For my final year project in college, I was asked to develop an implementation of the SIMON block ciphers in VHDL, and review my design’s performance regarding logical efficiency and hardware usage. This repo was used in the development of this project. Here one can find the three VHDL designs I created, sorted into types 1, 2 and 3

- Type 1 - Flow Logic

The flow logic design lays out the cipher in its entirety, allowing the user to pass data into the input and have it flow through all the required modules to produce a result. It is a pure combinational logic design, and as such no clock signal is needed. In this developed implementation, the encrypted and decrypted output is computed at the same time, with and additional ‘mode’ input determining which result to output.
Though not as optimised for through-put or size as the designs ahead; its simple layout and similarity to the basic model presented in the NSA’s paper servers as a good starting point for understanding the system.

- Type 2
- Type 3