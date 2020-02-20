This module is controlles the DAC's used in the trigger for the scope.

This block decodes a pair of roatary encoders, that are used to set the 
reference level in the DAC's. This ref level is sent over SPI to the DAC.

Data used to set the output of the DAC is sent using SPI. 
The spi_mosi module only has the master out part implemented, since
there is no need to read data from the DAC's. 
