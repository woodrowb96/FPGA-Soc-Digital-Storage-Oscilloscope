# Digital-Storage-Oscilloscope

This repository is for my digital storage oscilloscope project.

This project is a year long project with two other students to build a two channel digital storage oscilloscope
using the Cyclone V FPGA SOC. The FPGA half of the chip is used to aquire data, and the Soc half of the chip is used to display that dat onto a GUI. The two halfs of the chip communicate over a pair of axi bridges. This is a yearlong project and is ongoing. The project will be complete during spring term 2020. 

I am responsible for three blocks within the system. The analog front end block, the trigger block, 
and the data aquesition controll logic block.

The analog front end block is repsonsible for filtering the two analog voltages that we are measuring with the scope, and for sending
those voltages into adc's to be sampled. This block is completely on the PCB.

The trigger block is used to generate a trigger signal, that is used by the data aquisition control logic block to trigger the signals we are measuring. This block is partially on the PCB and partially on the FPGA. On the PCB there is a DAC and comparator. The DAC is used to generate a trigger voltage that is sent to a comparator. The DAC is controlled over SPI by the FPGA. The comparator compares the trigger voltage and the analog voltage of the wave we are measuring, and outputs a signal that is sent to the data aq contnrol logic block. There is also a pair of rotary encoders that are used to change the trigger level.
On the FPGA there is logic which decodes the Rotary encoders, and that interfaces with the DAC over SPI.

The data acquesition block is responsible for storing data into memory that can be accesed by the Soc and displayed on a GUI. 
Inside this block there is a state machine that controlles the triggering process. This state machine looks at the trigger signal and
uses it to determine how data is stored in memory. The memory used to store data is in the form of on chip block dual port block ram within the FPGA. One port of the RAM is used by the FPGA to wirte samples into memory. This port is connected to a memory controller, which is controlled by the trigger state machine. The other port of the RAM is connected to the axi bridge and is used to give the Soc access to the memory so that it can read out smaples. 
