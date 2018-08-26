##Clock signal
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L11P_T1_SRCC_35 Sch=sysclk

##Switches
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { stop }]; #IO_L19N_T3_VREF_35 Sch=SW0

##Buttons
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { rset }]; #IO_L20N_T3_34 Sch=BTN0

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets rset]

##Pmod Header JC
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { RS }]; #IO_L10P_T1_34 Sch=JC1_P
set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports { RW }]; #IO_L10N_T1_34 Sch=JC1_N
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { E }]; #IO_L1P_T0_34 Sch=JC2_P
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { alarm }]; #IO_L1N_T0_34 Sch=JC2_N

##Pmod Header JD
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { D[0] }]; #IO_L5P_T0_34 Sch=JD1_P
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { D[1] }]; #IO_L5N_T0_34 Sch=JD1_N
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { D[2] }]; #IO_L6P_T0_34 Sch=JD2_P
set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { D[3] }]; #IO_L6N_T0_VREF_34 Sch=JD2_N
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { D[4] }]; #IO_L11P_T1_SRCC_34 Sch=JD3_P
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports { D[5] }]; #IO_L11N_T1_SRCC_34 Sch=JD3_N
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { D[6] }]; #IO_L21P_T3_DQS_34 Sch=JD4_P
set_property -dict { PACKAGE_PIN V18   IOSTANDARD LVCMOS33 } [get_ports { D[7] }]; #IO_L21N_T3_DQS_34 Sch=JD4_N
##Pmod Header JE
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { row[0] }]; #IO_L4P_T0_34 Sch=JE1
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { row[1] }]; #IO_L18N_T2_34 Sch=JE2
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { row[2] }]; #IO_25_35 Sch=JE3
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { row[3] }]; #IO_L19P_T3_35 Sch=JE4
set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports { col[0] }]; #IO_L3N_T0_DQS_34 Sch=JE7
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { col[1] }]; #IO_L9N_T1_DQS_34 Sch=JE8
set_property -dict { PACKAGE_PIN T17   IOSTANDARD LVCMOS33 } [get_ports { col[2] }]; #IO_L20P_T3_34 Sch=JE9
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33 } [get_ports { col[3] }]; #IO_L7N_T1_34 Sch=JE10

##LEDs
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { led[0] }]; #IO_L23P_T3_35 Sch=LED0
set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { led[1] }]; #IO_L23N_T3_35 Sch=LED1
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { led[2] }]; #IO_0_35=Sch=LED2
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]; #IO_L3N_T0_DQS_AD1N_35 Sch=LED3
