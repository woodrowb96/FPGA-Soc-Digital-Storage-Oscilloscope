This folder has pictures of the schematic for the circuit I desisgned for the analog front end and trigger blocks in the system.

The analog front end circuit has two op amps. The first is used to buffer the signal and create a 1Meg input resistance to the scope. 
This 1Meg input resistance is used with the scope probes to create the x1 and x10 attenuation modes. The second op amp is used as a level 
shifter. This level shifter shifts the signal up by Vcc/2 and inverts it. This is used to make sure the signal we are measuring is positve when
it goes into the ADC. The equation for the level shifter transformation is Vout = Vcc/2 - Vin.

There is also a coupling capacitor at the input that is used to switch the scope between AC and DC coupling modes.

The trigger circuit has a DAC and comparator that are used to generate a trigger signal and trigger the signal.

There is also a picure and gerber files for a PCB that I designed and built to test these blocks.
