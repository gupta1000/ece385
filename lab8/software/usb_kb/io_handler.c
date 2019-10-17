//io_handler.c
#include "io_handler.h"
#include <stdio.h>

void IO_init(void)
{
	// see definitions in io_handler.h!!!
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
	*otg_hpi_data = 0;
	// Reset OTG chip
	*otg_hpi_cs = 0;
	*otg_hpi_reset = 0;
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
}

void IO_write(alt_u8 Address, alt_u16 Data)
{
	// write address to bus
	*otg_hpi_address = Address;
	// enable chip
	*otg_hpi_cs = 0;
	// signal beginning of write
	*otg_hpi_w = 0;
	// put data on bus to allow register to process write
	*otg_hpi_data = Data;
	// signal end of write
	*otg_hpi_w = 1;
	// disable chip
	*otg_hpi_cs = 1;
}

alt_u16 IO_read(alt_u8 Address)
{
	alt_u16 temp;

	// write address to bus
	*otg_hpi_address = Address;
	// enable chip
	*otg_hpi_cs = 0;

	// signal beginning of read
	*otg_hpi_r = 0;
	// put data on bus to allow register to process write
	temp = *otg_hpi_data;
	// signal end of write
	*otg_hpi_r = 1;
	// disable chip
	*otg_hpi_cs = 1;
//	printf("%x\n",temp);
	return temp;
}
