/*
 * Mic_Array_linux.h
 *
 *  Created on: 1 juin 2016
 *      Author: azcarret
 */

#ifndef MIC_ARRAY_LINUX_H_
#define MIC_ARRAY_LINUX_H_
#include <stdbool.h>
#include <stdint.h>

#include "socal/hps.h"
#include "Mic_Array_soc.h"


void   *h2f_lw_axi_master     = NULL;
size_t h2f_lw_axi_master_span = ALT_LWFPGASLVS_UB_ADDR - ALT_LWFPGASLVS_LB_ADDR + 1;
size_t h2f_lw_axi_master_ofst = ALT_LWFPGASLVS_OFST;

void *fpga_SPI_System = NULL; // Assign NULL value because we do not have an exact address to be assigned (NULL pointer)

#endif /* HPS_LINUX_H_ */
