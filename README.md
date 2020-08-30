# Signal-Generator
Signal Generator, will not function due to file open function necessary to grab Sin wave function


AC97_Control - Module that defines communication to on-chip codec. Breaking it down based on frame to a 23Mhz clock.

slot_fsm - Inputs waveform signals and switch that determines the frame to communicate with the codec. Using an if-else statement that instantiates a multiplexer
            to a designated portion of the frame.

slowClocks.v [Defunct] - Initially developed to help generate waveforms at designated frequency of hearing, from 20Khz to 20hz, where instead it simply lowered the
                          the clock speed enough to communicate with the codec. Thus hopes synthesizer compiler removes the rest of the
                          clock division.


lab5_test.v - Function that we use to generate output to Jpin into an Oscilloscope to see if waveform/chip communication met timing requirements. 

lab5.v - Has three modules in unit, focuses on AC frame generator hardcoded, bitFrame count to assure the necessary signal communicates to the codec,
         while the rest is the top-level that contributes to our I/O handling of switches and buttons.
         
Will continue later while adding in files.
