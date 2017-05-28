# SIMON_VHDL

For my final year project in college, I was asked to develop an implementation of the SIMON block ciphers in VHDL, and review my design’s performance regarding logical efficiency and hardware usage. This repo was used in the development of this project. Here one can find the three VHDL designs I created, sorted into types 1, 2 and 3

- Type 1 - Flow Logic

    The flow logic design lays out the cipher in its entirety, allowing the user to pass data into the input and have it flow through all the required modules to produce a result. It is a pure combinational logic design, and as such no clock signal is needed. In this developed implementation, the encrypted and decrypted output is computed at the same time, with and additional ‘mode’ input determining which result to output.

    Though not as optimised for through-put or size as the designs ahead; its simple layout and similarity to the basic model presented in the NSA’s paper servers as a good starting point for understanding the system.

    <p align="center">
        <img width="300" height="460" src="https://raw.githubusercontent.com/metasophiea/SIMON_VHDL/master/documents/images/flowLogic.png">
    </p>

    The encryption and decryption modules are tied together, so for the unified subtype an additional 4-bit input determining the method is used. This method value is passed to each encryptor/decryptor module, wherein the module can determine whether to process the message or let it pass through. This is done because the unified subtype must have enough encryptor/decryptor modules for the largest possible required stage number - 72, but different methods need a different amount of stages. Thus giving the encryptor/decryptor modules the ability to decide whether they should perform work or not, automatically adjusts the number of stages.

    Though more complicated than other subtypes, devices incorporating this “multi-method” design would be able to communicate with a device using any form of the cipher.

    This decision-making ability is only useful in the unified subtype and is removed in the other subtypes, where the number of stages is hardwired in. Below is a diagram of the unified subtype encrypting and decrypting a message of method 1. You can notice how the encryption and decryption modules decide whether to process the message or allow it to pass through, dependent on their position in the system.

    <p align="center">
        <img width="600" height="594" src="https://raw.githubusercontent.com/metasophiea/SIMON_VHDL/master/documents/images/typeOne_unified_deciding.png">
    </p> 

## Advantages

## writingDisadvantages

- Type 2 – Register Transfer Level

    The Register Transfer Level design expands upon the previous design, addressing the issue of inactive modules. Here, every encryption and decryption module is separated out between registers, which can store the intermediate results of the encryption/decryption progress of a message. The key is completely expanded at the very first stage, and this data is passed through to the registers as well. In this way, all parts of the circuit can be utilised for processing different messages in a pipeline.

    Similar to the previous design, the unified subtype has a 4-bit input determining the method to be used. This information is also stored by each register block and passes through the system alongside the message. This data is given to each encryptor/decryptor module as before.

    In addition; anther one bit input connection is used. This is for the external clock, which controls the progress of the messages through the system. For every tick; a message progresses by one stage.

- Type 3 – Crypto-Processor

    This design takes the concept of multi-staged encryption from the previous design, and distils it down into a single repeatable process. Instead of having a set of encryption and decryption modules for each stage; only one encryption and decryption module is implemented and are used repeatedly to perform encryption/decryption operations. This means that the finished implementation can take up a much smaller hardware footprint than previous designs.

    Similar to the Register Transfer Level design, the provided key must be fully expanded before any encryption or decryption can begin; however this particular design contains a "modeAndMethods" subtype for encryption only, which does not need such complete key expansion time and thus only requires a fraction of the key expansion logic and registers.

    Like the previous two versions, for the unified subtype an additional 4-bit input determining the method is used. This information is stored by a register block for use with the encryptor/decryptor modules similar to before. This version also has a one bit input for the external clock, which controls the progress of the messages through the system. As before, for every tick; a message progresses by one stage.

    Importantly; this version has a final single bit input for loading the register block. The main package for this system splits the input message, key and control data into two register blocks; one for the incoming message, and one for the currently processing message. When the load connection is activated, the first set of data is copied into the second. In this way; the internal processing can go unaffected while a new job is loaded in.