# SIMON_VHDL

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;For my final year project in college, I was asked to develop an implementation of the SIMON block ciphers in VHDL, and review my design’s performance regarding logical efficiency and hardware usage. This repo was used in the development of this project. Here one can find the three VHDL designs I created, sorted into types 1, 2 and 3

## Contents
- [Folder Layout](#folder-layout)
- [Developed Designs](#developed-designs)
    - [Type 1 - Flow Logic](#type-1---flow-logic)
    - [Type 2 - Register Transfer Level](#type-2--register-transfer-level)
    - [Type 3 - Crypto-Processor](#type-3--crypto-processor)

## Folder Layout

- documents
    - demo
        - c++
        - files
        - java
            - monitorSide
            - piSide
        - vhdl
    - images
    - implementation
        - samples
        - system
    - zybo
- type_1
    - computerside
    - method
    - unified
- type_2
    - computerside
    - method
    - unified
- type_3
    - computerside
    - method
    - modeAndMethod_encryptOnly
    - unified

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The documents folder contains the demo files and handy simon-cipher related information.
- 'demo' contains a complete set of java, c++ and VHDL files for use in demonstrating the design. One can load the VHDL design onto a development board, compile the c++ code on a Raspberry Pi (attached to the development board) and compile the Java programs on both the Pi and a display machine (networked together) The result is a pretty snazzy encryption program, which encrypts images, shows you the encrypted image, then decrypts it. You can see it in action here: [Simon Encryption Java/C++/VHDL Demonstration](https://www.youtube.com/watch?v=CTbJnPhZdKI&t=8s)
- 'images' is just a folder of pictures used in this document
- The 'implementation' folder is basically a hosting area for a webPaper which can be found here: [webPaper.html](http://metasophiea.com/projects/simon/webPaper.html)
- 'zybo': The board I used to test my designs (and work with the Raspberry Pi) is the "Zybo Zynq-7000 ARM/FPGA Development Board", which I got on lend from my project supervisor. It's essentially a FPGA chip with alot of ports to work with (and a ARM processor, but I never used it) which I usually refer to just as "zybo" or "the development board".
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This folder contains a VHDL file used to connect the 24 pins of my designs to the 24 zybo pin ports. There is also a file with information about connecting the Raspberry Pi to the Zybo, and a "configuration" file used by the development software to impliment the design for this board.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Each of the "type_x" folders contain the subtype folders, along with testing notes and sometimes general notes. The subtype folers contain the actual VHDL code, which is explained later in this document. The 'testing notes' files contain information on the designs generated from the VHDL code, in regards to architecture size, estimated power usage, etc. The 'notes' files contain extra data needed to synthesize the design.<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In addition; each folder contains a 'computerside' folder, which contains c++ code writting for the Raspberry Pi. This code can be used to interface with the design, to encrypt messages, etc. This code is somewhat slowing, as it uses the Linux file-system to access the pins. Other pin access method files are available in the demo section of the documents folder, which increases pin access considerably.

## Developed Designs

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The three different designs are; Flow Logic, Register Transfer Level and the Crypto-Processor. Each design is split into subtypes; unified, methods (and in design three, modeAndMethods) These different subtypes split out the functionality of the cipher, allowing a designer the ability to choose the level of encryption complexity they want, or the range of encryption functions available.

#### Subtypes
- unified<br/>
    These allow the system to encrypt or decrypt with any of the methods

- methods<br/>
    These are a collection that specialize in one particular method, though allow encryption or decryption. They are much smaller than the unified version

- modeAndMethods<br/>
    These are a collection that specializes in one particular method and mode. They are the smallest of the collections.

### Type 1 - Flow Logic

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The flow logic design lays out the cipher in its entirety, allowing the user to pass data into the input and have it flow through all the required modules to produce a result. It is a pure combinational logic design, and as such no clock signal is needed. In this developed implementation, the encrypted and decrypted output is computed at the same time, with and additional ‘mode’ input determining which result to output.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Though not as optimised for through-put or size as the designs ahead; its simple layout and similarity to the basic model presented in the NSA’s paper servers as a good starting point for understanding the system.

<p align="center">
    <img width="300" height="460" src="https://raw.githubusercontent.com/metasophiea/SIMON_VHDL/master/documents/images/flowLogic.png">
</p>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The encryption and decryption modules are tied together, so for the unified subtype an additional 4-bit input determining the method is used. This method value is passed to each encryptor/decryptor module, wherein the module can determine whether to process the message or let it pass through. This is done because the unified subtype must have enough encryptor/decryptor modules for the largest possible required stage number - 72, but different methods need a different amount of stages. Thus giving the encryptor/decryptor modules the ability to decide whether they should perform work or not, automatically adjusts the number of stages.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Though more complicated than other subtypes, devices incorporating this “multi-method” design would be able to communicate with a device using any form of the cipher.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This decision-making ability is only useful in the unified subtype and is removed in the other subtypes, where the number of stages is hardwired in. Below is a diagram of the unified subtype encrypting and decrypting a message of method 1. You can notice how the encryption and decryption modules decide whether to process the message or allow it to pass through, dependent on their position in the system.

<p align="center">
    <img width="600" height="594" src="https://raw.githubusercontent.com/metasophiea/SIMON_VHDL/master/documents/images/typeOne_unified_deciding.png">
</p> 

#### Advantages

- can allow encryption/decryption to occur in a single clock cycle, however this restricts the maximum clock frequency
- encrypting/decrypting messages with the different keys takes no longer than encrypting/decrypting with the same key

#### Disadvantages

- as all the modules are being laid out in their entirety, the design takes up a large space
- much of the circuitry does nothing for the majority of the flow time

### Type 2 – Register Transfer Level

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The Register Transfer Level design expands upon the previous design, addressing the issue of inactive modules. Here, every encryption and decryption module is separated out between registers, which can store the intermediate results of the encryption/decryption progress of a message. The key is completely expanded at the very first stage, and this data is passed through to the registers as well. In this way, all parts of the circuit can be utilised for processing different messages in a pipeline.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Similar to the previous design, the unified subtype has a 4-bit input determining the method to be used. This information is also stored by each register block and passes through the system alongside the message. This data is given to each encryptor/decryptor module as before.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In addition; anther one bit input connection is used. This is for the external clock, which controls the progress of the messages through the system. For every tick; a message progresses by one stage.

<p align="center">
    <img width="376" height="640" src="https://raw.githubusercontent.com/metasophiea/SIMON_VHDL/master/documents/images/registerLogic_layoutDiagram.png">
</p> 

#### Advantages

- multiple messages can be encrypted/decrypted in pipeline and almost simultaneously allowing for a greater throughput of messages.
- though the initial key expansion costs time; encrypting/decrypting batches of messages with the same key is quite efficient. As no key expansion time has to be factored in; the system could be run at a higher clock rate, in addition to benefiting from the near simultaneous encryption/decryption.

#### Disadvantages

- this is the largest of the designs, as not only does it contain all the circuitry of the previous design, but now there is a block of pipeline registers for each stage.

- having the key completely expanded at the first stage can cost a lot of time, and the amount of individual registers in the register blocks required to store this information for each stage of encryption/decryption, means that the design grows quite large.<br/>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This design decision was made, as for decryption; the first decryptor module requires the last expanded key, thus the key must be expanded in its entirety before any work can begin. As the lead concept in this design was to improve flow-through in the system, the encryption mode has to run at the same speed as decryption. Thus, the initial key expansion is also done for encryption.<br/>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;As you would expect, an encryption mode only subtype wouldn’t  require such initial processing.

### Type 3 – Crypto-Processor

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This design takes the concept of multi-staged encryption from the previous design, and distils it down into a single repeatable process. Instead of having a set of encryption and decryption modules for each stage; only one encryption and decryption module is implemented and are used repeatedly to perform encryption/decryption operations. This means that the finished implementation can take up a much smaller hardware footprint than previous designs.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Similar to the Register Transfer Level design, the provided key must be fully expanded before any encryption or decryption can begin; however this particular design contains a "modeAndMethods" subtype for encryption only, which does not need such complete key expansion time and thus only requires a fraction of the key expansion logic and registers.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Like the previous two versions, for the unified subtype an additional 4-bit input determining the method is used. This information is stored by a register block for use with the encryptor/decryptor modules similar to before. This version also has a one bit input for the external clock, which controls the progress of the messages through the system. As before, for every tick; a message progresses by one stage.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Importantly; this version has a final single bit input for loading the register block. The main package for this system splits the input message, key and control data into two register blocks; one for the incoming message, and one for the currently processing message. When the load connection is activated, the first set of data is copied into the second. In this way; the internal processing can go unaffected while a new job is loaded in.

<p align="center">
    <img width="376" height="640" src="https://raw.githubusercontent.com/metasophiea/SIMON_VHDL/master/documents/images/simonProcessor_layoutDiagram.png">
</p> 

#### Advantages

- smallest hardware footprint

#### Disadvantages

- only one message can be processed at a time
- complete key expansion time (for 'unified' and 'methods' subtypes)