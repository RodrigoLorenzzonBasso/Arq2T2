/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;

char *IEEE_P_2592010699;
char *WORK_P_0932012748;
char *IEEE_P_3620187407;
char *STD_TEXTIO;
char *STD_STANDARD;
char *IEEE_P_3499444699;
char *WORK_P_2180760208;
char *IEEE_P_0774719531;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    std_textio_init();
    work_p_2180760208_init();
    work_p_0932012748_init();
    work_a_3613278437_3836892431_init();
    work_a_4249212076_3836892431_init();
    ieee_p_0774719531_init();
    work_a_4142870792_2164148148_init();
    work_a_0040013899_2164148148_init();
    work_a_3199023679_2995317124_init();
    work_a_0832606739_2725559894_init();
    work_a_2803968785_2164148148_init();
    work_a_2399776393_3027548060_init();
    work_a_3853510154_1351276808_init();
    work_a_3090079553_2543299806_init();
    work_a_1912994691_1912994691_init();


    xsi_register_tops("work_a_1912994691_1912994691");

    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    WORK_P_0932012748 = xsi_get_engine_memory("work_p_0932012748");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    STD_TEXTIO = xsi_get_engine_memory("std_textio");
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
    WORK_P_2180760208 = xsi_get_engine_memory("work_p_2180760208");
    IEEE_P_0774719531 = xsi_get_engine_memory("ieee_p_0774719531");

    return xsi_run_simulation(argc, argv);

}
